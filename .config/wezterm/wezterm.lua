local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.front_end = "WebGpu"
config.font_size = 12
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.enable_wayland = false
config.color_scheme = 'Material'
config.font = wezterm.font 'JetBrainsMono Nerd Font'
--config.freetype_load_target = "HorizontalLcd"
--config.freetype_render_target = 'HorizontalLcd'

return config
