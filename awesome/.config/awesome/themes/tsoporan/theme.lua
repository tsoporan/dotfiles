-- tsoporan theme
-- Customized from: https://github.com/4ban/awesome-pro/blob/master/themes/pro-dark/theme.lua

local gears = require("gears")

local chosen_taglist_type = "sticks" -- bubbles

local theme             = {}
theme.dir               = os.getenv("HOME") .. "/.config/awesome/themes/tsoporan"

theme.icons             = theme.dir .. "/icons"
theme.wallpaper         = os.getenv("HOME") .. "/.wallpapers/4k-clouds.jpg"

theme.panel             = "#333333"
theme.font              = "Hack 12"
theme.calendar_font     = "Hack 12"
theme.fs_font           = "Hack 12"

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

theme.border_width  = 7
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#276fbf"
theme.border_marked = "#CC9393"

-- Menu

theme.menu_height = 38
theme.menu_width  = 160

-- Notifications
theme.notification_font         = "Hack 12"
theme.notification_bg           = "#232323"
theme.notification_fg           = "e4e4e4"
theme.notification_border_width = 0
theme.notification_border_color = "#232323"
theme.notification_shape        = gears.shape.infobubble
theme.notification_opacity      = 1
theme.notification_margin       = 60

-- Taglist

theme.taglist_bg_empty    = "#333333"
theme.taglist_bg_occupied = "#ad5d4e"
theme.taglist_bg_urgent   = "#f03a47"
theme.taglist_bg_focus    = "#eb6534"
theme.taglist_font        = "Hack 12"

-- Tasklist

theme.tasklist_font                 = "Hack 12"
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

-- Widget

theme.widget_display   = theme.icons .. "/panel/widgets/display/widget_display.png"
theme.widget_display_r = theme.icons .. "/panel/widgets/display/widget_display_r.png"
theme.widget_display_c = theme.icons .. "/panel/widgets/display/widget_display_c.png"
theme.widget_display_l = theme.icons .. "/panel/widgets/display/widget_display_l.png"

-- Separators

theme.spr    = theme.icons .. "/panel/separators/spr.png"
theme.sprtr  = theme.icons .. "/panel/separators/sprtr.png"
theme.spr4px = theme.icons .. "/panel/separators/spr4px.png"
theme.spr5px = theme.icons .. "/panel/separators/spr5px.png"

-- Clock / Calendar

theme.widget_clock = theme.icons .. "/panel/widgets/widget_clock.png"
theme.widget_cal   = theme.icons .. "/panel/widgets/widget_cal.png"

-- CPU / TMP

theme.widget_cpu    = theme.icons .. "/panel/widgets/widget_cpu.png"
-- theme.widget_tmp = theme.icons .. "/panel/widgets/widget_tmp.png"

-- MEM

theme.widget_mem = theme.icons .. "/panel/widgets/widget_mem.png"

-- FS

theme.widget_fs     = theme.icons .. "/panel/widgets/widget_fs.png"
theme.widget_fs_hdd = theme.icons .. "/panel/widgets/widget_fs_hdd.png"

-- NET

theme.widget_netdl = theme.icons .. "/panel/widgets/widget_netdl.png"
theme.widget_netul = theme.icons .. "/panel/widgets/widget_netul.png"

-- Misc

theme.menu_submenu_icon = theme.icons .. "/submenu.png"

-- Titlebar
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"

theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.svg"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.svg"

theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.svg"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.svg"

theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.svg"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.svg"

theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.svg"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.svg"

theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.svg"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.svg"

theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"

theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

return theme
