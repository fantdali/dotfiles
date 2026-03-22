return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		dashboard = { enabled = true },
		indent = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		input = { enabled = true },
	},
	keys = {
		{ "<leader>n",  function() require("snacks").notifier.show_history() end, desc = "Notification History" },
		{ "<leader>bd", function() require("snacks").bufdelete() end,             desc = "Delete Buffer" },
	},
}
