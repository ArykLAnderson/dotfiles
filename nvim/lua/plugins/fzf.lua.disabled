return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader><space>", false },
    -- find
    { "<leader>sb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    { "<leader>sB", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer" },
    { "<leader>fc", LazyVim.pick.config_files(), desc = "Find Config File" },
    -- git
    { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
    { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
    -- search
    { "<leader>*", LazyVim.pick("grep_cword"), desc = "Word (Root Dir)" },
    { "<leader>sW", false },
  },
}
