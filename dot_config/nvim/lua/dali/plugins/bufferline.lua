return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local bufferline = require("bufferline")

		-- match background to your colorscheme's Normal
		local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
		local bg = normal and normal.bg or nil

		bufferline.setup({
			options = {
				mode = "tabs",
				indicator = { style = "none" }, -- no bright line at start
				separator_style = { "", "" }, -- no separators
				show_buffer_close_icons = false,
				show_close_icon = false,
				diagnostics = true,
				always_show_bufferline = true,
				-- numbers = "ordinal",
				show_tab_indicators = false,
				-- offsets = { { filetype = "NvimTree", text = "", separator = false } },
			},
			highlights = {
				fill = { bg = bg }, -- tabline bg = Normal
				background = { bg = bg },
				buffer_selected = { italic = false, bold = true },
				numbers_selected = { italic = false },
				diagnostic_selected = { italic = false },
				hint_selected = { italic = false },
				info_selected = { italic = false },
				warning_selected = { italic = false },
				error_selected = { italic = false },
				pick_selected = { italic = false },
				pick_visible = { italic = false },
				pick = { italic = false },
			},
		})

		-- in case a theme overrides it later
		vim.cmd("hi! link BufferLineFill Normal")

		-- Keymaps (Normal mode): cycle buffers (tabs)
		vim.keymap.set("n", "<M-K>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
		vim.keymap.set("n", "<M-J>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
	end,
}
