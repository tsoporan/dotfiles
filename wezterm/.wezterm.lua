local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font =
  wezterm.font('JetBrainsMono NF', { weight = 'Regular', italic = false})


config.color_scheme = 'Dracula+'
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

return config
