-- Minimal nvim config for editing tmux-harpoon bookmarks.
-- Usage: nvim --clean -u ~/.config/nvim/harpoon-edit.lua <file>

-- Nord palette (hardcoded for zero-dependency instant startup)
local nord0 = "#2E3440" -- polar_night.origin
local nord1 = "#3B4252" -- polar_night.bright
local nord3 = "#4C566A" -- polar_night.brightest
local nord4 = "#D8DEE9" -- snow_storm.origin
local nord8 = "#88C0D0" -- frost.ice
local nord12 = "#D08770" -- aurora.orange
local nord15 = "#B48EAD" -- aurora.purple

-- Slot keys matching Alt keybinds in tmux.conf
local slot_keys = { "j", "k", "l", ";", "m", ",", ".", "/" }

function _G.HarpoonLineNr()
  local lnum = vim.v.lnum
  local key = slot_keys[lnum] or " "
  if lnum == vim.fn.line(".") then
    return "%#CursorLineNr# " .. key .. " "
  end
  return "%#LineNr# " .. key .. " "
end

-- Options
vim.opt.termguicolors = true
vim.opt.number = false
vim.opt.statuscolumn = "%!v:lua.HarpoonLineNr()"
vim.opt.cursorline = true
vim.opt.signcolumn = "no"
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.laststatus = 0
vim.opt.cmdheight = 1
vim.opt.shortmess:append("I") -- skip intro

-- Colors: match Nord theme
vim.api.nvim_set_hl(0, "Normal", { fg = nord4, bg = nord0 })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = nord4, bg = nord0 })
vim.api.nvim_set_hl(0, "CursorLine", { bg = nord1 })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = nord8, bg = nord1, bold = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = nord4, bg = "NONE" })
vim.api.nvim_set_hl(0, "Visual", { fg = nord12, bg = nord3 })
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = nord0, bg = nord0 })
vim.api.nvim_set_hl(0, "StatusLine", { fg = nord4, bg = nord0 })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = nord4, bg = nord0 })
vim.api.nvim_set_hl(0, "Comment", { fg = nord15, italic = true })

-- Keymaps: move lines (normal + visual, matching main config muscle memory)
vim.keymap.set("n", "J", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
vim.keymap.set("n", "K", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- Save and quit
vim.keymap.set("n", "<Escape>", ":wq<CR>", { silent = true, desc = "Save and quit" })

-- Quit without saving
vim.keymap.set("n", "q", ":q!<CR>", { silent = true, desc = "Quit without saving" })

-- Enter: save, switch to the session under cursor, then quit.
-- The tmux switch-client command is an IPC call to the tmux server,
-- so it completes immediately before the popup tears down nvim.
vim.keymap.set("n", "<CR>", function()
  local line = vim.api.nvim_get_current_line()
  -- harpoon format is session_name=session_path (possibly with :window.pane)
  local session = line:match("^([^=]+)")
  if not session or session == "" then
    return
  end
  vim.cmd("silent! write")
  vim.fn.system({ "tmux", "switch-client", "-t", "=" .. session })
end, { silent = true, desc = "Save and switch to session" })
