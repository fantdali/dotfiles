if vim.g.vscode then
	require("dali.core.keymaps")
	require("dali.core.keymaps_vscode")
	require("dali.core.options_vscode")
	require("dali.lazy_vscode")
else
	require("dali.core")
	require("dali.lazy")
end
