local keymap = vim.keymap

local opts = { noremap = true, silent = true }

-- find
keymap.set("n", "<Leader>f", "<cmd>lua require('vscode').action('workbench.action.quickTextSearch')<CR>", opts)

-- harpoon
keymap.set("n", "<Leader>h", "<cmd>lua require('vscode').action('vscode-harpoon.addEditor')<CR>", opts)
keymap.set("n", "<Leader>he", "<cmd>lua require('vscode').action('vscode-harpoon.editEditors')<CR>", opts)
keymap.set("n", "<Leader>hp", "<cmd>lua require('vscode').action('vscode-harpoon.gotoPreviousHarpoonEditor')<CR>", opts)
keymap.set("n", "<Leader>hl", "<cmd>lua require('vscode').action('vscode-harpoon.editorQuickPick')<CR>", opts)

keymap.set("n", "gri", "<cmd>lua require('vscode').action('editor.action.goToImplementation')<CR>", opts)

-- Harpoon editor navigation
for i = 1, 9 do
	keymap.set(
		"n",
		"<Leader>" .. i,
		"<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor" .. i .. "')<CR>",
		opts
	)
end

-- Project management commands
keymap.set("n", "<Leader>m", "<cmd>lua require('vscode').action('projectManager.saveProject')<CR>", opts)
keymap.set("n", "<Leader>ml", "<cmd>lua require('vscode').action('projectManager.listProjects')<CR>", opts)
keymap.set("n", "<Leader>me", "<cmd>lua require('vscode').action('projectManager.editProjects')<CR>", opts)

-- previous tab
keymap.set(
	"n",
	"<Leader>o",
	"<cmd>lua require('vscode').action('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup')<CR>",
	opts
)

-- matches
local vscode = require("vscode")

keymap.set({ "n", "x", "i" }, "<C-m>", function()
	vscode.with_insert(function()
		vscode.action("editor.action.addSelectionToNextFindMatch")
	end)
end)
