-- tsoporans AwesomeWM config circa 2019

-- LuaRocks - if installed
pcall(require, "luarocks.loader")

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local lain          = require("lain")
local markup        = lain.util.markup

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Override for now, using beautiful does not work!
naughty.config.defaults.margin = 20
naughty.config.padding = 20
naughty.config.spacing = 20

-- Error handling
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err) })
    in_error = false
  end)
end


-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
local terminal    = "alacritty"
local editor      = os.getenv("EDITOR") or "vim"
local editor_cmd  = terminal .. " -e " .. editor
local browser     = "firefox-developer-edition"
local modkey      = "Mod4"
local altkey      = "Mod1"
local scrlock     = "xscreensaver-command -lock"
local emacs       = "emacsclient -nc"

-- Theme
local themename  = "tsoporan"
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/" .. themename .. "/theme.lua")

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.max,
  lain.layout.termfair,
  lain.layout.centerwork,
}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end },
}

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
awful.util.terminal    = terminal

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Widgets

---- Clock / Cal
clockgf = beautiful.clockgf

local chosen_clock_type = "%a %d %b %H:%M"
local textclock         = wibox.widget.textclock(chosen_clock_type)
local clock_widget      = wibox.container.background(textclock)

lain.widget.cal({
    attach_to = { textclock },
    three = true,
    notification_preset = {
      font = beautiful.notification_font,
      fg = beautiful.notification_fg,
      bg = beautiful.notification_bg
    }
})

---- CPU
local cpu_icon = wibox.widget.textbox("[CPU]")

local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(" " .. cpu_now.usage .. "%" .. markup.font("Terminus 4", " "))
    end
})

local cpu_widget = wibox.container.background(cpu.widget)

---- MEM
local mem_icon = wibox.widget.textbox("[MEM]")

local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(" " .. mem_now.used .. "MB" .. markup.font("Terminus 4", " "))
    end
})
local mem_widget = wibox.container.background(mem.widget)

-- FS
local fs_icon = wibox.widget.textbox("[FS]")

local fs = lain.widget.fs({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, " " .. fs_now["/"].percentage .. "%"))
    end,
    notification_preset = {
      font =  beautiful.notification_font,
      fg = beautiful.notification_fg,
      bg = beautiful.notification_bg
    }
})
local fs_widget = wibox.container.background(fs.widget)

-- Battery
local bat_icon = wibox.widget.textbox("BAT")
local bat = lain.widget.bat({
    battery = "BAT0",
    timeout = 30,
    notify = "on",
    n_perc = {5,15}, -- crit, low

    settings = function()
        bat_notification_charged_preset = {
          title   = "Battery full",
          text    = "You can unplug the cable",
          timeout = 15,
        }

        bat_notification_low_preset = {
            title = "Battery low",
            text = "Plug the cable!",
            timeout = 15,
        }
        bat_notification_critical_preset = {
            title = "Battery exhausted",
            text = "Shutdown imminent",
            timeout = 15,
        }

        if bat_now.status ~= "N/A" then
            if bat_now.status == "Charging" then
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, "+" .. bat_now.perc .. "%")))
            elseif bat_now.status == "Full" then
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, "~" .. bat_now.perc .. "%")))
            elseif tonumber(bat_now.perc) <= 35 then
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, "-" .. bat_now.perc .. "%")))
            elseif tonumber(bat_now.perc) <= 80 then
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, "-" .. bat_now.perc .. "%")))
            elseif tonumber(bat_now.perc) <= 99 then
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, "-" .. bat_now.perc .. "%")))
            else
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, "-" .. bat_now.perc .. "%")))
            end
        else
            widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, " AC ")))
        end
    end
})
local bat_widget = wibox.container.background(bat.widget)

--- Vol
local vol_icon = wibox.widget.textbox("SND")

local volume = lain.widget.pulse {
    settings = function()
        vlevel = volume_now.left .. "%"
        if volume_now.muted == "yes" then
            vlevel = vlevel .. " M"
        end
        widget:set_markup(lain.util.markup("#ffffff", vlevel))
    end
}

local vol_widget = wibox.container.background(volume.widget)

-- End Widgets

-- Wibar

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
                            if client.focus then
                                client.focus:move_to_tag(t)
                            end
                        end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
                            if client.focus then
                                client.focus:toggle_tag(t)
                            end
                        end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c)
                          if c == client.focus then
                              c.minimized = true
                          else
                              c:emit_signal(
                                  "request::activate",
                                  "tasklist",
                                  {raise = true}
                              )
                          end
                      end),
  awful.button({ }, 3, function()
                          awful.menu.client_list({ theme = { width = 250 } })
                      end),
  awful.button({ }, 4, function ()
                          awful.client.focus.byidx(1)
                      end),
  awful.button({ }, 5, function ()
                          awful.client.focus.byidx(-1)
                      end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Empty due to icon
tagnames = {
  "一",
  "二",
  "三",
  "四",
  "五",
  "六",
  "七",
  "八",
  "九",
}

spacer = wibox.widget.textbox(" | ")
space = wibox.widget.textbox(" ")

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag(tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
      position = "top",
      screen   = s,
      height   = beautiful.panel_height,
      bg       = beautiful.panel,
      fg       = beautiful.fg_normal
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            s.mypromptbox,
            wibox.widget.systray(),

            -- Battery widget
            spacer,
            bat_icon,
            space,
            bat_widget,
            spacer,

            -- Vol widget
            vol_icon,
            space,
            vol_widget,
            spacer,

            -- Clock
            clock_widget,

            spacer,
            s.mylayoutbox,
            space,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    -- Brightness
    awful.key({ }, "XF86MonBrightnessDown", function () awful.util.spawn("xbacklight -dec 10") end),
    awful.key({ }, "XF86MonBrightnessUp", function () awful.util.spawn("xbacklight -inc 10") end),

    -- Select screenshot
    awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'", false) end),

    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key(
      { modkey, "Control" }, "n",
      function ()
          local c = awful.client.restore()
          -- Focus restored client
          if c then
            c:emit_signal(
                "request::activate", "key.unminimize", {raise = true}
            )
          end
      end,
      {description = "restore minimized", group = "client"}
    ),

    awful.key(
      { modkey }, "r",
      function ()
        awful.spawn.with_shell("rofi -show combi -theme gruvbox-dark-hard")
      end,
      {description = "run rofi", group = "custom"}
    ),

    awful.key(
      { modkey}, "c",
      function ()
        awful.spawn("clipster -p")
      end,
      {description = "copy paste", group = "custom"}
    ),

    awful.key(
      { modkey }, "t",
      function ()
        awful.spawn.with_shell("rofi-pass")
      end,
      {description = "run rofi pass", group = "custom"}
    ),

    awful.key(
      { modkey }, "x",
      function ()
        awful.spawn(scrlock)
      end,
      { description = "lock the screen", group = "custom" }
    ),

    awful.key(
      { modkey }, "e",
      function ()
        awful.spawn(emacs)
      end,
      { description = "emacs client", group = "custom" }
    )


)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),

    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),

  -- Audio (PulseAudio)
  awful.key({ altkey }, "Up",
      function ()
          os.execute(string.format("pactl set-sink-volume %d +10%%", volume.device))
          volume.update()
      end),
  awful.key({ altkey }, "Down",
      function ()
          os.execute(string.format("pactl set-sink-volume %d -10%%", volume.device))
          volume.update()
      end),
  awful.key({ altkey }, "m",
      function ()
          os.execute(string.format("pactl set-sink-mute %d toggle", volume.device))
          volume.update()
      end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

--Beautiful settings

beautiful.useless_gap = 3
