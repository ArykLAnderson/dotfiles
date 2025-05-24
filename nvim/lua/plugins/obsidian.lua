return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = false,
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre path/to/my-vault/**.md",
  --   "BufNewFile path/to/my-vault/**.md",
  -- },
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "folke/which-key.nvim", lazy = true },
  },
  init = function()
    local wk = require("which-key")
    wk.add({ "<leader>o", name = "Obsidian", desc = "Obsidian commands" })
  end,
  opts = {
    ui = { enable = false },
    workspaces = {
      {
        name = "work",
        path = "~/workspace/notes/work",
      },
      {
        name = "personal",
        path = "~/workspace/notes/personal",
      },
    },
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "daily_notes",
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = "%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = "%B %-d, %Y",
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = "daily_note.md",
    },
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {
        yesterday = function()
          return os.date("%Y-%m-%d", os.time() - 86400)
        end,
      },
    },
    -- other fields ...
    notes_subdir = "zettelkasten",
    -- Optional, customize how names/IDs for new notes are created.
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,
  },
  keys = {
    {
      "<leader>ob",
      "<cmd>ObsidianBacklinks<cr>",
      desc = "Show document backlinks",
    },
    {
      "<leader>oa",
      "<cmd>ObsidianTags<cr>",
      desc = "Manage note tags",
    },
    {
      "<leader>o/",
      "<cmd>ObsidianSearch<cr>",
      desc = "Search notes",
    },
    {
      "<leader>od",
      "<cmd>ObsidianDailies<cr>",
      desc = "Obsidian Dailies",
    },
    {
      "<leader>oe",
      "<cmd>ObsidianExtractNote<cr>",
      desc = "Extract note from visual selection",
      mode = { "v" },
    },
    {
      "<leader>of",
      "<cmd>ObsidianFollowLink<cr>",
      desc = "Follow highlighted link",
    },
    {
      "<leader>on",
      "<cmd>ObsidianNew<cr>",
      desc = "New obsidian note",
    },
    {
      "<leader>ot",
      "<cmd>ObsidianNewFromTemplate<cr>",
      desc = "New obsidian note from template",
    },
    {
      "<leader>os",
      "<cmd>ObsidianTemplate<cr>",
      desc = "Insert snippet from obsidian template",
    },
    {
      "<leader>ol",
      "<cmd>ObsidianLink<cr>",
      desc = "Link selection to note of same alias",
      mode = { "v", "i" },
    },
    {
      "<leader>ow",
      "<cmd>ObsidianWorkspace<cr>",
      desc = "Change note taking workspace",
    },
  },
}
