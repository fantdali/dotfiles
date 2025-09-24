return {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
		-- optional: LSP source if you use LSP
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		require("luasnip.loaders.from_vscode").lazy_load()

		-- INSERT MODE
		cmp.setup({
			preselect = cmp.PreselectMode.Item,
			completion = {
				autocomplete = { cmp.TriggerEvent.TextChanged },
				completeopt = "menu,menuone,noinsert",
			},
			snippet = {
				expand = function(args) luasnip.lsp_expand(args.body) end,
			},
			mapping = cmp.mapping.preset.insert({
				-- navigate items
				["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

				-- scroll docs (use Shift with j/k so there's no conflict)
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),

				-- confirm with Tab; confirm first if none selected
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = true })
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<C-e>"] = cmp.mapping.abort(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- keep if using LSP
				{ name = "luasnip" },
			}, {
				{ name = "path" },
				{ name = "buffer" },
			}),
			formatting = {
				format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }),
			},
			experimental = { ghost_text = true },
		})

		-- CMDLINE: ":" (commands + paths)
		-- cmp.setup.cmdline(":", {
		-- 	completion = {
		-- 		autocomplete = { cmp.TriggerEvent.TextChanged },
		-- 		completeopt = "menu,menuone,noinsert",
		-- 	},
		-- 	mapping = {
		-- 		["<C-j>"]   = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		-- 		["<C-k>"]   = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		-- 		["<C-S-j>"] = cmp.mapping.scroll_docs(4),
		-- 		["<C-S-k>"] = cmp.mapping.scroll_docs(-4),
		-- 		["<C-e>"]   = cmp.mapping.abort(),
		-- 		["<Tab>"]   = cmp.mapping(function(fallback)
		-- 			if cmp.visible() then cmp.confirm({ select = true }) else fallback() end
		-- 		end),
		-- 	},
		-- 	sources = cmp.config.sources({
		-- 		{ name = "path" },
		-- 	}, {
		-- 		{ name = "cmdline" },
		-- 	}),
		-- })
		--
		cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = 'path' }
			}, {
				{ name = 'cmdline' }
			}),
			matching = { disallow_symbol_nonprefix_matching = false }
		})

		-- CMDLINE: "/" and "?" (buffer words)
		-- for _, c in ipairs({ "/", "?" }) do
		-- 	cmp.setup.cmdline(c, {
		-- 		completion = {
		-- 			autocomplete = { cmp.TriggerEvent.TextChanged },
		-- 			completeopt = "menu,menuone,noinsert",
		-- 		},
		-- 		mapping = {
		-- 			["<C-j>"]   = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		-- 			["<C-k>"]   = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		-- 			["<C-S-j>"] = cmp.mapping.scroll_docs(4),
		-- 			["<C-S-k>"] = cmp.mapping.scroll_docs(-4),
		-- 			["<C-e>"]   = cmp.mapping.abort(),
		-- 			["<Tab>"]   = cmp.mapping(function(fallback)
		-- 				if cmp.visible() then cmp.confirm({ select = true }) else fallback() end
		-- 			end),
		-- 		},
		-- 		sources = { { name = "buffer" } },
		-- 	})
		-- end
	end,
}
