# Neovim Markdown Treesitter Hang - Minimal Reproduction Plan

## Context

Neovim (v0.11.5) hangs when opening certain markdown files in `--headless` mode when using nvim-treesitter's `main` branch with LazyVim. The hang appears to be related to treesitter language injection for fenced code blocks (e.g., ```go, ```json).

### Key observations from prior investigation

- `nvim --clean` works fine - confirms it's a plugin/config issue
- `nvim --noplugin` works fine
- Files WITHOUT language-specified code blocks (plain ```) work fine
- Files WITH language-specified code blocks (```go, ```json, etc.) hang
- The hang occurs in `--headless` mode; interactive mode behavior is unclear
- A workaround exists: `vim.treesitter.language.register("text", "markdown")` disables markdown parsing

### Relevant versions

- Neovim: v0.11.5
- nvim-treesitter: main branch (commit f47f549f)
- LazyVim: latest

### Suspected culprits

1. nvim-treesitter's `runtime/queries/markdown/injections.scm` - handles language injection for code blocks
2. LazyVim's treesitter config which enables `vim.treesitter.start()` on FileType
3. Neovim's `vim.treesitter.start()` behavior in headless mode

---

## Goal

Create a minimal, isolated reproduction case that:

1. Identifies whether the bug is in nvim-treesitter, LazyVim, or Neovim core
2. Finds the smallest markdown content that triggers the hang
3. Documents exact steps to reproduce in a fresh environment
4. Can be used to file a bug report to the appropriate project

---

## Tasks

### Phase 1: Create Isolated Test Environment

Create a self-contained test environment at `/tmp/nvim-md-hang-repro/` that:

- Uses isolated `XDG_CONFIG_HOME` and `XDG_DATA_HOME` (no interference from user config)
- Bootstraps lazy.nvim and nvim-treesitter from scratch
- Installs only markdown and markdown_inline parsers
- Has multiple test configurations to isolate the issue

#### Required files

1. `repro-minimal.lua` - Bare nvim-treesitter without LazyVim
2. `repro-lazyvim.lua` - With LazyVim's treesitter configuration
3. `run-tests.sh` - Script to run all test combinations

### Phase 2: Create Test Markdown Files

Create a series of test markdown files to bisect the trigger:

1. `test-plain.md` - Code blocks without language specifiers
2. `test-one-lang.md` - Single code block with language (e.g., ```go)
3. `test-multi-lang.md` - Multiple code blocks with same language
4. `test-mixed-lang.md` - Multiple code blocks with different languages
5. `test-nested.md` - Nested structures (lists with code blocks)
6. `test-large.md` - Copy of a known-hanging file for baseline

### Phase 3: Systematic Testing

Run tests to answer these questions:

1. **Does pure nvim-treesitter (no LazyVim) hang?**
   - Test with `repro-minimal.lua`
   - If no hang: issue is in LazyVim's config
   - If hangs: issue is in nvim-treesitter or neovim core

2. **What's the minimal content that triggers the hang?**
   - Start with `test-one-lang.md`, increase complexity until hang occurs
   - Try different languages (go, json, bash, lua)
   - Try different numbers of code blocks

3. **Is it headless-specific?**
   - Test same files in interactive mode with auto-quit
   - Use `script` command to emulate TTY if needed

4. **Is it injection-related?**
   - Test with injections.scm removed/renamed
   - Test with only highlight queries (no injection)

### Phase 4: Document Findings

Create a `FINDINGS.md` with:

- Exact reproduction steps
- Minimal test case
- Which component is responsible
- Suggested fix or workaround

---

## Test Commands Template

```bash
# Set up isolated environment
export REPRO_DIR="/tmp/nvim-md-hang-repro"
export XDG_CONFIG_HOME="$REPRO_DIR/config"
export XDG_DATA_HOME="$REPRO_DIR/data"
export XDG_STATE_HOME="$REPRO_DIR/state"
export XDG_CACHE_HOME="$REPRO_DIR/cache"

# Test with timeout (10 seconds should be plenty for a simple file open)
# Use gtimeout on macOS (from coreutils)
gtimeout 10 nvim -u "$REPRO_DIR/repro-minimal.lua" --headless \
  -c "edit $REPRO_DIR/test-one-lang.md" \
  -c "qa!"
echo "Exit code: $?"
# Exit 0 = success, Exit 124 = timeout (hang), Exit 137 = killed
```

---

## Important Notes

- Use `gtimeout` instead of `timeout` on macOS (from coreutils)
- The user's shell is `fish`, not bash - heredocs and `$?` syntax differ (use `$status` in fish)
- Avoid creating huge files - use the Write tool in small increments due to potential timeouts
- Test interactively with `script -q /dev/null nvim ...` to emulate TTY

---

## Success Criteria

The repro is complete when you can demonstrate:

1. A single command that reliably hangs (with timeout)
2. A single command with minimal change that does NOT hang
3. Clear identification of which project owns the bug

---

## Reference: Known Working Workaround

Add this to init.lua BEFORE loading plugins:

```lua
-- Completely disable treesitter for markdown by unregistering the language
vim.treesitter.language.register("text", "markdown")
vim.treesitter.language.register("text", "markdown_inline")
```

## Reference: Relevant Files

- nvim-treesitter injections: `~/.local/share/nvim/lazy/nvim-treesitter/runtime/queries/markdown/injections.scm`
- LazyVim treesitter config: `~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/treesitter.lua`
- LazyVim treesitter util: `~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/util/treesitter.lua`

## Reference: Related Issues

- https://github.com/nvim-treesitter/nvim-treesitter/issues/5508 (treesitter folding hang)
