return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/lazydev.nvim",                  ft = "lua",   opts = {} },
	},
	config = function()
		vim.diagnostic.config({
			signs = true,
			virtual_text = { spacing = 2, prefix = "" },
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = { border = "rounded" },
		})

		-- Neovim 0.11 built-in LSP keymaps: K (hover), grn (rename), gra (code action),
		-- grr (references), gri (implementations), [d / ]d (diagnostics), CTRL-S (signature)
		-- We only add Telescope-powered overrides and custom leader mappings.
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
				end

				map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Telescope definitions")
				map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				map("n", "gR", "<cmd>Telescope lsp_references<CR>", "Telescope references")
				map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Telescope implementations")
				map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Telescope type defs")
				map({ "n", "v" }, "<leader>.", vim.lsp.buf.code_action, "Code action")
				map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
				map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Buffer diagnostics")
				map("n", "<leader>d", vim.diagnostic.open_float, "Line diagnostics")
				map("n", "<leader>rs", "<cmd>LspRestart<CR>", "Restart LSP")
				map("n", "<leader>k", vim.lsp.buf.hover, "Show documentation")
			end,
		})

		-- Server-specific settings (merged with nvim-lspconfig defaults)
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					completion = { callSnippet = "Replace" },
				},
			},
		})

		-- Enable servers (auto-start on matching filetypes)
		vim.lsp.enable({
			"gopls",
			"rust_analyzer",
			"pyright",
			"clangd",
			"lua_ls",
			"marksman",
			"yamlls",
			"taplo",
			"jsonls",
			"jsonnet_ls",
		})
	end,
}
