return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "prochri/telescope-all-recent.nvim",
      dependencies = {
        "kkharji/sqlite.lua",
      },
      opts = {},
    },
    {
      "danielfalk/smart-open.nvim",
      branch = "0.2.x",
      dependencies = {
        "kkharji/sqlite.lua",
        { "nvim-telescope/telescope-fzf-native.nvim" },
      },
    },

    "debugloop/telescope-undo.nvim",
    "piersolenski/telescope-import.nvim",
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("import")
    telescope.load_extension("live_grep_args")
    telescope.load_extension("notify")
    telescope.load_extension("smart_open")
    telescope.load_extension("undo")
    telescope.load_extension("fzf")
  end,

  opts = {
    defaults = {
      file_ignore_patterns = { ".git/", "node_modules" },
      layout_config = {
        height = 0.90,
        width = 0.90,
        preview_cutoff = 0,
        horizontal = { preview_width = 0.60 },
        vertical = { width = 0.55, height = 0.9, preview_cutoff = 0 },
        prompt_position = "top",
      },
      path_display = { "smart" },
      prompt_position = "top",
      prompt_prefix = " ",
      selection_caret = " ",
      sorting_strategy = "ascending",
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--hidden",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim", -- add this value
      },
    },
    pickers = {
      buffers = {
        prompt_prefix = "󰸩 ",
      },
      commands = {
        prompt_prefix = " ",
        layout_config = {
          height = 0.63,
          width = 0.78,
        },
      },
      command_history = {
        prompt_prefix = " ",
        layout_config = {
          height = 0.63,
          width = 0.58,
        },
      },
      git_files = {
        prompt_prefix = "󰊢 ",
        show_untracked = true,
      },
      find_files = {
        prompt_prefix = " ",
        find_command = { "fd", "-H" },
      },
      live_grep = {
        prompt_prefix = "󰱽 ",
      },
      grep_string = {
        prompt_prefix = "󰱽 ",
      },
    },
    extensions = {
      undo = {
        use_delta = true,
        use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
        side_by_side = true,
        layout_strategy = "vertical",
        layout_config = {
          preview_height = 0.8,
        },
        diff_context_lines = vim.o.scrolloff,
        entry_format = "state #$ID, $STAT, $TIME",
        time_format = "",
        saved_only = false,
        mappings = {
          i = {
            ["<C-cr>"] = function(bufnr)
              return require("telescope-undo.actions").yank_additions(bufnr)
            end,
            ["<S-cr>"] = function(bufnr)
              return require("telescope-undo.actions").yank_deletions(bufnr)
            end,
            ["<cr>"] = function(bufnr)
              return require("telescope-undo.actions").restore(bufnr)
            end,
          },
        },
      },
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case",
      },
      smart_open = {
        cwd_only = true,
        filename_first = true,
      },
    },
  },
  keys = function()
    return {
      -- TODO: last telescope
      { "<leader>*", "<cmd>Telescope grep_string<cr>", { silent = true, desc = "Grep Word Under Cursor" } },
      { "<leader>.", "<cmd>Telescope resume<cr>", { silent = true, desc = "Resume Telescope" } },
      { -- lazy style key map
        "<leader>U",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    }
  end,
}
