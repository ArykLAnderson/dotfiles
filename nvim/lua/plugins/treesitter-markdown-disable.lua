-- Disable treesitter for languages that cause hangs in headless mode
-- See: https://github.com/nvim-treesitter/nvim-treesitter/issues/5508
--
-- Markdown is disabled in init.lua (before plugins load).
-- Bash/sh needs to be disabled AFTER nvim-treesitter loads because
-- nvim-treesitter's plugin/filetypes.lua re-registers bash -> sh.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      -- Re-register after nvim-treesitter has loaded its filetypes
      vim.treesitter.language.register("text", "bash")
      vim.treesitter.language.register("text", "sh")
    end,
  },
}
