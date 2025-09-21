-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

local opts = { noremap = true, silent = true }

--------------------- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", opts)

-- clear search highlights
keymap.set("n", "<leader>/", ":nohl<CR>", opts) -- Clear search highlights
keymap.set("n", "<Leader>w", ":w<CR>", opts)    -- Save file

keymap.set("n", "x", '"_x', opts)               -- delete single character without copying into register
keymap.set("n", "<Leader>j", "J", opts)         -- join lines

-- navigation
keymap.set("n", "J", "5jzz", opts)
keymap.set("n", "K", "5kzz", opts)

-- yank to system clipboard
keymap.set({ "n", "v" }, "<leader>y", '"+y', opts)
-- paste from system clipboard
keymap.set({ "n", "v" }, "<leader>p", '"+p', opts)

-- move text up and down
keymap.set("v", "J", ":m .+1<CR>==", opts)
keymap.set("v", "K", ":m .-2<CR>==", opts)
keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)

-- paste preserves primal yanked piece
keymap.set("v", "p", '"_dP', opts)

-- better indent handling
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)
