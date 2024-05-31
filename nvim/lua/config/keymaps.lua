-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set(
  "n",
  "<leader>sx",
  require("telescope.builtin").resume,
  { noremap = true, silent = true, desc = "Resume" }
)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join next line" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page up" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page down" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next term" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous term" })
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "kk", "<Esc>")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set(
  "n",
  "<C-n>",
  "<cmd>silent !tmux neww tmux-sessionizer<CR>",
  { desc = "Open new tmux session from workspace" }
)
vim.keymap.set("n", "<C-f>", "<cmd>!tmux neww tmux-session-picker<CR>", { desc = "Open existing tmux session" })
vim.keymap.set("x", "<leader>P", '"_dP', { desc = "Paste no replace" })
vim.keymap.set("n", "<leader>r", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace in buffer" })

-- Yabai specific keymaps
vim.keymap.set({ "n", "v", "i" }, "<M-j>", "<cmd>silent !yabai -m window --focus south<CR>", { desc = "Yabai move up" })
vim.keymap.set({ "n", "v", "i" }, "<M-k>", "<cmd>silent !yabai -m window --focus north<CR>", { desc = "Yabai move up" })
vim.keymap.set({ "n", "v", "i" }, "<M-h>", "<cmd>silent !yabai -m window --focus west<CR>", { desc = "Yabai move up" })
vim.keymap.set({ "n", "v", "i" }, "<M-l>", "<cmd>silent !yabai -m window --focus east<CR>", { desc = "Yabai move up" })
