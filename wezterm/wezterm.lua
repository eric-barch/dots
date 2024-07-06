local wezterm = require("wezterm")
local config = {}

config.color_scheme = "onedarkpro_onedark"
config.cursor_blink_rate = 0
config.enable_tab_bar = false
config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 14
config.hide_tab_bar_if_only_one_tab = true
config.line_height = 1.2
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}

return config
