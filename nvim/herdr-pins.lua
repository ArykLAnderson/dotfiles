-- Minimal Nord UI for managing Herdr project and local pins.

local input = vim.env.HERDR_PINS_INPUT
local output = vim.env.HERDR_PINS_OUTPUT
if not input or not output then
  vim.cmd("cq")
  return
end

vim.opt.termguicolors = true
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.signcolumn = "no"
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.laststatus = 0
vim.opt.cmdheight = 1
vim.opt.wrap = false
vim.opt.shortmess:append("I")

vim.api.nvim_set_hl(0, "Normal", { fg = "#D8DEE9", bg = "#2E3440" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3B4252" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#2E3440", bg = "#2E3440" })

vim.cmd("silent edit " .. vim.fn.fnameescape(input))
vim.bo.buftype = "nofile"
vim.bo.bufhidden = "wipe"
vim.bo.swapfile = false
vim.bo.modifiable = true

local function move(delta)
  local line = vim.fn.line(".")
  local target = math.max(1, math.min(4, line + delta))
  if target == line then return end
  vim.cmd(string.format("move %d", delta > 0 and target or target - 1))
  vim.fn.cursor(target, 1)
end

local function finish(save)
  if save then
    local keys = {}
    for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 4, false)) do
      table.insert(keys, line:match("^([^\t]+)") or "empty")
    end
    while #keys < 4 do table.insert(keys, "empty") end
    vim.fn.writefile(keys, output)
  end
  vim.cmd("qa!")
end

vim.keymap.set("n", "J", function() move(1) end, { buffer = true, silent = true })
vim.keymap.set("n", "K", function() move(-1) end, { buffer = true, silent = true })
vim.keymap.set("n", "c", function()
  vim.api.nvim_set_current_line("empty\t-\t[empty]")
end, { buffer = true, silent = true })
vim.keymap.set("n", "<CR>", function() finish(true) end, { buffer = true, silent = true })
vim.keymap.set("n", "<Esc>", function() finish(true) end, { buffer = true, silent = true })
vim.keymap.set("n", "q", function() finish(false) end, { buffer = true, silent = true })

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.cmd("normal! gg")
    vim.api.nvim_echo({ { " j/k select  J/K reorder  c clear  Enter/Esc save  q cancel", "Comment" } }, false, {})
  end,
})
