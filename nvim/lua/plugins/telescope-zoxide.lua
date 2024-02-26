return {
  "jvgrootveld/telescope-zoxide",
  config = function(opts)
    local t = require("telescope")
    local z_utils = require("telescope._extensions.zoxide.utils")
    -- Configure the extension
    t.setup({
      extensions = {
        zoxide = {
          prompt_title = "[ Zoxide List ]",

          -- Zoxide list command with score
          list_command = "zoxide query -ls",
          mappings = {
            default = {
              action = function(selection)
                vim.cmd.edit(selection.path)
              end,
              after_action = function(selection)
                print("Directory changed to " .. selection.path)
              end,
            },
            ["<C-s>"] = { action = z_utils.create_basic_command("split") },
            ["<C-v>"] = { action = z_utils.create_basic_command("vsplit") },
            ["<C-e>"] = { action = z_utils.create_basic_command("edit") },
            ["<C-b>"] = {
              keepinsert = true,
              action = function(selection)
                builtin.file_browser({ cwd = selection.path })
              end,
            },
            ["<C-f>"] = {
              keepinsert = true,
              action = function(selection)
                builtin.find_files({ cwd = selection.path })
              end,
            },
            ["<C-t>"] = {
              action = function(selection)
                vim.cmd.tcd(selection.path)
              end,
            },
          },
        },
      },
    })
    -- Load the extension
    t.load_extension("zoxide")
    -- Add a mapping
    vim.keymap.set("n", "<leader>fd", t.extensions.zoxide.list, { desc = "Find Directory" })
  end,
}
