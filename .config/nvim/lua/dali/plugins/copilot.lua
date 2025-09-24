return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	build = ":Copilot auth", -- run this after install to log in
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true, -- show inline suggestions as you type
				keymap = {
					accept = "<Tab>", -- accept suggestion
					next = "<M-]>", -- cycle next suggestion
					prev = "<M-[>", -- cycle previous suggestion
					dismiss = "<C-]>",
				},
			},
			panel = { enabled = false }, -- disable the side panel (keep it VSCode-like inline)
		})
	end,
}
