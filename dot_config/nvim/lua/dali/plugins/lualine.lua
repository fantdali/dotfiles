return {
	"nvim-lualine/lualine.nvim",
	config = function()
		-- a “no color” theme for every mode
		local plain = {
			a = { gui = "NONE" },
			b = {},
			c = {},
		}
		local theme = {
			normal = vim.deepcopy(plain),
			insert = vim.deepcopy(plain),
			visual = vim.deepcopy(plain),
			replace = vim.deepcopy(plain),
			command = vim.deepcopy(plain),
			inactive = vim.deepcopy(plain),
		}

		require("lualine").setup({
			options = {
				theme = theme,
				icons_enabled = false,
				component_separators = "",
				section_separators = "",
				globalstatus = true, -- per-window; NvimTree will be empty
				disabled_filetypes = {
					-- statusline = { "NvimTree" }, -- hide in NvimTree
				},
			},
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						path = 0,
						symbols = { modified = "[+]", readonly = "[-]", unnamed = "[No Name]" },
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "error", "warn" },
						symbols = { error = "E:", warn = "W:" },
						colored = false,
						update_in_insert = false,
					},
				},
				lualine_x = {},
				lualine_y = { "progress" }, -- %P
				lualine_z = { "location" }, -- %l:%c
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			extensions = {},
		})

		-- ensure Neovim's own statusline groups have no special bg (also fixes the
		-- case where NvimTree is focused and the other window shows shaded NC line)
		vim.cmd([[
		  hi! link StatusLine   Normal
		  hi! link StatusLineNC Normal
		]])
	end,
}
