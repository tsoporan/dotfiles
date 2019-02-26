-- tsoporan theme
-- Customized from: https://github.com/4ban/awesome-pro/blob/master/themes/pro-dark/theme.lua

local gears      = require("gears")
local xresources = require("beautiful.xresources")
local dpi        = xresources.apply_dpi

local theme             = {}
theme.dir               = os.getenv("HOME") .. "/.config/awesome/themes/tsoporan"

theme.icons             = theme.dir .. "/icons"
theme.wallpaper         = os.getenv("HOME") .. "/.wallpapers/4k-clouds.jpg"

theme.panel             = "#333333"
theme.panel_height      = dpi(28)
theme.font              = "Fira Mono 9"

theme.fg_normal         = "#f9f9f9"
theme.fg_focus          = "#e4e4e4"
theme.fg_urgent         = "#CC9393"
theme.bat_fg_critical   = "#232323"
theme.bg_normal         = "#3F3F3F"
theme.bg_focus          = "#5a5a5a"
theme.bg_urgent         = "#3F3F3F"
theme.bg_systray        = "#343434"
theme.bat_bg_critical   = "#ff0000"

theme.clockgf           = "#f9f9f9"

-- Borders

theme.border_width  = dpi(4)
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#276fbf"
theme.border_marked = "#CC9393"

-- Menu

theme.menu_height = dpi(38)
theme.menu_width  = dpi(100)

-- Notifications
theme.notification_font         = "Fira Mono 9"
theme.notification_bg           = "#121212"
theme.notification_fg           = "#e4e4e4"
theme.notification_border_width = dpi(4)
theme.notification_border_color = "#ffffff"
theme.notification_opacity      = 1
theme.notification_margin       = 100
theme.notification_padding      = 20
theme.notification_max_width    = 800
theme.notification_max_height   = 800

-- Taglist

theme.taglist_bg_empty    = "#333333"
theme.taglist_bg_occupied = "#ad5d4e"
theme.taglist_bg_urgent   = "#f03a47"
theme.taglist_bg_focus    = "#eb6534"
theme.taglist_font        = "Fira Mono 9"

-- Tasklist

theme.tasklist_font                 = "Fira Mono 9"
theme.tasklist_disable_icon         = true
theme.tasklist_bg_normal            = "#333333"
theme.tasklist_bg_focus             = "#444444"
theme.tasklist_bg_urgent            = "#f03a47"
theme.tasklist_fg_focus             = "#DDDDDD"
theme.tasklist_fg_urgent            = "#EEEEEE"
theme.tasklist_fg_normal            = "#AAAAAA"
theme.tasklist_floating             = ""
theme.tasklist_sticky               = ""
theme.tasklist_ontop                = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

-- Separators

theme.spr    = theme.icons .. "/panel/separators/spr.png"
theme.sprtr  = theme.icons .. "/panel/separators/sprtr.png"
theme.spr4px = theme.icons .. "/panel/separators/spr4px.png"
theme.spr5px = theme.icons .. "/panel/separators/spr5px.png"

return theme
