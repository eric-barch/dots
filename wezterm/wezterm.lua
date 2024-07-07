local wezterm = require("wezterm")
local config = {}

config.color_scheme = "catppuccin-mocha"
config.cursor_blink_rate = 0
config.enable_tab_bar = false
config.font = wezterm.font("CaskaydiaCove Nerd Font", { weight = "Regular" })
config.font_size = 14
config.line_height = 1.2
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}

return config
