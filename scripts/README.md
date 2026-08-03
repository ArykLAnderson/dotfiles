# Portable command wrappers

This package is stowed into `~/.config/scripts`, which must appear before the directory containing the wrapped executable in `PATH`.

## OpenCode

`opencode` is a portable wrapper used by interactive shells and by tools such as Herdr that restore a session with `opencode --session <id>`. It finds the next real `opencode` executable on `PATH` and invokes it unchanged.

Install the dotfiles package from the repository root:

```sh
stow scripts
```

Add the wrapper directory before OpenCode's installation directory. Fish users can add this to `config.fish`:

```fish
fish_add_path ~/.config/scripts
```

Machine-local environment setup is optional. Create `~/.config/opencode/env.local.sh` to export secrets or machine-specific variables before OpenCode starts:

```sh
export EXAMPLE_API_KEY="$(your-secret-command)"
```

The local hook is ignored by this repository. Do not put credentials, employer-specific secret names, or private endpoints in `scripts/opencode`.

To keep the private hook elsewhere, set `OPENCODE_ENV_FILE` to an absolute path. If the hook is absent, the wrapper starts OpenCode without additional environment variables.

Verify resolution after installation:

```sh
command -v opencode
opencode --version
```

`command -v opencode` should print `~/.config/scripts/opencode`.
