-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.enable_tab_bar = false
config.font = wezterm.font("FiraCode Nerd Font Mono")
config.font_size = 9
local light_mode = false
local home = os.getenv("HOME")
if light_mode then
	config.colors = {
		-- The default text color
		foreground = "#4F5e68",
		-- The default background color
		background = "#F0EDEC",

		-- Overrides the cell background color when the current cell is occupied by the
		-- cursor and the cursor style is set to Block
		cursor_bg = "#2c363c",
		-- Overrides the text color when the current cell is occupied by the cursor
		cursor_fg = "#F0EDEC",
		-- Specifies the border color of the cursor when the cursor style is set to Block,
		-- or the color of the vertical or horizontal bar when the cursor style is set to
		-- Bar or Underline.
		cursor_border = "#2c363c",

		-- the foreground color of selected text
		selection_fg = "#F0edec",
		-- the background color of selected text
		selection_bg = "#2c363c",

		-- The color of the scrollbar "thumb"; the portion that represents the current viewport
		scrollbar_thumb = "#222222",

		-- The color of the split lines between panes
		split = "#444444",

		ansi = {
			"#F0EDEC",
			"#A8334C",
			"#4F6C31",
			"#944927",
			"#286486",
			"#88507D",
			"#3B8992",
			"#2C363C",
		},
		brights = {

			"#CFC1BA",
			"#94253E",
			"#3F5A22",
			"#803D1C",
			"#1D5573",
			"#7B3B70",
			"#2B747C",
			"#4F5E68",
		},
	}
	config.window_background_opacity = 0.95
	local f = io.open(home .. "/.config/nvim/light_mode", "w")
	assert(f)
	f:close()
else
	config.colors = {
		-- The default text color
		foreground = "#8e8e8e",
		-- The default background color
		background = "#191919",

		-- Overrides the cell background color when the current cell is occupied by the
		-- cursor and the cursor style is set to Block
		cursor_bg = "#BBBBBB",
		-- Overrides the text color when the current cell is occupied by the cursor
		cursor_fg = "#191919",
		-- Specifies the border color of the cursor when the cursor style is set to Block,
		-- or the color of the vertical or horizontal bar when the cursor style is set to
		-- Bar or Underline.
		cursor_border = "#BBBBBB",

		-- the foreground color of selected text
		selection_fg = "#191919",
		-- the background color of selected text
		selection_bg = "#BBBBBB",

		-- The color of the scrollbar "thumb"; the portion that represents the current viewport
		scrollbar_thumb = "#222222",

		-- The color of the split lines between panes
		split = "#444444",

		ansi = {
			"#191919",
			"#DE6E7C",
			"#819B69",
			"#B77E64",
			"#6099C0",
			"#B279A7",
			"#66A5AD",
			"#BBBBBB",
		},
		brights = {
			"#3d3839",
			"#E8838F",
			"#8BAE68",
			"#D68C67",
			"#61ABDA",
			"#CF86C1",
			"#65B8C1",
			"#8e8e8e",
		},
	}
	config.window_background_opacity = 0.85
	os.remove(home .. "/.config/nvim/light_mode")
end

config.keys = {
	{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action.DecreaseFontSize },
	{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.IncreaseFontSize },
}
-- and finally, return the configuration to wezterm
return config -- Pull in the wezterm API
