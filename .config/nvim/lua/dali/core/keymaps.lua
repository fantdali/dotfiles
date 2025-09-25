-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

local opts = { noremap = true, silent = true }

-- Helper: close all terminal buffers
local function close_terminals()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "terminal" then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end
end

-- Safe write+quit-all (replaces :wqa)
vim.api.nvim_create_user_command("Wqa", function()
	pcall(vim.cmd, "wa") -- write all
	close_terminals()
	pcall(vim.cmd, "qa")
end, {})

-- Force quit-all (replaces :qa!)
vim.api.nvim_create_user_command("QallForce", function()
	close_terminals()
	vim.cmd("qa!")
end, {})

-- Command-line abbreviations: replace builtins
vim.cmd([[cabbrev wqa Wqa]])
vim.cmd([[cabbrev qa QallForce]])

--------------------- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", opts)

-- clear search highlights
keymap.set("n", "<leader>/", ":nohl<CR>", opts) -- Clear search highlights
keymap.set("n", "<Leader>w", ":w<CR>", opts) -- Save file

keymap.set("n", "x", '"_x', opts) -- delete single character without copying into register
keymap.set("n", "<Leader>j", "J", opts) -- join lines

-- navigation
keymap.set("n", "J", "5jzz", opts)
keymap.set("n", "K", "5kzz", opts)
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- yank to system clipboard
keymap.set({ "n", "v" }, "<leader>y", '"+y', opts)
-- paste from system clipboard
keymap.set({ "n", "v" }, "<leader>p", '"+p', opts)

-- move text up and down
keymap.set("v", "J", ":m .+1<CR>==", opts)
keymap.set("v", "K", ":m .-2<CR>==", opts)
keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- paste preserves primal yanked piece
keymap.set("v", "p", '"_dP', opts)

-- better indent handling
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- update config
keymap.set({ "n", "v" }, "<leader>r", ":update<CR> :source<CR>")

-- window management
keymap.set("n", "<M-k>", "<cmd>resize +2<CR>") -- Increase height
keymap.set("n", "<M-j>", "<cmd>resize -2<CR>") -- Decrease height
keymap.set("n", "<M-h>", "<cmd>vertical resize +5<CR>") -- Increase width
keymap.set("n", "<M-l>", "<cmd>vertical resize -5<CR>") -- Decrease width

-- tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>")
end

-- open folder
-- keymap.set('n', '<C-f>', '<Cmd>Open .<CR>')

-- quickfix
keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
