#!/usr/bin/env node
import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { spawn } from "node:child_process";

const PROTOCOL = 19;
const SESSION = "casebook-trial";

function execute(executable, args, env = process.env) {
  return new Promise((resolve, reject) => {
    const child = spawn(executable, args, { env, shell: false, stdio: ["ignore", "pipe", "pipe"] });
    let stdout = "";
    let stderr = "";
    child.stdout.setEncoding("utf8").on("data", chunk => stdout += chunk);
    child.stderr.setEncoding("utf8").on("data", chunk => stderr += chunk);
    child.once("error", reject);
    child.once("close", status => status === 0 ? resolve(stdout) : reject(new Error(`command failed (${status}): ${stderr.trim()}`)));
  });
}

async function canonicalPath(value) {
  return fs.realpath(value);
}

function contains(root, candidate) {
  const relative = path.relative(root, candidate);
  return relative === "" || (!relative.startsWith(`..${path.sep}`) && relative !== "..");
}

async function projectForAgent(projects, agent) {
  const cwd = await canonicalPath(agent.foreground_cwd || agent.cwd);
  const matches = [];
  for (const project of projects) {
    if (project.reconciliationState !== "current" || !path.isAbsolute(project.declaredRoot || "")) continue;
    const root = await canonicalPath(project.declaredRoot);
    if (contains(root, cwd)) matches.push(project);
  }
  return matches.length === 1 ? matches[0] : null;
}

function validAgent(agent) {
  const official = agent?.agent_session;
  return official?.source === "herdr:opencode" && official.agent === "opencode" && official.kind === "id"
    && typeof official.value === "string" && official.value.length !== 0
    && [agent.workspace_id, agent.tab_id, agent.pane_id, agent.terminal_id].every(value => typeof value === "string" && value.length !== 0);
}

function bindingKey(binding) {
  return JSON.stringify([binding.workspaceId, binding.tabId, binding.paneId, binding.terminalId]);
}

async function newCanonicalId() {
  const uuid = (await execute("/usr/bin/uuidgen", [])).trim();
  if (!uuid) throw new Error("uuidgen returned no identity");
  return `agent-conversation:${uuid}`;
}

async function writeAtomic(file, value) {
  const parent = path.dirname(file);
  await fs.mkdir(parent, { recursive: true, mode: 0o700 });
  const temp = path.join(parent, `.${path.basename(file)}.${process.pid}.${Date.now()}.tmp`);
  const handle = await fs.open(temp, "wx", 0o600);
  try {
    await handle.writeFile(`${JSON.stringify(value, null, 2)}\n`, "utf8");
    await handle.sync();
  } finally {
    await handle.close();
  }
  await fs.rename(temp, file);
  const directory = await fs.open(parent, "r");
  try { await directory.sync(); } finally { await directory.close(); }
}

async function reconcile(env = process.env) {
  if (!path.isAbsolute(env.HERDR_BIN_PATH || "") || !path.isAbsolute(env.HERDR_CONFIG_PATH || "") || !path.isAbsolute(env.HERDR_SOCKET_PATH || "")) {
    throw new Error("Herdr route proof is unavailable");
  }
  const stateHome = env.XDG_STATE_HOME || path.join(env.HOME || os.homedir(), ".local", "state");
  const registryPath = path.join(stateHome, "herdr", "trials", "casebook", "bindings", "registry.json");
  const registry = JSON.parse(await fs.readFile(registryPath, "utf8"));
  if (registry?.schemaVersion !== 1 || registry.route?.sessionName !== SESSION || registry.route?.protocol !== PROTOCOL) {
    throw new Error("canonical registry route is invalid");
  }

  const response = JSON.parse(await execute(env.HERDR_BIN_PATH, ["--session", SESSION, "agent", "list"], env));
  const agents = response?.result?.agents;
  if (!Array.isArray(agents)) throw new Error("Herdr returned an invalid agent list");

  let changed = false;
  for (const agent of agents.filter(validAgent)) {
    const project = await projectForAgent(registry.projects, agent);
    if (!project) continue;
    const matches = registry.sessions.filter(record => record.officialAgentSession?.source === agent.agent_session.source
      && record.officialAgentSession?.agent === agent.agent_session.agent
      && record.officialAgentSession?.kind === agent.agent_session.kind
      && record.officialAgentSession?.value === agent.agent_session.value);
    if (matches.length > 1) continue;

    const binding = { workspaceId: agent.workspace_id, tabId: agent.tab_id, paneId: agent.pane_id, terminalId: agent.terminal_id };
    const bindingOwner = registry.sessions.find(record => bindingKey(record.binding) === bindingKey(binding)
      && !matches.includes(record));
    if (bindingOwner) continue;
    if (matches.length === 1) {
      const record = matches[0];
      const moved = Object.entries(binding).some(([key, value]) => record.binding?.[key] !== value);
      if (record.projectCanonicalId !== project.canonicalId || record.reconciliationState !== "current" || moved) {
        record.projectCanonicalId = project.canonicalId;
        record.reconciliationState = "current";
        record.binding = binding;
        if (moved) record.generation += 1;
        changed = true;
      }
      continue;
    }

    registry.sessions.push({
      canonicalId: await newCanonicalId(),
      projectCanonicalId: project.canonicalId,
      generation: 1,
      reconciliationState: "current",
      role: "interaction",
      officialAgentSession: agent.agent_session,
      binding,
    });
    changed = true;
  }

  if (changed) await writeAtomic(registryPath, registry);
}

reconcile().catch(error => {
  process.stderr.write(`Registry reconciliation: ${error.message}\n`);
  process.exitCode = 1;
});
