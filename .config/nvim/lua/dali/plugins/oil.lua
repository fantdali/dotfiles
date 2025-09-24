return {
	"stevearc/oil.nvim",
	---@module 'oil'
	opts = {
		default_file_explorer = true,
	},
	keys = {
		{ "-",         "<cmd>Oil<cr>" },
		{ "<leader>-", "<cmd>Oil --float<cr>" },
	},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
}
