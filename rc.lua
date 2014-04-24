-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- Added by Jupelius, set the default value here
local mousefocus_enabled = true
-- Added by Jupelius: Different border for Konsole windows
local termcolor_focus = "#0080FF"
local termcolor_unfocus = "#0B243B"
-- Wallpaper
beautiful.wallpaper = "/home/jupelius/Wallpapers/planeetta.jpg"

local audio_channel = "Master"

function volume_up()
	os.execute("amixer sset " .. channel .. " 2%+")
end

function volume_down()
	os.execute("amixer sset " .. channel .. " 2%-")
end

function toggle_mute()
	os.execute("amixer sset " .. channel .. " toggle playback")
end

function ncmpcpp_next_song()
	os.execute("ncmpcpp next")
end

function ncmpcpp_toggle_pause()
	os.execute("ncmpcpp toggle")
end

function lock_session()
	awful.util.spawn("xlock -mode blank")
end

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
			title = "Oops, there were errors during startup!",
			text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true
		naughty.notify({ preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = err })
		in_error = false
	end)
end

beautiful.init("/usr/share/awesome/themes/default/theme.lua")
terminal = "konsole"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

local layouts =
{
    awful.layout.suit.tile.left,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.floating,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier
}

-- Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, false)
    end
end
-- Define a tag table which hold all screen tags.
-- Added by Jupelius: "Connect" certain tags
-- If you select a connected tag it will select the corresponding tag in other screens too
tags = {
	names_primary = { "www", "torrents", "coding", 4, 5, 6, 7, 8, "chess" },
	names_secondary = { "irc", "music", "coding", "skype", 5, 6, 7, 8, "chess" },
	names_default = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
	connected = { false, false, false, false, false, false, false, false, false },
}

for s = 1, screen.count() do
	if s == 1 then
	    tags[s] = awful.tag(tags.names_primary, s, layouts[1])
	elseif s == 2 then
	    tags[s] = awful.tag(tags.names_secondary, s, layouts[3])
	else
	    tags[s] = awful.tag(tags.names_default, s, layouts[1])
	end

	-- Set the default state of connected tags
	for i, tag in pairs(awful.tag.gettags(s)) do
		awful.tag.setproperty(tag, "connected", tags.connected[i])
	end
end

-- Create a laucher widget and a main menu
myawesomemenu = {
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{ "quit", awesome.quit }
}
-- Added by Jupelius
myownmenu = {
	{ "ZDaemon Launcher", "wine .wine/drive_c/ZDaemon/zlauncher.exe" },
	{ "SMplayer", "smplayer -size 800 400" },
	{ "KTorrent", "ktorrent" },
	{ "Firefox", "firefox" },
}

mymainmenu = awful.menu(
	{ items = {
		{ "Applications", myownmenu, beautiful.awesome_icon },
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "Open terminal", terminal },
		{ "File Browser", "thunar" },
	}
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
	menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- function textclock.new(format, timeout)
mytextclock = awful.widget.textclock(" %A %d.%m, %H:%M (Week %V) ", 30)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
	awful.button({ }, 1, awful.tag.viewonly),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end))

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			-- Without this, the following
			-- :isvisible() makes no sense
			c.minimized = false
			if not c:isvisible() then
				awful.tag.viewonly(c:tags()[1])
			end
			-- This will also un-minimize
			-- the client, if needed
			client.focus = c
			c:raise()
		end
	end),

	awful.button({ }, 3, function ()
		if instance then
			instance:hide()
			instance = nil
		else
			instance = awful.menu.clients({ width=250 })
		end
	end),

	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
		if client.focus then client.focus:raise() end
	end),

	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	end))

for s = 1, screen.count() do
	-- Create a promptbox for each screen
	mypromptbox[s] = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(awful.util.table.join(
		awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
		awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
		awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
		awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

	-- Create a taglist widget
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

	-- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

	-- Create the wibox
	mywibox[s] = awful.wibox({ position = "top", screen = s })

	-- Widgets that are aligned to the left
	local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(mylauncher)
	left_layout:add(mytaglist[s])
	left_layout:add(mypromptbox[s])

	-- Widgets that are aligned to the right
	local right_layout = wibox.layout.fixed.horizontal()

	if s == 1 then -- Widgets only visible on screen 1
	right_layout:add(wibox.widget.systray())
	end

	right_layout:add(mytextclock)
	right_layout:add(mylayoutbox[s])

	-- Now bring it all together (with the tasklist in the middle)
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(mytasklist[s])
	layout:set_right(right_layout)

	mywibox[s]:set_widget(layout)
end

-- Mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev) ))

-- Key bindings
globalkeys = awful.util.table.join(
	awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
	awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
	awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

	awful.key({ modkey,           }, "j",
		function ()
			awful.client.focus.byidx( 1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey,           }, "k",
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

	-- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
	awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
	awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
	awful.key({ modkey,           }, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end),

	-- Standard program
	awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),

	awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
	awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
	awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
	awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
	awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
	awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
	awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
	awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
	awful.key({ modkey, "Control" }, "n", awful.client.restore),

	-- Prompt
	awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

	awful.key({ modkey }, "x",
		function ()
			awful.prompt.run({ prompt = "Run Lua code: " },
			mypromptbox[mouse.screen].widget,
			awful.util.eval, nil,
			awful.util.getdir("cache") .. "/history_eval")
		end),
	-- Menubar
	awful.key({ modkey }, "p", function() menubar.show() end),

	-- Volume control
	awful.key({ }, "XF86AudioRaiseVolume", function () volume_up() end),
	awful.key({ }, "XF86AudioLowerVolume", function () volume_down() end),
	awful.key({ }, "XF86AudioMute", function () toggle_mute() end),
	-- Functions to control ncmpcpp
	awful.key({ modkey, "Control" }, "Right", function () ncmpcpp_next_song() end),
	awful.key({ modkey, "Control" }, "Left", function () ncmpcpp_toggle_pause() end),

	-- and mouse focus toggle
	awful.key({ modkey }, "s", function() mousefocus_enabled = not mousefocus_enabled end),
	-- Lock session
	awful.key({ modkey }, "F12", function () lock_session() end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
	awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
	awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
	awful.key({ modkey,           }, "n",
		function (c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
		end),
	awful.key({ modkey,           }, "m",
		function (c)
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical   = not c.maximized_vertical
		end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
	keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
for i = 1, keynumber do
	globalkeys = awful.util.table.join(globalkeys,
	awful.key({ modkey }, "#" .. i + 9,
		function ()
			local screen = mouse.screen
			if tags[screen][i] then
				awful.tag.viewonly(tags[screen][i])
			end
		end),
		awful.key({ modkey, "Mod1" }, "#" .. i + 9,
			function ()
				toggle_connection(tags[mouse.screen][i])
			end),
	awful.key({ modkey, "Control" }, "#" .. i + 9,
		function ()
			local screen = mouse.screen
			if tags[screen][i] then
				awful.tag.viewtoggle(tags[screen][i])
			end
		end),
	awful.key({ modkey, "Shift" }, "#" .. i + 9,
		function ()
		if client.focus and tags[client.focus.screen][i] then
			awful.client.movetotag(tags[client.focus.screen][i])
		end
		end),
	awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
		function ()
			if client.focus and tags[client.focus.screen][i] then
				awful.client.toggletag(tags[client.focus.screen][i])
			end
		end))
end

clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
		properties = { border_width = beautiful.border_width,
		border_color = beautiful.border_normal,
		focus = awful.client.focus.filter,
		keys = clientkeys,
		buttons = clientbuttons } },
	-- Konsole borders
	{ rule = { class = "konsole" },
		properties = { border_color = termcolor_unfocus } },
	-- Floating windows by class
	{ rule_any = { class = {
			"Smplayer",
			"Gimp",
			"Wine",
			"Ark",
			"Xfe",
			"Thunar",
			"Gnuplot",
			"Steam",
			"Gwenview" } },
		properties = { floating = true } },
	{ rule = { instance = "plugin-container" }, properties = { floating = true } },
	{ rule = { instance = "exe", class="Exe" }, properties = { floating = true } },
	-- Xfe's archive extract
	{ rule = { class = "Xfe", name = "Extract archive" },
		properties = { floating = true } },
	-- Firefox downloads
	{ rule = { class = "Firefox" }, except = { instance = "Navigator" },
		properties = { floating = true } },
	{ rule = { class = "hl_linux" },
		properties = { floating = true } }
}

-- Added by Jupelius: Option to enable/disable mousefocus
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
		if mousefocus_enabled then
			if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
				and awful.client.focus.filter(c) then
				client.focus = c
			end
		end
	end)

	if not startup then
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end

	local titlebars_enabled = false
	if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
		-- Widgets that are aligned to the left
		local left_layout = wibox.layout.fixed.horizontal()
		left_layout:add(awful.titlebar.widget.iconwidget(c))

		-- Widgets that are aligned to the right
		local right_layout = wibox.layout.fixed.horizontal()
		right_layout:add(awful.titlebar.widget.floatingbutton(c))
		right_layout:add(awful.titlebar.widget.maximizedbutton(c))
		right_layout:add(awful.titlebar.widget.stickybutton(c))
		right_layout:add(awful.titlebar.widget.ontopbutton(c))
		right_layout:add(awful.titlebar.widget.closebutton(c))

		-- The title goes in the middle
		local title = awful.titlebar.widget.titlewidget(c)
		title:buttons(awful.util.table.join(
			awful.button({ }, 1, function()
				client.focus = c
				c:raise()
				awful.mouse.client.move(c)
				end),
			awful.button({ }, 3, function()
				client.focus = c
				c:raise()
				awful.mouse.client.resize(c)
				end)
		))

		-- Now bring it all together
		local layout = wibox.layout.align.horizontal()
		layout:set_left(left_layout)
		layout:set_right(right_layout)
		layout:set_middle(title)
		awful.titlebar(c):set_widget(layout)
	end
end)

client.connect_signal("focus",
function(c)
	if c.class ~= "Konsole" then
		c.border_color = beautiful.border_focus
	else
		c.border_color = termcolor_focus
	end
end)

-- Modified by Jupelius: Don't remove borders from Konsole windows
client.connect_signal("unfocus",
function(c)
	if c.class ~= "Konsole" then
		c.border_color = beautiful.border_normal
	else
		c.border_color = termcolor_unfocus
	end
end)

-- Added by Jupelius: Handle "connected" tags
-- If you switch to a connected tag it switches to it in other screens too
tag.connect_signal("property::selected",
function(t)
	if awful.tag.getproperty(t, "connected") and t.selected then
		local tag_num = awful.tag.getidx(t)

		for s = 1, screen.count() do
			if s ~= awful.tag.getscreen(t) then
				local tags = awful.tag.gettags(s)
				if tags[tag_num] and not tags[tag_num].selected then
					awful.tag.viewmore({ tags[tag_num] }, s)
				end
			end
		end
	end
end)

-- Toggles the connection state of the given tag
function toggle_connection(tag)
	local tag_num = awful.tag.getidx(tag)
	local newstate = true

	if awful.tag.getproperty(tag, "connected") then
		newstate = false
	end

	for s = 1, screen.count() do
		local tags = awful.tag.gettags(s)
		awful.tag.setproperty(tags[tag_num], "connected", newstate)
	end

	local msg = ""
	if not newstate then
		msg = "dis"
	end

	naughty.notify({
		title = "Tag " .. tag_num,
		text = "Tag is now " .. msg .. "connected.",
		screen = awful.tag.getscreen(tag),
	})
end
