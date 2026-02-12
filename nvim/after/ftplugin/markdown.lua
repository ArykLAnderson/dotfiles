-- Disable the treesitter-based keymaps from runtime markdown.lua that cause hangs
pcall(vim.keymap.del, 'n', 'gO', { buffer = 0 })
pcall(vim.keymap.del, 'n', ']]', { buffer = 0 })
pcall(vim.keymap.del, 'n', '[[', { buffer = 0 })
