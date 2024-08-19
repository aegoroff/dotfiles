local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.front_end = "WebGpu"
config.font_size = 12
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.enable_wayland = false
--config.color_scheme = 'Violet Light'
--config.color_scheme = 'Alabaster'
--config.color_scheme = 'Selenized Dark (Gogh)'
config.color_scheme = 'Selenized Light (Gogh)'
--config.color_scheme = 'Everforest Light Hard (Gogh)'
--config.color_scheme = 'Everforest Light Soft (Gogh)'
--config.color_scheme = 'Catppuccin Latte'

config.font = wezterm.font 'JetBrainsMono Nerd Font'
--config.freetype_load_target = "HorizontalLcd"
--config.freetype_render_target = 'HorizontalLcd'

return config
