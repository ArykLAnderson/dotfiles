-- require("telescope").load_extension("advanced_git_search")
-- require("telescope").load_extension("noice")
return {
  "nvim-telescope/telescope-live-grep-args.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("live_grep_args")
    vim.g.zoxide_use_select = true
  end,
  keys = {
    {
      "<leader>fg",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      desc = "Live Grep",
    },
    {
      "<leader>fa",
      function()
        require("telescope.builtin").live_grep({ glob_pattern = "!{spec,test}" })
      end,
      desc = "Live Grep Code",
    },
    { "<leader>fi", "<cmd>AdvancedGitSearch<CR>", desc = "AdvancedGitSearch" },
    { "<leader>gb", require("telescope.builtin").git_bcommits, desc = "Search Git Commits for Bffer" },
  },
  opts = function()
    local telescopeConfig = require("telescope.config")
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
    -- I want to search in hidden/dot files.
    table.insert(vimgrep_arguments, "--hidden")
    -- I don't want to search in the `.git` directory.
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*")

    local actions = require("telescope.actions")
    local select_one_or_multi = function(prompt_bufnr)
      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      local multi = picker:get_multi_selection()
      if not vim.tbl_isempty(multi) then
        require("telescope.actions").close(prompt_bufnr)
        for _, j in pairs(multi) do
          if j.path ~= nil then
            vim.cmd(string.format("%s %s", "edit", j.path))
          end
        end
      else
        require("telescope.actions").select_default(prompt_bufnr)
      end
    end

    return {
      defaults = {
        -- `hidden = true` is not supported in text grep commands.
        vimgrep_arguments = vimgrep_arguments,
        path_display = { "truncate" },
        mappings = {
          n = {
            ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
          i = {
            ["<C-j>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
            ["<CR>"] = select_one_or_multi,
            ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-S-d>"] = actions.delete_buffer,
          },
        },
      },
      pickers = {
        find_files = {
          -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
      },
    }
  end,
}
