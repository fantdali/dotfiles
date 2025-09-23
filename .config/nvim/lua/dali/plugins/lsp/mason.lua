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
			-- list of servers for mason to install (only your requested languages)
			ensure_installed = {
				"gopls", -- Go
				"rust_analyzer", -- Rust
				"pyright", -- Python
				"clangd", -- C/C++
				"lua_ls", -- Lua
				"marksman", -- Markdown
				"yamlls", -- YAML
				"taplo", -- TOML
				"jsonls", -- JSON
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
			},
		})
	end,
}
