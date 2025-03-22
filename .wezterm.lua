-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- config.color_scheme = "Rosé Pine (base16)"
config.color_scheme = "rose-pine"
config.colors = {
	-- background = "black",
	background = "#0d101a",
	selection_bg = "#4D7F7D", -- Background color for the selection
	selection_fg = "#FFFFFF", -- Foreground (text) color for the selection
}

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 16

config.enable_tab_bar = false

config.window_padding = {
	left = "0.6cell",
	right = "0.3cell",
	top = "0.2cell",
	bottom = "0.2cell",
}

--config.visual_bell = {
--	fade_in_duration_ms = 75,
--	fade_out_duration_ms = 75,
--	target = "CursorColor",
--}
--config.colors = {
--	visual_bell = "#202028",
--}

config.window_decorations = "RESIZE"

config.window_background_opacity = 1
config.macos_window_background_blur = 0

config.scrollback_lines = 5000

local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize() -- Maximizes the window on startup
end)

local act = wezterm.action

config.keys = {
	{
		key = "t",
		mods = "CMD|SHIFT",
		action = act.ShowTabNavigator,
	},
	--	{
	--		key = "k",
	--		mods = "CMD",
	--		action = wezterm.action({ ClearScrollback = "ScrollbackAndViewport" }),
	--	},
	-- Alternative keys for page scrolling
	{
		key = "b",
		mods = "CTRL",
		action = wezterm.action.ScrollByPage(-1),
	},
	{
		key = "f",
		mods = "CTRL",
		action = wezterm.action.ScrollByPage(1),
	},
}

-- and finally, return the configuration to wezterm
return config
