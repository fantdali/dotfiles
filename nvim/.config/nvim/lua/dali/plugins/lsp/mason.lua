return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			-- ui = {
			-- 	icons = {
			-- 		package_installed = "✓",
			-- 		package_pending = "➜",
			-- 		package_uninstalled = "✗",
			-- 	},
			-- },
		})

		mason_lspconfig.setup({
			automatic_enable = false, -- we use vim.lsp.enable() in lspconfig.lua
			ensure_installed = {
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
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- Formatters
				"stylua", -- Lua
				"isort", -- Python
				"black", -- Python
				"rustfmt", -- Rust
				"gofumpt", -- Go
				"goimports", -- Go
				"clang-format", -- C/C++
				"yamlfmt", -- YAML
				"taplo", -- TOML
				"prettierd", -- Markdown/JSON (optional, for markdown/json)
				-- Linters
				"pylint", -- Python
				"jsonnetfmt",
			},
		})
	end,
}
