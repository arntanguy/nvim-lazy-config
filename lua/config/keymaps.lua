-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- helper functions to simplify mapping
local function map(mode, shortcut, command, options)
  -- vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true })
  vim.keymap.set(mode, shortcut, command, options)
end

local function nmap(shortcut, command, options)
  map("n", shortcut, command, options)
end

local function vmap(shortcut, command, options)
  map("v", shortcut, command, options)
end

local function imap(shortcut, command, options)
  map("i", shortcut, command, options)
end

nmap("<leader>ch", ":ClangdSwitchSourceHeader<cr>", { desc = "Switch between source/header (clang)" })
vim.keymap.set("n", "<leader>sx", require("telescope.builtin").resume, { noremap = true, silent = true, desc = "Telescope resume"})
