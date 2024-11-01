-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

local opts = { noremap = true, silent = true }

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", opts)

-- clear search highlights
keymap.set("n", "<leader>/", ":nohl<CR>", opts) -- Clear search highlights
keymap.set("n", "<Leader>w", ":w<CR>", opts) -- Save file

keymap.set("n", "x", '"_x', opts) -- delete single character without copying into register
keymap.set("n", "<Leader>j", "J", opts) -- join lines
keymap.set("n", "<C-h>", "<C-w>h", opts) -- move to left window
keymap.set("n", "<C-j>", "<C-w>j", opts) -- move to bottom window
keymap.set("n", "<C-k>", "<C-w>k", opts) -- move to top window
keymap.set("n", "<C-l>", "<C-w>l", opts) -- move to right window

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

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", opts) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", opts) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", opts) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", opts) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", opts) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", opts) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", opts) --  go to previous tab
keymap.set("n", "<leader>td", "<cmd>tabnew %<CR>", opts) --  move current buffer to new tab
