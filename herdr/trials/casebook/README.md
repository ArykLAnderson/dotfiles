# Isolated Herdr Casebook trial

This tracked directory is an opt-in side path only. These dotfiles do not install Herdr, start a server/service, enroll projects, edit Pi integration, or change normal terminal startup. Tmux remains the default and intact fallback. If a compatible Herdr is separately installed and later authorized for live use, `hd` is the sole entry point and always selects config `~/.config/herdr/trials/casebook/config.toml` plus session `casebook-trial`. `hd` accepts no arguments, so it cannot be redirected to another session or subcommand.

The config uses only fields verified in the pinned upstream config reference at commit `02a6e874f67800891b5a549297219ed6f3ce0f2f`: terminal Nord colors, `Ctrl-Space`, direct `Ctrl-h/j/k/l`, `Ctrl-Space v/s` splits, `resume_agents_on_restore = false`, and pane history off. It is source-attested, not locally validated.

The accepted semantic controls remain adapter-owned gaps because no source-verified native configuration action keys were found: project/thread pickers, global/project pins, Steward, Executive Assistant, and previous-human-focus/back. They must resolve canonical IDs through current binding generations; do not fake them with Herdr labels or mutable pane IDs.

## Local custody

Keep runtime state, sockets, logs, Pi sessions, project registrations/bindings, favorites, focus history, credentials, and machine-specific paths local. This repo ignores `profile.local.toml`, `state/`, `logs/`, and `bindings/` in this directory, plus Herdr's actual named-session runtime at `~/.config/herdr/sessions/casebook-trial/`. `profile.local.toml` is future adapter input; Herdr does not load it automatically. Agent OS recommends machine-local adapter state beneath `${XDG_STATE_HOME:-~/.local/state}/agent-os/herdr-trials/casebook/`.

## Offline checks

```sh
fish --no-execute fish/functions/hd.fish
fish -c 'source fish/functions/hd.fish; functions hd'
python3 - <<'PY'
import tomllib
with open('herdr/trials/casebook/config.toml', 'rb') as f:
    tomllib.load(f)
print('toml: ok')
PY
```

Do not run `hd` or `herdr config check` during offline validation. Live validation must later cover terminal CSI-u/Alt delivery, `Ctrl-Space` nesting with tmux, editor boundary behavior for direct Ctrl movement, theme rendering, actual socket/log/state paths, detach/restart recovery, and official Pi session proof.

Rollback requires no tracked mutation: detach/stop the isolated trial only when separately authorized, then use ordinary tmux terminals. This README intentionally provides no purge or deletion command.
