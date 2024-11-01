return {
	{ "easymotion/vim-easymotion" },
	{ "justinmk/vim-sneak" },
	config = function()
		local opts = { noremap = true, silent = true }
		vim.keymap.set("n", "<Leader><Leader>w", "<Plug>(easymotion-bd-w)", opts)
	end,
}
