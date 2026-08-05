# Isolated Herdr Casebook trial

This directory owns the local Herdr configuration and plugins for the `casebook-trial` session. `hd` selects `~/.config/herdr/trials/casebook/config.toml` and session `casebook-trial`.

The config uses terminal Nord colors, `Ctrl-Space`, direct `Ctrl-h/j/k/l`, `Ctrl-Space v/s` splits, agent restore, and pane history off.

The config wires `aryk.pins`, `aryk.spaces`, and `aryk.urls`. `aryk.registry` reconciles restored OpenCode sessions into the canonical local registry. `prefix+o` displaces Herdr's native `open_notification_target`; native `prefix+g` remains the live session navigator. `prefix+H` and `prefix+T` displace Herdr's default swap-left and rename-tab.

## Local custody

Keep runtime state, sockets, logs, agent sessions, project registrations/bindings, favorites, focus history, credentials, and machine-specific paths local. Plugin state lives beneath `${XDG_STATE_HOME:-~/.local/state}/herdr/trials/casebook/`: pin/history/result files, `bindings/registry.json`, and `spaces/` receipts. Mutations are locked and atomically replaced. Spaces configuration is `${XDG_CONFIG_HOME:-~/.config}/herdr/trials/casebook/spaces.json`.

`bindings/registry.json` is mandatory authority. It uses protocol 19 and exact `officialAgentSession` plus workspace, tab, pane, and terminal locators. `aryk.registry` is its single local publisher. It automatically enrolls an exact live OpenCode session only when its physical CWD falls under exactly one declared project root; ambiguous or unmatched sessions remain unavailable.

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
node --test herdr/plugins/aryk.pins/test/*.test.mjs
node --test herdr/plugins/aryk.spaces/test/*.test.mjs
node --test herdr/plugins/aryk.urls/test/*.test.mjs
```

Link the local plugins from the dotfiles checkout:

```sh
"$HERDR_BIN_PATH" --session casebook-trial plugin link "$HOME/workspace/dotfiles/herdr/plugins/aryk.registry"
"$HERDR_BIN_PATH" --session casebook-trial plugin link "$HOME/workspace/dotfiles/herdr/plugins/aryk.pins"
"$HERDR_BIN_PATH" --session casebook-trial plugin link "$HOME/workspace/dotfiles/herdr/plugins/aryk.spaces"
"$HERDR_BIN_PATH" --session casebook-trial plugin link "$HOME/workspace/dotfiles/herdr/plugins/aryk.urls"
```

The authoritative registry publisher and live registry must exist first.

Do not run `hd`, Herdr, `herdr config check`, plugin link, sync, or doctor during offline validation. Live validation must later cover terminal CSI-u/Alt delivery, `Ctrl-Space` nesting with tmux, editor boundary behavior for direct Ctrl movement, theme rendering, actual socket/log/state paths, detach/restart recovery, and official Pi session proof.

Rollback requires no tracked mutation: detach/stop the isolated trial only when separately authorized, then use ordinary tmux terminals. This README intentionally provides no purge or deletion command.
