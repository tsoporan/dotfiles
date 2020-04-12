-- tsoporan theme
-- Customized from: https://github.com/4ban/awesome-pro/blob/master/themes/pro-dark/theme.lua

local gears      = require("gears")
local xresources = require("beautiful.xresources")
local dpi        = xresources.apply_dpi

local theme             = {}
theme.dir               = os.getenv("HOME") .. "/.config/awesome/themes/tsoporan"

theme.icons             = theme.dir .. "/icons"
theme.wallpaper         = os.getenv("HOME") .. "/.wallpapers/space.jpg"

theme.panel             = "#1d2021"
theme.panel_height      = dpi(28)
theme.font              = "Fira Code 10"

theme.fg_normal         = "#fbf1c7"
theme.fg_focus          = "#ffffff"
theme.fg_urgent         = "#CC9393"

theme.bg_normal         = "#1d2021"
theme.bg_focus          = "#000000"
theme.bg_urgent         = "#3F3F3F"
theme.bg_systray        = "#1d2021"

theme.bat_bg_critical   = "#ff0000"
theme.bat_fg_critical   = "#232323"

theme.clockgf           = "#f9f9f9"

-- Borders

theme.border_width  = dpi(3)
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#458588"
theme.border_marked = "#CC9393"

-- Menu

theme.menu_height = dpi(38)
theme.menu_width  = dpi(100)

-- Notifications
theme.notification_font         = "Fira Code 10"
theme.notification_bg           = "#1d2021"
theme.notification_fg           = "#fbf1c7"
theme.notification_border_width = dpi(4)
theme.notification_border_color = "#282828"
theme.notification_opacity      = 1
theme.notification_margin       = 100
theme.notification_padding      = 20
theme.notification_max_width    = 800
theme.notification_max_height   = 800

-- Taglist

theme.taglist_bg_empty    = "#1d2021"
theme.taglist_bg_occupied = "#458588"
theme.taglist_bg_urgent   = "#cc241d"
theme.taglist_bg_focus    = "#d79921"
theme.taglist_font        = "Fira Code 10"

-- Tasklist

theme.tasklist_font                 = "Fira Code 10"
theme.tasklist_disable_icon         = true
theme.tasklist_bg_normal            = "#1d2021"
theme.tasklist_bg_focus             = "#282828"
theme.tasklist_bg_urgent            = "#f03a47"
theme.tasklist_fg_focus             = "#DDDDDD"
theme.tasklist_fg_urgent            = "#EEEEEE"
theme.tasklist_fg_normal            = "#AAAAAA"
theme.tasklist_floating             = ""
theme.tasklist_sticky               = ""
theme.tasklist_ontop                = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

return theme
