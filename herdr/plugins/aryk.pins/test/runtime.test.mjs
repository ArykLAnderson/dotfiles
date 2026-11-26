import test from "node:test";
import assert from "node:assert/strict";
import { createHerdrClient, parseAgentListResponse, parseFocusResponse, parsePaneGetResponse, parseWorkspaceListResponse } from "../lib/herdr-client.mjs";
import { handlePaneFocusedEvent, recordSuccessfulFocus, invokeAction } from "../lib/runtime.mjs";

const env = { HERDR_BIN_PATH: "/opt/herdr", HERDR_CONFIG_PATH: "/home/a/.config/herdr/trials/casebook/config.toml", HERDR_SOCKET_PATH: "/tmp/casebook.sock", HERDR_PANE_ID: "pane-a", HERDR_PLUGIN_CONTEXT_JSON: '{"focused_pane_id":"pane-a"}' };
const route = { sessionName: "casebook-trial", configPath: env.HERDR_CONFIG_PATH, socketPath: env.HERDR_SOCKET_PATH, protocol: 19 };
const focusRecord = {
  canonicalId: "session-a", projectCanonicalId: "project-a", generation: 1, reconciliationState: "current", role: "interaction",
  officialAgentSession: { source:"herdr:pi", agent: "pi", kind: "id", value: "official-a" },
  binding: { workspaceId: "workspace-a", tabId: "tab-a", paneId: "pane-a", terminalId: "terminal-a" },
};
const focusedAgent = (overrides = {}) => ({ name: "any-name", terminal_id: "terminal-a", workspace_id: "workspace-a", tab_id: "tab-a", pane_id: "pane-a", focused: true, agent_session: { ...focusRecord.officialAgentSession }, ...overrides });
const focusBody = (agent = focusedAgent()) => JSON.stringify({ result: { type: "agent_info", agent } });

test("client uses exact explicit session argv, inherited proof env, no shell, and no retry", async () => {
  const calls = [];
  const executor = async (executable, args, options) => { calls.push({ executable, args, options }); return { status: 0, stdout: calls.length === 1 ? JSON.stringify({ result: { type: "agent_list", agents: [] } }) : focusBody(), stderr: "" }; };
  const client = createHerdrClient({ env, route, executor });
  assert.deepEqual(await client.listAgents(), []);
  await client.focusSession({ record: focusRecord });
  assert.deepEqual(calls.map(c => c.args), [["--session", "casebook-trial", "agent", "list"], ["--session", "casebook-trial", "agent", "focus", "pane-a"]]);
  assert.ok(calls.every(c => c.executable === "/opt/herdr" && c.options.shell === false && c.options.env.HERDR_CONFIG_PATH === env.HERDR_CONFIG_PATH && c.options.env.HERDR_SOCKET_PATH === env.HERDR_SOCKET_PATH));
  assert.equal(calls.length, 2);
});

test("client refuses missing route proof and uncertain/nonzero/invalid output", async () => {
  assert.throws(() => createHerdrClient({ env: { ...env, HERDR_SOCKET_PATH: "/wrong" }, route, executor: async () => ({}) }), /socket/);
  assert.throws(() => createHerdrClient({ env: { ...env, HERDR_BIN_PATH: "herdr" }, route, executor: async () => ({}) }), /absolute/);
  assert.throws(() => parseAgentListResponse("no"), /JSON/);
  assert.throws(() => parseFocusResponse(JSON.stringify({ result: { type: "agent_list", agents: [] } }), focusRecord), /unexpected/);
  assert.throws(() => parseFocusResponse(focusBody(focusedAgent({ pane_id: "wrong" })), focusRecord), /mismatch/);
  const calls = [];
  const client = createHerdrClient({ env, route, executor: async (...args) => { calls.push(args); return { status: 7, stdout: "", stderr: "bad" }; } });
  await assert.rejects(client.focusSession({ record: focusRecord }), /failed|uncertain/); assert.equal(calls.length, 1);
});

test("pane get accepts only the requested pane and a workspace locator", async () => {
  const pane = { pane_id: "pane-a", workspace_id: "workspace-a", focused: true };
  assert.deepEqual(parsePaneGetResponse(JSON.stringify({ result: { type: "pane_info", pane } }), "pane-a"), pane);
  assert.throws(() => parsePaneGetResponse(JSON.stringify({ result: { type: "pane_info", pane: { ...pane, pane_id: "pane-b" } } }), "pane-a"), /target mismatch/);
  assert.throws(() => parsePaneGetResponse(JSON.stringify({ result: { type: "pane_info", pane: { ...pane, workspace_id: "" } } }), "pane-a"), /invalid pane/);
  const calls = [];
  const client = createHerdrClient({ env, route, executor: async (executable, args, options) => {
    calls.push({ executable, args, options });
    return { status: 0, stdout: JSON.stringify({ result: { type: "pane_info", pane } }), stderr: "" };
  } });
  assert.deepEqual(await client.getPane("pane-a"), pane);
  assert.deepEqual(calls[0].args, ["--session", "casebook-trial", "pane", "get", "pane-a"]);
  assert.equal(calls[0].options.shell, false);
  await assert.rejects(client.getPane(""), /pane ID/);
});

test("space-pin popup uses manifest entrypoint with exact argv", async () => {
  const calls = [];
  const client = createHerdrClient({ env, route, executor: async (executable, args, options) => { calls.push({ executable, args, options }); return { status: 0, stdout: "{}", stderr: "" }; } });
  await client.openPopup("project-manager");
  assert.deepEqual(calls[0].args, ["--session", "casebook-trial", "plugin", "pane", "open", "--plugin", "aryk.pins", "--entrypoint", "project-manager", "--placement", "popup"]);
});

test("history changes only after successful human focus", () => {
  const history = { schemaVersion: 1, projects: { p: "old" } };
  assert.deepEqual(recordSuccessfulFocus(history, { projectCanonicalId: "p", canonicalSessionId: "new", cause: "background", success: true }), history);
  assert.deepEqual(recordSuccessfulFocus(history, { projectCanonicalId: "p", canonicalSessionId: "new", cause: "human", success: false }), history);
  assert.equal(recordSuccessfulFocus(history, { projectCanonicalId: "p", canonicalSessionId: "new", cause: "human", success: true }).projects.p, "new");
});

test("local activation focuses one official canonical agent session and records only that successful human focus", async () => {
  const record = structuredClone(focusRecord);
  const registry = {
    schemaVersion: 1, route,
    projects: [{ canonicalId: "project-a", generation: 1, reconciliationState: "current", stewardSessionCanonicalId: "session-a" }],
    sessions: [record],
  };
  const agent = { name: "unique-agent", terminal_id: "terminal-a", workspace_id: "workspace-a", tab_id: "tab-a", pane_id: "pane-a", agent_session: { ...record.officialAgentSession } };
  const focused = [], histories = [];
  const result = await invokeAction("activate-local-1", {
    env, readRegistry: async () => registry,
    client: { listAgents: async () => [agent], focusSession: async resolution => focused.push(resolution.record.binding.paneId), openPopup: async () => assert.fail("no refusal popup expected") },
    loadPins: async () => ({ schemaVersion: 1, slots: ["session-a", null, null, null] }),
    historyTransaction: async (_file, mutate) => { const outcome = await mutate({ schemaVersion: 1, projects: {} }); histories.push(outcome.history); return outcome.result; },
    writeResult: async () => {},
  });
  assert.equal(result.status, "focused"); assert.deepEqual(focused, ["pane-a"]); assert.equal(histories[0].projects["project-a"], "session-a");
});

test("pane.focused event revalidates exact official pane and records history without popup", async () => {
  const registry = {
    schemaVersion: 1, route,
    projects: [{ canonicalId: "project-a", generation: 1, reconciliationState: "current", stewardSessionCanonicalId: "session-a" }], sessions: [structuredClone(focusRecord)],
  };
  const histories = [], popups = [];
  const eventEnv = { ...env, HERDR_PLUGIN_EVENT: "pane.focused", HERDR_PLUGIN_EVENT_JSON: JSON.stringify({ event: "pane_focused", data: { type: "pane_focused", pane_id: "pane-a", workspace_id: "workspace-a" } }) };
  const result = await handlePaneFocusedEvent({
    env: eventEnv, readRegistry: async () => registry,
    client: { listAgents: async () => [focusedAgent()], openPopup: async id => popups.push(id) },
    historyTransaction: async (_file, mutate) => { const outcome = await mutate({ schemaVersion: 1, projects: {} }); histories.push(outcome.history); return outcome.result; },
  });
  assert.equal(result.status, "recorded"); assert.equal(histories[0].projects["project-a"], "session-a"); assert.deepEqual(popups, []);
  const ignored = await handlePaneFocusedEvent({ ...{ env: eventEnv, readRegistry: async () => registry }, client: { listAgents: async () => [focusedAgent({ pane_id: "wrong" })] }, historyTransaction: async () => assert.fail("must not mutate") });
  assert.equal(ignored.status, "ignored");
});

test("OpenCode id focus response and pane.focused receipt revalidate the exact official tuple", async () => {
  const record = structuredClone(focusRecord);
  record.officialAgentSession = { source: "herdr:opencode", agent: "opencode", kind: "id", value: "oc-session-42" };
  const ocAgent = { name: "OpenCode", terminal_id: "terminal-a", workspace_id: "workspace-a", tab_id: "tab-a", pane_id: "pane-a", focused: true, agent_status: "idle", agent_session: { ...record.officialAgentSession } };
  assert.equal(parseFocusResponse(JSON.stringify({ result: { type: "agent_info", agent: ocAgent } }), record).agent_session.kind, "id");

  const registry = { schemaVersion: 1, route, projects: [{ canonicalId: "project-a", generation: 1, reconciliationState: "current", stewardSessionCanonicalId: "session-a" }], sessions: [record] };
  const eventEnv = { ...env, HERDR_PLUGIN_EVENT: "pane.focused", HERDR_PLUGIN_EVENT_JSON: JSON.stringify({ event: "pane_focused", data: { type: "pane_focused", pane_id: "pane-a", workspace_id: "workspace-a" } }) };
  const writes = [];
  const result = await handlePaneFocusedEvent({ env: eventEnv, readRegistry: async () => registry, client: { listAgents: async () => [ocAgent] }, historyTransaction: async (_file, mutate) => { const outcome = await mutate({ schemaVersion: 1, projects: {} }); writes.push(outcome.history); return outcome.result; } });
  assert.equal(result.status, "recorded");
  assert.equal(writes[0].projects["project-a"], "session-a");
});

test("exit-zero wrong focus target never updates history", async () => {
  const client = createHerdrClient({ env, route, executor: async () => ({ status: 0, stdout: focusBody(focusedAgent({ terminal_id: "other" })), stderr: "" }) });
  await assert.rejects(client.focusSession({ record: focusRecord }), /mismatch/);
});

test("missing registry action fails visibly through result popup", async () => {
  const opened = [];
  const result = await invokeAction("pin-local", { stateRoot: "/absent", env, client: { openPopup: async id => opened.push(id) }, readRegistry: async () => { const e = new Error("missing registry"); e.code = "ENOENT"; throw e; }, writeResult: async () => {} });
  assert.equal(result.status, "refused"); assert.deepEqual(opened, ["result"]);
});

test("space pins use the invocation pane's live workspace without requiring a canonical chat", async () => {
  const writes = [], opened = [];
  const result = await invokeAction("pin-project", {
    env, readRegistry: async () => ({ schemaVersion: 1, route, projects: [], sessions: [] }),
    client: {
      getPane: async paneId => ({ pane_id: paneId, workspace_id: "workspace-new", focused: true }),
      listWorkspaces: async () => [{ workspace_id: "workspace-new", focused: true }],
      listAgents: async () => assert.fail("project pins do not require canonical agents"),
      openPopup: async id => opened.push(id),
    },
    pinTransaction: async (_file, mutate) => {
      const outcome = await mutate({ schemaVersion: 1, slots: [null, null, null, null] });
      writes.push(outcome.pins);
      return outcome.result;
    },
    writeResult: async () => {},
  });
  assert.deepEqual(result, { status: "pinned", slot: 1, canonicalId: "herdr-workspace:workspace-new" });
  assert.deepEqual(writes[0].slots, ["herdr-workspace:workspace-new", null, null, null]);
  assert.deepEqual(opened, []);
});

test("space pin stays idempotent and visibly refuses a full pin set", async () => {
  for (const initial of [
    { schemaVersion: 1, slots: ["herdr-workspace:workspace-new", null, null, null] },
    { schemaVersion: 1, slots: ["a", "b", "c", "d"] },
  ]) {
    const writes = [], opened = [];
    const result = await invokeAction("pin-project", {
      env, readRegistry: async () => ({ schemaVersion: 1, route, projects: [], sessions: [] }),
      client: {
        getPane: async paneId => ({ pane_id: paneId, workspace_id: "workspace-new" }),
        listWorkspaces: async () => [{ workspace_id: "workspace-new" }],
        openPopup: async id => opened.push(id),
      },
      pinTransaction: async (_file, mutate) => {
        const outcome = await mutate(initial);
        writes.push(outcome.pins);
        return outcome.result;
      },
      writeResult: async () => {},
    });
    if (initial.slots[0] === "herdr-workspace:workspace-new") {
      assert.deepEqual(result, { status: "existing", slot: 1, canonicalId: "herdr-workspace:workspace-new" });
      assert.deepEqual(opened, []);
    } else {
      assert.equal(result.status, "refused");
      assert.match(result.message, /Space pins are full/);
      assert.deepEqual(opened, ["result"]);
    }
    assert.deepEqual(writes, [initial]);
  }
});

test("local pins still require and store the current canonical chat session", async () => {
  const writes = [];
  const agent = focusedAgent();
  const registry = {
    schemaVersion: 1, route,
    projects: [{ canonicalId: "project-a", generation: 1, reconciliationState: "current", stewardSessionCanonicalId: "session-a" }],
    sessions: [structuredClone(focusRecord)],
  };
  const result = await invokeAction("pin-local", {
    env, readRegistry: async () => registry,
    client: {
      listAgents: async () => [agent],
      openPopup: async id => assert.fail(`unexpected refusal popup: ${id}`),
    },
    pinTransaction: async (_file, mutate) => {
      const outcome = await mutate({ schemaVersion: 1, slots: [null, null, null, null] });
      writes.push(outcome.pins);
      return outcome.result;
    },
    writeResult: async () => {},
  });
  assert.deepEqual(result, { status: "pinned", slot: 1, canonicalId: "session-a" });
  assert.deepEqual(writes[0].slots, ["session-a", null, null, null]);
});

test("space pin refuses when the invocation context does not identify its pane", async () => {
  const opened = [], writes = [];
  const result = await invokeAction("pin-project", {
    env: { ...env, HERDR_PLUGIN_CONTEXT_JSON: '{"focused_pane_id":"pane-b"}' },
    readRegistry: async () => ({ schemaVersion: 1, route, projects: [], sessions: [] }),
    client: {
      getPane: async () => assert.fail("invalid invocation context must be refused before pane lookup"),
      listWorkspaces: async () => assert.fail("invalid invocation context must be refused before workspace lookup"),
      openPopup: async id => opened.push(id),
    },
    pinTransaction: async () => { writes.push(true); },
    writeResult: async () => {},
  });
  assert.equal(result.status, "refused");
  assert.equal(result.message, "focused invocation pane is unavailable");
  assert.deepEqual(writes, []);
  assert.deepEqual(opened, ["result"]);
});

test("space pin refuses a missing or empty invocation pane ID before pane lookup", async () => {
  for (const paneId of [undefined, ""]) {
    const opened = [], writes = [];
    const actionEnv = { ...env, HERDR_PANE_ID: paneId };
    const result = await invokeAction("pin-project", {
      env: actionEnv, readRegistry: async () => ({ schemaVersion: 1, route, projects: [], sessions: [] }),
      client: {
        getPane: async () => assert.fail("missing invocation pane ID must be refused before pane lookup"),
        listWorkspaces: async () => assert.fail("missing invocation pane ID must be refused before workspace lookup"),
        openPopup: async id => opened.push(id),
      },
      pinTransaction: async () => { writes.push(true); },
      writeResult: async () => {},
    });
    assert.equal(result.status, "refused");
    assert.deepEqual(writes, []);
    assert.deepEqual(opened, ["result"]);
  }
});

test("space pins refuse stale pane or workspace evidence without changing pins", async () => {
  for (const scenario of [
    { name: "pane locator does not match", pane: { pane_id: "pane-b", workspace_id: "workspace-new", focused: true }, workspaces: [{ workspace_id: "workspace-new", focused: true }] },
    { name: "workspace is no longer live", pane: { pane_id: "pane-a", workspace_id: "workspace-new", focused: true }, workspaces: [] },
    { name: "workspace identity is ambiguous", pane: { pane_id: "pane-a", workspace_id: "workspace-new", focused: true }, workspaces: [{ workspace_id: "workspace-new", focused: true }, { workspace_id: "workspace-new", focused: true }] },
  ]) {
    const writes = [], opened = [];
    const result = await invokeAction("pin-project", {
      env, readRegistry: async () => ({ schemaVersion: 1, route, projects: [], sessions: [] }),
      client: {
        getPane: async () => scenario.pane,
        listWorkspaces: async () => scenario.workspaces,
        listAgents: async () => assert.fail("project pins do not require canonical agents"),
        openPopup: async id => opened.push(id),
      },
      pinTransaction: async (_file, mutate) => { writes.push(await mutate({ schemaVersion: 1, slots: [null, null, null, null] })); return writes.at(-1).result; },
      writeResult: async () => {},
    });
    assert.equal(result.status, "refused", scenario.name);
    assert.deepEqual(writes, [], scenario.name);
    assert.deepEqual(opened, ["result"], scenario.name);
  }
});

test("space pins focus the exact live workspace", async () => {
  assert.deepEqual(parseWorkspaceListResponse(JSON.stringify({ result: { type: "workspace_list", workspaces: [{ workspace_id: "workspace-a" }] } })), [{ workspace_id: "workspace-a" }]);
  const focused = [];
  const result = await invokeAction("activate-project-1", {
    env, readRegistry: async () => ({ schemaVersion: 1, route, projects: [], sessions: [] }),
    client: { listWorkspaces: async () => [{ workspace_id: "workspace-a" }], focusWorkspace: async id => focused.push(id), openPopup: async () => assert.fail("no refusal expected") },
    loadPins: async () => ({ schemaVersion: 1, slots: ["herdr-workspace:workspace-a", null, null, null] }),
    writeResult: async () => {},
  });
  assert.equal(result.status, "focused");
  assert.deepEqual(focused, ["workspace-a"]);
});
