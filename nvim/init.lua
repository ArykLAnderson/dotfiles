-- Disable treesitter for markdown BEFORE lazy loads to prevent hang
-- See: https://github.com/nvim-treesitter/nvim-treesitter/issues/5508
vim.opt.foldmethod = "indent"
vim.opt.foldexpr = "0"

-- Completely disable treesitter for markdown by unregistering the language
vim.treesitter.language.register("text", "markdown")
vim.treesitter.language.register("text", "markdown_inline")

-- Note: bash/sh is disabled in lua/plugins/treesitter-markdown-disable.lua
-- because nvim-treesitter's plugin/filetypes.lua re-registers it after init.lua

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
