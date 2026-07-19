return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>*", LazyVim.pick("grep_word"), desc = "Grep word under cursor" },
    { "<leader>so", function() Snacks.picker.smart({ filter = { cwd = true } }) end, desc = "Smart open files" },

    -- Remap autocmds to <leader>sA
    { "<leader>sA", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
  },
}
