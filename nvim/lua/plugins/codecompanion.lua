return {
  {
    "olimorris/codecompanion.nvim",
    opts = {
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            -- Copilot configuration is handled by :Copilot setup
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
          keymaps = {
            accept_change = {
              modes = { n = "ga" },
              description = "Accept model suggested change",
            },
            reject_change = {
              modes = { n = "gr" },
              description = "Reject model suggested change",
            },
          },
        },
        cmd = {
          adapter = "copilot",
        },
      },
      extensions = {
        history = {
          enabled = true,
          opts = {
            keymap = "gh",
            save_chat_keymap = "sc",
            auto_save = true,
            expiration_days = 0,
            picker = "snacks",
            auto_generate_title = true,
            continue_last_chat = true,
            delete_on_clearing_chat = true,
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "github/copilot.vim", -- Ensure Copilot is installed
      "j-hui/fidget.nvim",
    },
    keys = {
      { "<leader>cc", "<Cmd>CodeCompanionActions<cr>", desc = "Code Companion Actions Palette" },
      { "<leader>a", "<Cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle Code Companion Chat" },
      { "ga", "<Cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add buffer to Code Companion Chat" },
    },
    init = function()
      vim.cmd([[cab cc CodeCompanion]])
    end,
  },
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
}

