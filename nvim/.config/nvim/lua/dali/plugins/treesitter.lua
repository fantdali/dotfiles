return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local treesitter = require("nvim-treesitter")
		local ensure_installed = {
			"json",
			"yaml",
			"markdown",
			"markdown_inline",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"gitignore",
			"vimdoc",
			"c",
			"go",
			"gomod",
			"gosum",
			"gotmpl",
			"gowork",
			"python",
			"rust",
			"jsonnet",
		}

		treesitter.setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		if vim.fn.executable("tree-sitter") == 1 then
			treesitter.install(ensure_installed)
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
			callback = function(event)
				local ok = pcall(vim.treesitter.start, event.buf)
				if ok then
					vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})

		vim.keymap.set({ "n", "x" }, "<C-space>", function()
			vim.treesitter.select("parent")
		end, { desc = "Expand treesitter selection" })

		vim.keymap.set("x", "<bs>", function()
			vim.treesitter.select("child")
		end, { desc = "Shrink treesitter selection" })

		require("nvim-ts-autotag").setup()
	end,
}
