-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join next line" })
vim.keymap.set("i", "<C-d>", "<Esc><C-d>", { desc = "Page up" })
vim.keymap.set("i", "<C-u>", "<Esc><C-u>", { desc = "Page down" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next term" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous term" })
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "kk", "<Esc>")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("x", "<leader>P", '"_dP', { desc = "Paste no replace" })
vim.keymap.set("n", "<leader>r", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace in buffer" })
vim.keymap.set("n", "<leader><space>", "<cmd>b#<cr>", { desc = "Previous buffer" })
