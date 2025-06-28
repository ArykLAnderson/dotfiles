local adapter = require("utils.adapter")
local read_api_key = function()
  local api_key = ""
  local handle = io.popen("pass mercari/litellm/api_key")
  if handle then
    api_key = handle:read("*a"):gsub("%s+$", "")
    handle:close()
  end
  return api_key
end

return {
  -- {
  --   "olimorris/codecompanion.nvim",
  --   opts = {
  --     display = {
  --       diff = {
  --         provider = "mini_diff",
  --       },
  --     },
  --     strategies = {
  --       adapter = "mercari_litellm",
  --       slash_command = adapter.make_slash_commands,
  --       chat = {
  --         send = {
  --           callback = function(chat)
  --             vim.cmd("stopinsert")
  --             chat:submit()
  --             chat:add_buf_message({ role = "llm", content = "" })
  --           end,
  --           index = 1,
  --           description = "Send",
  --         },
  --       },
  --       inline = {
  --         adapter = "mercari_litellm",
  --         keymaps = {
  --           accept_change = {
  --             modes = { n = "ga" },
  --             description = "Accept model suggested change",
  --           },
  --           reject_change = {
  --             modes = { n = "gr" },
  --             description = "Reject model suggested change",
  --           },
  --         },
  --       },
  --       cmd = {
  --         adapter = "mercari_litellm",
  --       },
  --     },
  --     extensions = adapter.get_extensions(),
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "ravitemer/mcphub.nvim",
  --     "j-hui/fidget.nvim",
  --     "ravitemer/codecompanion-history.nvim",
  --   },
  --   config = function(_, opts)
  --     opts.adapters = {
  --       mercari_litellm = adapter.get_adapter({
  --         url = "https://litellm.mercari.in",
  --         api_key = read_api_key(),
  --         models_url = "/models",
  --       }),
  --     }
  --     require("codecompanion").setup(opts)
  --   end,
  --   keys = {
  --     { "<leader>ck", "<Cmd>CodeCompanionActions<cr>", desc = "Code Companion Actions Pallete" },
  --     { "<leader>co", adapter.select_model, desc = "Select LiteLLM Model" },
  --     { "<leader>a", "<Cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle Code Companion Chat" },
  --     { "ga", "<Cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add buffer to Code Companion Chat" },
  --   },
  --   init = function()
  --     require("utils.fidget"):init()
  --     require("utils.codecompanion-extmarks"):setup()
  --     adapter.init_config()
  --     vim.cmd([[cab cc CodeCompanion]])
  --   end,
  -- },
  -- {
  --   "j-hui/fidget.nvim",
  --   opts = {
  --     notification = {
  --       window = {
  --         winblend = 0,
  --       },
  --     },
  --   },
  -- },
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   ft = { "markdown", "codecompanion" },
  -- },
}
