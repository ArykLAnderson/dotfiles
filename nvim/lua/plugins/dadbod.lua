return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dotenv", lazy = true },
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
      { "folke/which-key.nvim", lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 30
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_use_nvim_notify = 1
      vim.g.db_ui_win_position = "right"
      local wk = require("which-key")
      wk.add({ "<leader>D", name = "Db Tools", desc = "DB UI Tools" })
    end,
    keys = {
      { "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "DB UI Toggle" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "DB UI Find buffer" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "DB UI Rename buffer" },
      { "<leader>Dl", "<cmd>DBUIToggle<cr>", desc = "DB UI Last query infos" },
    },
  },
}
