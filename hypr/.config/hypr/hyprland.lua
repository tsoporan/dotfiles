--------------------------------------------------------------------------------
-- HYPRLAND CONFIGURATION - i3-like setup with native dwindle + groups
-- Last updated: 2026-11-01
--
-- Hyprland 0.57 reads this file only. It does not read hyprland.conf.
-- https://wiki.hypr.land/configuring/
--------------------------------------------------------------------------------
--
-- KEY FEATURES:
-- - Dwindle layout with native groups for tabbed containers
-- - Vi-style navigation: h/j/k/l
-- - Tabbed groups with mod+s, cycle tabs with mod+w
-- - Clipboard: Super+C/V universal copy/paste, Super+P clipse history
-- - Workspaces 1-10 on mod+1-0. The key for the workspace you are already
--   on returns to the previous workspace. mod+Escape does that jump directly.
--
-- ESSENTIAL KEYBINDINGS:
-- mod+Enter      = Terminal
-- mod+d          = App launcher
-- mod+q          = Close window
-- mod+h/j/k/l    = Navigate windows
-- mod+shift+hjkl = Move windows
-- mod+s          = Toggle group (tabbed)
-- mod+e          = Toggle split h/v
-- mod+w          = Cycle through group tabs
-- mod+a          = Maximize window
-- mod+1-0        = Focus workspace 1-10. Same key returns to the previous one.
-- mod+Escape     = Previous workspace (same history as the number keys)
-- mod+Shift+1-0  = Move the focused window to that workspace
-- mod+p          = Clipboard history (clipse)
-- mod+c / mod+v  = Copy / paste (app-aware)
-- mod+f          = Fullscreen
-- mod+r          = Resize mode
-- mod+ctrl+l     = Lock screen
--
--------------------------------------------------------------------------------

----------------
--- MONITORS ---
----------------

-- See https://wiki.hypr.land/configuring/core/monitors/
-- Auto detect monitor with 1.5x scaling
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1.5,
})


-------------------
--- MY PROGRAMS ---
-------------------

local terminal = "ghostty"
local menu     = "wofi --show drun --lines 30"


-----------------
--- AUTOSTART ---
-----------------

-- See https://wiki.hypr.land/configuring/core/autostart/
-- One handler so these start in the same order as the old exec-once lines.
-- Each exec_cmd is its own shell, so the sleeps still cover the pkill race.
hl.on("hyprland.start", function()
    -- Authentication agent (polkit - needed for privilege escalation dialogs)
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Kill stale processes from previous session before starting
    hl.exec_cmd("pkill -x waybar; pkill -x hyprpaper; pkill -x hypridle; pkill -x hyprlock; pkill -x swaync")
    hl.exec_cmd("sleep 0.5 && waybar")
    hl.exec_cmd("sleep 0.5 && hyprpaper")
    hl.exec_cmd("sleep 0.5 && swaync")
    hl.exec_cmd("sleep 1 && hypridle")

    -- Clipboard: clipse owns history. Do not run cliphist watchers or wl-clip-persist
    -- alongside it; they steal clipboard ownership and copies randomly vanish.
    hl.exec_cmd("~/.config/hypr/scripts/clipboard-listen.sh")

    -- GTK / portal session env (Wayland + dark + primary paste)
    hl.exec_cmd("~/.config/hypr/scripts/session-settings.sh")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland")
end)


-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

-- See https://wiki.hypr.land/configuring/core/environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("SSH_AUTH_SOCK", "/run/user/1000/gnupg/S.gpg-agent.ssh")

-- Wayland application compatibility
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")


-------------------
--- PERMISSIONS ---
-------------------

-- See https://wiki.hypr.land/configuring/core/advanced-configuration/permissions/
-- Permission changes require a Hyprland restart and are not applied on the fly.

-- hl.config({
--     ecosystem = {
--         enforce_permissions = true,
--     },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


---------------------
--- LOOK AND FEEL ---
---------------------

-- Refer to https://wiki.hypr.land/configuring/core/config-options/

hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 2,

        border_size = 3,

        -- Minimal black + electric yellow accent
        col = {
            active_border   = "rgb(e6fb04)",
            inactive_border = "rgba(202020ff)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/configuring/extra/tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },
})

-- https://wiki.hypr.land/configuring/layouts/dwindle-layout/
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- https://wiki.hypr.land/configuring/core/config-options/ (category: group)
-- Groupbar tabs used to be a two-stop gradient of one color. A solid color
-- paints the same bar.
hl.config({
    group = {
        col = {
            border_active          = "rgba(e6fb04ff)",
            border_inactive        = "rgba(202020ff)",
            border_locked_active   = "rgba(e6fb04ff)",
            border_locked_inactive = "rgba(303030ff)",
        },

        groupbar = {
            enabled        = true,
            font_family    = "JetBrainsMono Nerd Font",
            font_size      = 14,
            height         = 20,
            render_titles  = true,
            scrolling      = true,
            gradients      = true,
            keep_upper_gap = false,
            gaps_in        = 0,
            gaps_out       = 0,

            col = {
                active   = "rgba(1a1a1aff)",
                inactive = "rgba(101010ff)",
            },
            text_color = "rgba(e6fb04ff)",
        },
    },
})

hl.config({
    decoration = {
        rounding = 0,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = false,
        },

        blur = {
            enabled = false,
        },
    },
})

-- https://wiki.hypr.land/configuring/core/animations/
-- windows stays on easeOutQuint. windowsIn and fadeSwitch stay off.
hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = false })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "fadeSwitch",    enabled = false })

-- Workspace history.
-- https://wiki.hypr.land/configuring/core/config-options/ (category: binds)
--
-- workspace_back_and_forth
--   Focusing the workspace that is already focused goes to the previous
--   workspace instead. Super+1..0 call hl.dsp.focus({ workspace = N }), so
--   this is what happens when you press the number for the workspace you
--   are on.
--   From workspace 4, Super+2 focuses 2. Super+2 again returns to 4.
--   Focusing any other workspace replaces the remembered one.
--   Super+Escape is hl.dsp.focus({ workspace = "previous" }), the same jump
--   on its own key.
--
-- allow_workspace_cycles
--   Hyprland remembers the previous workspace (binds.allow_workspace_cycles).
--
-- movefocus_cycles_groupfirst
--   Inside a tabbed group, Super+h/j/k/l cycles the group's tabs before
--   focus leaves the group.
--
-- Super+Shift+1..0 calls hl.dsp.window.move({ workspace = N }). That follows
-- the window to the new workspace. The back-and-forth flag applies only to
-- hl.dsp.focus({ workspace = N }).
hl.config({
    binds = {
        workspace_back_and_forth      = true,
        allow_workspace_cycles        = true,
        movefocus_cycles_groupfirst   = true,
    },
})

-- Per-workspace layouts. See https://wiki.hypr.land/configuring/core/rules/
hl.workspace_rule({ workspace = "9", layout = "dwindle" })

-- Smart gaps - no gaps when only one window.
-- Anonymous, so file order is the evaluation order.
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
hl.window_rule({
    match       = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding    = 0,
})
hl.window_rule({
    match       = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding    = 0,
})

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
        focus_on_activate       = true,
        key_press_enables_dpms  = true,
        mouse_move_enables_dpms = true,
    },

    cursor = {
        hide_on_key_press = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})


-------------
--- INPUT ---
-------------

-- https://wiki.hypr.land/configuring/core/config-options/ (category: input)
-- Empty keyboard variant/model/options/rules are the defaults, so they are unset.
hl.config({
    input = {
        kb_layout = "us",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})


-----------------------------------
--- KEYBINDINGS (i3-like setup) ---
-----------------------------------

local mainMod = "SUPER"

-- === BASIC WINDOW MANAGEMENT ===
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("wofi --show window --lines 30"))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.exec_cmd("~/.config/hypr/scripts/show-cheatsheet.sh"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" })) -- true fullscreen
hl.bind(mainMod .. " + Escape", hl.dsp.focus({ workspace = "previous" }))

-- === CLIPBOARD MANAGEMENT ===
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("ghostty --class=clipse-picker --title=clipse -e clipse"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("~/.config/hypr/scripts/clipboard.sh copy"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("~/.config/hypr/scripts/clipboard.sh paste"))

-- === PASSWORD MANAGEMENT ===
-- The key is T, the same keysym the old config stored.
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("wofi-pass --copy"))

-- === FLOATING WINDOWS ===
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + space", hl.dsp.focus({ window = "floating" }))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.center())

-- === WINDOW RESIZING ===
-- relative = true keeps the old resizeactive deltas. Without it, x and y are an absolute size.
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -50, y = 0,  relative = true }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0,   y = 50, relative = true }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0,   y = -50, relative = true }))
-- Super+Ctrl+l also locks. Both binds stay, this one first. See SYSTEM CONTROLS.
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 50,  y = 0,  relative = true }))

-- === LAYOUT SWITCHING (native groups + dwindle) ===
hl.bind(mainMod .. " + S", hl.dsp.group.toggle())
hl.bind(mainMod .. " + E", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + W", hl.dsp.group.next())             -- forward through group tabs
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.group.prev())     -- backward through group tabs
hl.bind(mainMod .. " + A", hl.dsp.window.fullscreen({ mode = "maximized" })) -- bar stays visible
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- === APPLICATIONS ===
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd("lutris"))

-- === NOTIFICATIONS (SwayNC) ===
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -d -sw"))
-- Jump to the Claude Code session behind the newest notification (repeat for older ones)
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("~/.local/bin/claude-notify --jump"))

-- === SCRATCHPAD ===
hl.bind(mainMod .. " + minus", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- === SYSTEM CONTROLS ===
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.reload_config())
-- Second Super+Ctrl+l bind. The resize bind above still runs; this one locks.
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())

-- === SCREENSHOTS ===
-- Shift+s: region -> clipboard. Shift+x / Print: satty (Enter copies+saves+exits).
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy --type image/png]]))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd([[grim -t ppm -g "$(slurp)" - | satty -f -]]))
hl.bind("Print", hl.dsp.exec_cmd("grim -t ppm - | satty -f -"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprpicker -a"))

-- === WINDOW FOCUS ===
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- === WORKSPACE SWITCHING ===
-- Each key focuses that workspace. Pressing the key for the workspace
-- already focused returns to the previous one (binds.workspace_back_and_forth
-- above). Super+0 is workspace 10.
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- === MOVE WINDOW TO WORKSPACE ===
-- Shift+number moves the focused window and follows it. window.move ignores
-- workspace_back_and_forth, so the remembered workspace stays put.
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- === MOVE WINDOWS ===
-- group_aware moves into and out of groups (the old movewindoworgroup).
hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "left",  group_aware = true }))
hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "down",  group_aware = true }))
hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "up",    group_aware = true }))
hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "right", group_aware = true }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left",  group_aware = true }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down",  group_aware = true }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up",    group_aware = true }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right", group_aware = true }))

-- Resize mode. These are not repeating. j/down grows height, k/up shrinks it.
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("h",     hl.dsp.window.resize({ x = -10, y = 0,   relative = true }))
    hl.bind("j",     hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }))
    hl.bind("k",     hl.dsp.window.resize({ x = 0,   y = -10, relative = true }))
    hl.bind("l",     hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }))
    hl.bind("left",  hl.dsp.window.resize({ x = -10, y = 0,   relative = true }))
    hl.bind("down",  hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }))
    hl.bind("up",    hl.dsp.window.resize({ x = 0,   y = -10, relative = true }))
    hl.bind("right", hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }))
    hl.bind("Return", hl.dsp.submap("reset"))
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

-- See https://wiki.hypr.land/configuring/core/rules/
-- Rules are anonymous on purpose. Named rules run before anonymous ones,
-- which would change this order.

-- Terminals: used by clipboard.sh (Ctrl+Insert / Shift+Insert). Dynamic tag.
hl.window_rule({
    match = { class = "^(com\\.mitchellh\\.ghostty|Alacritty|kitty|foot|org\\.codeberg\\.dnkl\\.foot)$" },
    tag   = "+terminal",
})

-- Floating window rules - make specific apps always float and center
hl.window_rule({
    match  = { class = "^(pavucontrol)$" },
    float  = true,
    center = true,
    size   = "800 600",
})
hl.window_rule({
    match  = { class = "^(nm-connection-editor)$" },
    float  = true,
    center = true,
})
hl.window_rule({
    match  = { title = "^(File Operation Progress)$" },
    float  = true,
    center = true,
})
hl.window_rule({
    match  = { class = "^(xdg-desktop-portal-gtk)$" },
    float  = true,
    center = true,
})
hl.window_rule({
    match  = { class = "^(clipse-picker)$" },
    float  = true,
    center = true,
    size   = "1000 640",
})
hl.window_rule({
    match  = { class = "^(com\\.gabm\\.satty|org\\.satty\\.satty|satty)$" },
    float  = true,
    center = true,
})
hl.window_rule({
    match  = { class = "^(gnome-calculator)$" },
    float  = true,
    center = true,
    size   = "400 600",
})

-- Cheatsheet popup floats in center for readability
hl.window_rule({
    match  = { class = "^(HyprCheatsheet)$" },
    float  = true,
    center = true,
})

-- Calendar popup
hl.window_rule({
    match  = { class = "^(calendar-popup)$" },
    float  = true,
    center = true,
    size   = "650 250",
})

-- Ignore maximize requests from apps
hl.window_rule({
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
