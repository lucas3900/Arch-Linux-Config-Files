# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy
from libqtile import qtile

import os
import socket

import weather
from systemInfo import *


mod = "mod4"
terminal = 'alacritty'
browser = 'qutebrowser'

keys = [
    # Switch between windows in current stack pane
    Key([mod], "Right", lazy.layout.down(),
        desc="Move focus down in stack pane"),
    Key([mod], "Left", lazy.layout.up(),
        desc="Move focus up in stack pane"),

    # Move windows up or down in current stack
    Key([mod, "shift"], "Right", lazy.layout.shuffle_down(),
        desc="Move window down in current stack "),
    Key([mod, "shift"], "Left", lazy.layout.shuffle_up(),
        desc="Move window up in current stack "),

    # Increase and Decrease size of window
    Key([mod], "Up", lazy.layout.grow(), lazy.layout.increase_nmaster(),
        desc="Increase focused window"),
    Key([mod], "Down", lazy.layout.shrink(), lazy.layout.decrease_nmaster(),
        desc="Decrease focused window"),

    # Normalize layout
    Key([mod], "n", lazy.layout.normalize(),
        desc="normalize layout"),

    # Fullscreen focused window
    Key([mod], "m", lazy.window.toggle_fullscreen(),
        desc="toggle fullscreen"),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next(),
        desc="Switch window focus to other pane(s) of stack"),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate(),
        desc="Swap panes of split stack"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "f", lazy.spawn(browser), desc="Launch Browser"),
    Key([mod], "r", lazy.spawn("rofi -lines 1 -show run -columns 20 -width 100 -location 2"), desc="Launch rofi"),
    Key([mod], "p", lazy.spawn('bwmenu -- -lines 1 -show run -columns 20 -width 100 -location 2'), desc="Launch password"),
    Key([mod], "s", lazy.spawn("steam"), desc="Launch Steam"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "control"], "r", lazy.restart(), desc="Restart qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown qtile"),

    # Mute, Increase, and Decrease Volume
    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")), 
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -q set Master 5%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -q set Master 5%-")),
]

groups = [Group(i, layout="MonadTall") for i in "12345"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

layoutDefaults = {
    "margin": 6,
    "border_width": 5,
    "border_focus": "#007fdf"
}

layouts = [
    # layout.Max(),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Columns(),
    layout.MonadTall(**layoutDefaults),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
    layout.Floating(),
    layout.Matrix(**layoutDefaults)
]

colors = [["#282c34", "#282c34"], # panel background
          ["#434758", "#434758"], # background for current screen tab
          ["#ffffff", "#ffffff"], # font color for group names
          ["#ff5555", "#ff5555"], # border line color for current tab
          ["#8d62a9", "#8d62a9"], # border line color for other tab and odd widgets
          ["#668bd7", "#668bd7"], # color for the even widgets
          ["#e1acff", "#e1acff"], # window name
          ["#909090", "#909090"]] # inactive window

prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

def updatePackages():
    qtile.cmd_spawn(terminal + ' -e yay -Syu')


def launchCalendar():
    qtile.cmd_spawn(browser + ' --target=window google.com/calendar')


def getWeather():
    qtile.cmd_spawn(browser + " --target=window google.com/search?q=weather")


def launchBlueman():
    qtile.cmd_spawn('blueman-manager')


def launchHtop():
    qtile.cmd_spawn(terminal + " -e htop")


widget_defaults = dict(
    font = "Hack Nerd Font Mono"
)

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayoutIcon(
                    padding = 3,
                    foreground = colors[2],
                    background = colors[0]
                ),
                widget.GroupBox(
                    fontsize=18,
                    margin_y = 3,
                    margin_x = 0,
                    padding_y = 5,
                    padding_x = 3,
                    borderwidth = 3,
                    active = colors[6],
                    inactive = colors[7],
                    rounded = False,
                    highlight_color = colors[1],
                    highlight_method = "line",
                    this_current_screen_border = colors[3],
                    this_screen_border = colors [4],
                    other_current_screen_border = colors[0],
                    other_screen_border = colors[0],
                    foreground = colors[2],
                    background = colors[0]
                ),
                widget.Sep(
                    linewidth = 0,
                    padding = 15,
                    foreground = colors[2],
                    background = colors[0]
                ),
                widget.TaskList(
                    highlight_method='block',
                    max_title_width=200,
                    background = colors[0],
                    foreground = colors[6],
                    border = colors[1],
                    fontsize = 13,
                ),
                widget.Chord(
                    chords_colors={
                        'launch': ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                    background = colors[0]
                ),
                widget.GenPollText(
                    func=weather.getWeather, 
                    update_interval=900, 
                    fontsize=18, 
                    background = colors[4], 
                    padding=10, 
                    mouse_callbacks={'Button1': getWeather}
                ),
                widget.Image(
                    filename="~/.config/qtile/icons/bluetooth.png",
                    background=colors[5], 
                    mouse_callbacks={'Button1': launchBlueman}
                ),
                widget.GenPollText(
                    func=getNumBluetooth, 
                    update_interval=30, 
                    fontsize=18, 
                    background=colors[5], 
                    padding=0, 
                    mouse_callbacks={'Button1': launchBlueman}
                ),
                widget.Sep(
                    linewidth = 0, 
                    background=colors[5], 
                    padding=10, 
                    mouse_callbacks={'Button1': launchBlueman},
                ),
                widget.Sep(
                    linewidth = 0, 
                    background=colors[4], 
                    padding=10, 
                    mouse_callbacks={'Button1': updatePackages},
                ),
                widget.Image(
                    filename="~/.config/qtile/icons/pacman.png", 
                    background=colors[4], 
                    mouse_callbacks={'Button1': updatePackages}
                ),

                widget.GenPollText(
                    func=getNumUpdates, 
                    update_interval=300, 
                    fontsize=18, 
                    background=colors[4], 
                    padding=10, 
                    mouse_callbacks={'Button1': updatePackages}
                ),
                widget.Sep(
                    linewidth = 0, 
                    background=colors[5], 
                    padding=2
                ),
                widget.TextBox(
                    text="Vol:", 
                    fontsize=18, 
                    background = colors[5],
                ),
                widget.Volume(
                    fontsize=18, 
                    background = colors[5]
                ),
                widget.Sep(
                    linewidth = 0, 
                    background=colors[5], 
                    padding=7
                ),
                widget.ThermalSensor(
                    threshold=90, 
                    fontsize=18, 
                    background = colors[4], 
                    foreground = colors[2], 
                    padding=7
                ),
                widget.Sep(
                    foreground = colors[5],
                    background = colors[5],
                    linewidth = 7
                ),
                widget.TextBox(
                    text="RAM:",
                    fontsize=18,
                    padding=0,
                    foreground = colors[2],
                    background = colors[5],
                    mouse_callbacks={'Button1': launchHtop}
                ),
                widget.GenPollText(
                    func=getMemoryUsage,
                    update_interval=1,
                    foreground = colors[2],
                    background = colors[5],
                    fontsize=18,
                    mouse_callbacks={'Button1': launchHtop}
                ),
                widget.TextBox(
                    text="- SSD:",
                    fontsize=18,
                    foreground = colors[2],
                    background = colors[5],
                    padding = 0,
                    mouse_callbacks={'Button1': launchHtop}
                ),
                widget.GenPollText(
                    func=getFreeDiskSpace,
                    update_interval=60,
                    foreground = colors[2],
                    background = colors[5],
                    fontsize=18,
                    padding=7,
                    mouse_callbacks={'Button1': launchHtop}
                ),
                widget.Clock(
                    foreground = colors[2],
                    background = colors[4],
                    format = "%a, %b %d - %I:%M %p",
                    fontsize=18,
                    padding=7,
                    mouse_callbacks={'Button1': launchCalendar}
                ),
            ],
            35,
            opacity=.95,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"
# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
