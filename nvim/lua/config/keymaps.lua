-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Augment Keybindings
vim.keymap.set("n", "<leader>aa", "<cmd>Augment chat<CR>", { desc = "Launch Augment Chat" })
vim.keymap.set("n", "<leader>at", "<cmd>Augment chat-toggle<CR>", { desc = "Toggle Augment Chat Window" })
vim.keymap.set("n", "<leader>an", "<cmd>Augment chat-new<CR>", { desc = "Launch new Chat" })
