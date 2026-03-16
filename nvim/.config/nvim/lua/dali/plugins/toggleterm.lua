return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 12,       -- bottom panel height
			direction = "horizontal", -- like VSCode panel
			start_in_insert = true,
			persist_size = true,
			shade_terminals = false, -- keep colors consistent
			close_on_exit = false, -- keep shell alive if it exits accidentally
		})

		-- Reusable singleton terminal (id=1)
		local Terminal = require("toggleterm.terminal").Terminal
		local panel = Terminal:new({
			id = 1,
			direction = "horizontal",
			hidden = true,
		})

		-- Toggle with <leader>0 from NORMAL **and** TERMINAL modes
		vim.keymap.set({ "n", "t" }, "<leader>0", function()
			panel:toggle()
		end, { desc = "Toggle terminal panel" })

		-- Quality-of-life: get to Normal mode from terminal quickly
		vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal -> Normal mode" })
		-- (optional) move between windows from terminal
		vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]])
		vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]])
		vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]])
		vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]])
	end,
}
