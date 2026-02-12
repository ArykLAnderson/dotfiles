-- Smart tmux navigation that handles floating windows
-- When in a floating window: go directly to tmux (skip nvim window navigation)
-- When in a normal window: use standard vim-tmux-navigator behavior (with patched ps command)

local function is_floating_window()
  local win = vim.api.nvim_get_current_win()
  local config = vim.api.nvim_win_get_config(win)
  return config.relative ~= ""
end

local function smart_navigate(direction)
  if is_floating_window() then
    -- In a floating window: go directly to tmux pane
    -- This bypasses vim-tmux-navigator entirely - no ps command involved
    local tmux_directions = {
      h = "L",
      j = "D",
      k = "U",
      l = "R",
    }
    local tmux_dir = tmux_directions[direction]
    if tmux_dir then
      vim.fn.system("tmux select-pane -" .. tmux_dir)
    end
  else
    -- Normal window: use vim-tmux-navigator's standard behavior
    -- This goes through the patched plugin code (without -t flag)
    local cmds = {
      h = "TmuxNavigateLeft",
      j = "TmuxNavigateDown",
      k = "TmuxNavigateUp",
      l = "TmuxNavigateRight",
    }
    vim.cmd(cmds[direction])
  end
end

return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    {
      "<c-h>",
      function() smart_navigate("h") end,
      mode = { "n", "t" },
      desc = "Navigate left (tmux-aware)",
    },
    {
      "<c-j>",
      function() smart_navigate("j") end,
      mode = { "n", "t" },
      desc = "Navigate down (tmux-aware)",
    },
    {
      "<c-k>",
      function() smart_navigate("k") end,
      mode = { "n", "t" },
      desc = "Navigate up (tmux-aware)",
    },
    {
      "<c-l>",
      function() smart_navigate("l") end,
      mode = { "n", "t" },
      desc = "Navigate right (tmux-aware)",
    },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
}
