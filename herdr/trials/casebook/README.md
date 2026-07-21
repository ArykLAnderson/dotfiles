# Isolated Herdr Casebook trial

This tracked directory is an opt-in side path only. These dotfiles do not install Herdr, start a server/service, enroll projects, edit Pi integration, or change normal terminal startup. Tmux remains the default and intact fallback. If a compatible Herdr is separately installed and later authorized for live use, `hd` is the sole entry point and always selects config `~/.config/herdr/trials/casebook/config.toml` plus session `casebook-trial`. `hd` accepts no arguments, so it cannot be redirected to another session or subcommand.

The config uses only fields verified in the pinned upstream config reference at commit `02a6e874f67800891b5a549297219ed6f3ce0f2f`: terminal Nord colors, `Ctrl-Space`, direct `Ctrl-h/j/k/l`, `Ctrl-Space v/s` splits, `resume_agents_on_restore = false`, and pane history off. It is source-attested, not locally validated.

The config now wires twelve source-owned `aryk.pins` plugin actions (pin/manage plus four project and four local activation slots). The plugin manifest/API fields are source-attested to Herdr `1f2487554b9fd42118f9e99ee06eb558bbb2391f` (0.7.4), but the plugin is not linked or live-validated. The accepted contract intentionally uses `prefix+H` and `prefix+T`; custom keys win, so these displace Herdr's default swap-left and rename-tab bindings. Other semantic controls remain adapter-owned gaps. Never fake canonical identity with Herdr labels, CWDs, mutable pane IDs, or plugin context.

## Local custody

Keep runtime state, sockets, logs, Pi sessions, project registrations/bindings, favorites, focus history, credentials, and machine-specific paths local. This repo ignores `profile.local.toml`, `state/`, `logs/`, and `bindings/` in this directory, plus Herdr's actual named-session runtime at `~/.config/herdr/sessions/casebook-trial/`. `profile.local.toml` is future adapter input; Herdr does not load it automatically. Agent OS uses machine-local adapter state beneath `${XDG_STATE_HOME:-~/.local/state}/agent-os/herdr-trials/casebook/`: `project-pins.json`, `local-pins.json`, `focus-history.json`, `action-result.json`, and `bindings/registry.json`. Pin files contain schema version 1 plus exactly four canonical IDs/nulls and are written atomically.

`bindings/registry.json` is mandatory authority. A trusted Casebook/Steward publisher must atomically provide root `schemaVersion: 1`; route `{sessionName:"casebook-trial", configPath:<absolute>, socketPath:<absolute>, protocol:17}`; project records `{canonicalId,generation,reconciliationState,stewardSessionCanonicalId}`; and session records `{canonicalId,projectCanonicalId,generation,reconciliationState,role,officialPiSession,binding}`. Generations are positive integers; reconciliation is `current|stale`; role is `steward|interaction`; `officialPiSession` is exact `{source:"pi",agent:"pi",kind:"session_id"|"session_path",value}`; and `binding` has generation-scoped nonempty `workspaceId`, `tabId`, `paneId`, and `terminalId`. Cross-canonical reuse of either the official tuple or the exact four-locator binding tuple invalidates the registry. Duplicate, stale, absent, or fresh-Agent-API-disagreeing claims are unavailable. Focus uses the verified pane ID and accepts success only when exit-zero `agent_info` repeats that official tuple and all locators with `focused: true`. The plugin never publishes or infers this registry. The source plugin's `examples/registry.example.json` is non-authoritative documentation only.

Pin/history mutations are serialized with an exclusive lock held across read/modify/fsync/rename; crash-left locks are never deleted as stale and cause bounded fail-closed refusal. Existing symlinked state-path parents are refused. A source-attested `pane.focused` event hook refreshes `agent list`, revalidates the exact event pane, and records its canonical project/session silently. Herdr does not report event cause, so actual focus changes are treated as user-visible; this navigation seam's background opens always use `focus=false`. Event failures neither mutate nor pop up. The plugin-local resolver is self-contained and relocation-tested.

## Offline checks and link-later gate

```sh
fish --no-execute fish/functions/hd.fish
fish -c 'source fish/functions/hd.fish; functions hd'
python3 - <<'PY'
import tomllib
with open('herdr/trials/casebook/config.toml', 'rb') as f:
    tomllib.load(f)
print('toml: ok')
PY
node --test ~/.agents-os/src/herdr-plugins/aryk.pins/test/*.test.mjs
```

Offline preparation does not link the plugin. Only after separate authorization may an operator use `HERDR_BIN_PATH` with explicit `--session casebook-trial` plus the inherited config/socket proof to link the reviewed `~/.agents-os/src/herdr-plugins/aryk.pins/` directory. The authoritative registry publisher and live registry must exist first.

Do not run `hd`, Herdr, `herdr config check`, plugin link, sync, or doctor during offline validation. Live validation must later cover terminal CSI-u/Alt delivery, `Ctrl-Space` nesting with tmux, editor boundary behavior for direct Ctrl movement, theme rendering, actual socket/log/state paths, detach/restart recovery, and official Pi session proof.

Rollback requires no tracked mutation: detach/stop the isolated trial only when separately authorized, then use ordinary tmux terminals. This README intentionally provides no purge or deletion command.
