return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		"zbirenbaum/copilot.lua",
		"nvim-lua/plenary.nvim",
	},
	cmd = {
		"CopilotChat",
		"CopilotChatOpen",
		"CopilotChatToggle",
		"CopilotChatExplain",
		"CopilotChatReview",
		"CopilotChatFix",
		"CopilotChatOptimize",
		"CopilotChatTests",
		"CopilotChatDocs",
	},
	keys = {
		{ "<leader>cc", "<cmd>CopilotChatToggle<CR>", desc = "Toggle Copilot Chat" },
		{ "<leader>ce", "<cmd>CopilotChatExplain<CR>", mode = { "n", "v" }, desc = "Explain code" },
		{ "<leader>cr", "<cmd>CopilotChatReview<CR>", mode = { "n", "v" }, desc = "Review code" },
		{ "<leader>cf", "<cmd>CopilotChatFix<CR>", mode = { "n", "v" }, desc = "Fix code" },
		{ "<leader>co", "<cmd>CopilotChatOptimize<CR>", mode = { "n", "v" }, desc = "Optimize code" },
		{ "<leader>ct", "<cmd>CopilotChatTests<CR>", mode = { "n", "v" }, desc = "Generate tests" },
		{ "<leader>cd", "<cmd>CopilotChatDocs<CR>", mode = { "n", "v" }, desc = "Generate docs" },
	},
	opts = {},
}
