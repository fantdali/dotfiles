local keymap = vim.keymap

local opts = { noremap = true, silent = true }

-- Clear highlights and save
keymap.set("n", "<Leader>f", "<cmd>lua require('vscode').action('workbench.action.quickTextSearch')<CR>", opts) -- Assuming you want to bind to the search command
keymap.set("n", "<Leader>s", "<cmd>lua require('vscode').action('find-it-faster.findWithinFiles')<CR>", opts) -- Save project
keymap.set("n", "<Leader>S", "<cmd>lua require('vscode').action('find-it-faster.findFiles')<CR>", opts) -- Similar logic as above

-- Normal mode key bindings with commands
keymap.set("n", "<Leader>h", "<cmd>lua require('vscode').action('vscode-harpoon.addEditor')<CR>", opts)
keymap.set("n", "<Leader>he", "<cmd>lua require('vscode').action('vscode-harpoon.editEditors')<CR>", opts)
keymap.set("n", "<Leader>hp", "<cmd>lua require('vscode').action('vscode-harpoon.gotoPreviousHarpoonEditor')<CR>", opts)
keymap.set("n", "<Leader>hl", "<cmd>lua require('vscode').action('vscode-harpoon.editorQuickPick')<CR>", opts)

keymap.set("n", "gi", "<cmd>lua require('vscode').action('editor.action.goToImplementation')<CR>", opts)

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
keymap.set("n", "<Leader>d", "<cmd>lua require('vscode').action('projectManager.saveProject')<CR>", opts)
keymap.set("n", "<Leader>dl", "<cmd>lua require('vscode').action('projectManager.listProjects')<CR>", opts)
keymap.set("n", "<Leader>de", "<cmd>lua require('vscode').action('projectManager.editProjects')<CR>", opts)
