from libqtile import bar, widget
from libqtile.config import Screen
from libqtile import qtile

import subprocess

import weather
# import stock_info

COLORS = dict(
    transparent = "#00000000",
    green = "#209900",
    blue = "#668bd7",
    purple = "#5E00A8",
    light_purple = "#B023FF",
    orange = "#E27600",
    gray = "#909090",
    white = "#ffffff",
    black = "#000000",
    light_green = "#00ff00",
    red = "#ff0000",
)
WIDGET_DEFAULTS = dict(
    font = "Hack Nerd Font Mono",
    fontsize = 20,
)
TERMINAL = 'kitty'
BROWSER = 'brave'
BASH_SCRIPT_DIR = '/home/lucas/Arch-Linux-Config-Files/bash_scripts'

def update_packages() -> None:
    qtile.cmd_spawn(TERMINAL + ' -e yay -Syu')


def launch_calendar() -> None:
    qtile.cmd_spawn(BROWSER + ' --target=window google.com/calendar')


def launch_htop() -> None:
    qtile.cmd_spawn(TERMINAL + " -e htop")


def launch_weather() -> None:
    qtile.cmd_spawn(BROWSER + " --target=window google.com/search?q=weather")


def get_num_updates() -> str:
    updates = subprocess.check_output(f"{BASH_SCRIPT_DIR}/check-all-updates.sh")
    return updates.decode("utf-8").strip()


def get_free_disk_space() -> str:
    space = subprocess.check_output(f"{BASH_SCRIPT_DIR}/get-free-disk-space.sh")
    return space.decode("utf-8").strip()


def get_free_memory() -> str:
    memory = subprocess.check_output(f"{BASH_SCRIPT_DIR}/get-free-memory.sh")
    return memory.decode("utf-8").strip()


def get_left_semicircle(color):
    return widget.TextBox(
        text="\ue0b6",
        foreground=COLORS[color],
        background=COLORS["transparent"],
        padding=0,
        fontsize=50
    )


def get_right_semicircle(color):
    return widget.TextBox(
        text="\ue0b4",
        foreground=COLORS[color],
        background=COLORS["transparent"],
        padding=0,
        fontsize=50
    )


def get_widget_sep(padding=40, background="transparent", mouse_callbacks={}):
    return widget.Sep(
        linewidth = 0, 
        background=COLORS[background],
        padding=padding, 
        mouse_callbacks=mouse_callbacks,
    )


def get_xkill():
    return [ 
        widget.TextBox(
            text="X",
            fontsize=50,
            foreground=COLORS["red"],
            background=COLORS["transparent"],
            mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(TERMINAL + " --start-as=minimized xkill")}
        ), 
    ]


def get_group_box(visible_groups=[]):
    return [
        get_left_semicircle("purple"),
        widget.CurrentLayoutIcon(
            padding = 3,
            foreground = COLORS["white"],
            background = COLORS["purple"]
        ),
        get_widget_sep(padding=30, background="purple"),
        widget.GroupBox(
            **WIDGET_DEFAULTS,
            visible_groups = visible_groups,
            margin_y = 3,
            margin_x = 0,
            padding_y = 5,
            padding_x = 3,
            borderwidth = 3,
            active = COLORS["white"],
            inactive = COLORS["gray"],
            this_current_screen_border = COLORS["light_green"],
            this_screen_border = COLORS["red"],
            highlight_color = COLORS["light_purple"],
            rounded = True,
            highlight_method = "line",
            foreground = COLORS["white"],
            background = COLORS["purple"]
        ),
        get_widget_sep(padding=30, background="purple"),
        widget.CurrentScreen(
            **WIDGET_DEFAULTS,
            background = COLORS["purple"]
        ),
        get_right_semicircle("purple")
    ]


def get_updates():
    return [
        get_left_semicircle("blue"),
        get_widget_sep(padding=10, background="blue", mouse_callbacks={'Button1': update_packages}),
        widget.Image(
            **WIDGET_DEFAULTS,
            filename="~/.config/qtile/icons/pacman.png", 
            background=COLORS["blue"],
            mouse_callbacks={'Button1': update_packages}
        ),
        widget.GenPollText(
            **WIDGET_DEFAULTS,
            func=get_num_updates, 
            update_interval=300, 
            background=COLORS["blue"],
            padding=10, 
            mouse_callbacks={'Button1': update_packages}
        ),
        get_right_semicircle("blue")
    ]


def get_net():
    return [
        get_left_semicircle("orange"),
        widget.Net(
            **WIDGET_DEFAULTS,
            background = COLORS["orange"],
            foreground = COLORS["white"], 
            update_interval=10,
            format="{down:0.2f}{down_suffix} ↓↑ {up:0.2f}{up_suffix}",
            interface="enp2s0"
        ),
        get_right_semicircle("orange"),
    ]


def get_clock():
    return [
        get_left_semicircle("green"),
        widget.Clock( ** WIDGET_DEFAULTS,
            foreground = COLORS["white"],
            background=COLORS["green"],
            #background = colors[4],
            format = "%a, %b %d - %I:%M %p",
            padding=7,
            mouse_callbacks={'Button1': launch_calendar}
        ),
        get_right_semicircle("green")
    ]


def get_system_temp():
    return [
        get_left_semicircle("orange"),
        widget.ThermalSensor(
            **WIDGET_DEFAULTS,
            threshold=90, 
            background = COLORS["orange"],
            foreground = COLORS["white"], 
            padding=7
        ),
        get_right_semicircle("orange"),
    ]


def get_system_graphs():
    return [
        get_left_semicircle("blue"),
        widget.TextBox(
            **WIDGET_DEFAULTS,
            text="CPU: ",
            foreground=COLORS["white"],
            background=COLORS["blue"],
        ), 
        widget.CPUGraph(
            background=COLORS["blue"],
            graph_color=COLORS["white"],
            fill_color=COLORS["white"],
            border_color=COLORS["black"]

        ),
        widget.TextBox(
            **WIDGET_DEFAULTS,
            text=" RAM: ",
            foreground=COLORS["white"],
            background=COLORS["blue"],
        ), 
        widget.MemoryGraph(
            background=COLORS["blue"],
            graph_color=COLORS["white"],
            fill_color=COLORS["white"],
            border_color=COLORS["black"]
        ),
        get_right_semicircle("blue")
    ]


def get_system_info():
    return [
        get_left_semicircle("purple"),
        widget.TextBox(
            ** WIDGET_DEFAULTS,
            text="RAM:",
            padding=0,
            foreground = COLORS["white"],
            background = COLORS["purple"],
            mouse_callbacks={'Button1': launch_htop}
        ),
        widget.GenPollText(
            ** WIDGET_DEFAULTS,
            func=get_free_memory,
            update_interval=3,
            foreground = COLORS["white"],
            background = COLORS["purple"],
            mouse_callbacks={'Button1': launch_htop}
        ),
        widget.TextBox(
            ** WIDGET_DEFAULTS,
            text=" - SSD:",
            foreground = COLORS["white"],
            background = COLORS["purple"],
            padding = 0,
            mouse_callbacks={'Button1': launch_htop}
        ),
        widget.GenPollText(
            ** WIDGET_DEFAULTS,
            func=get_free_disk_space,
            update_interval=60*5,
            foreground = COLORS["white"],
            background = COLORS["purple"],
            padding=7,
            mouse_callbacks={'Button1': launch_htop}
        ),
        get_right_semicircle("purple"),
    ]


def get_systray():
    return [
        widget.Systray(
            icon_size = 50,
            background=COLORS["transparent"]
        ),
    ]


def get_screen_one():
    return Screen(
        top=bar.Bar(
            [ 
                *get_xkill(),
                get_widget_sep(),
                *get_group_box(visible_groups=["1", "2", "3", "4", "5"]),
                get_widget_sep(),
                *get_updates(),
                get_widget_sep(),
                #*get_net(),
                *get_weather(),
                widget.Spacer(),
                *get_clock(),
                widget.Spacer(),
                # *get_system_temp(),
                get_widget_sep(),
                *get_system_graphs(),
                get_widget_sep(),
                *get_system_info(),
                get_widget_sep(),
                *get_systray()
            ],
            55,
            opacity=1,
            margin=[10,15,4,15],
            background=COLORS["transparent"]
        ),
    )


def get_weather():
    return [
        get_left_semicircle("orange"),
        widget.GenPollText(
            **WIDGET_DEFAULTS,
            func=weather.getWeather, 
            update_interval=900, 
            background = COLORS["orange"],
            padding=10, 
            mouse_callbacks={'Button1': launch_weather}
        ),
        get_right_semicircle("orange")
    ]


def get_stock_info():
    return [
        get_left_semicircle("orange"),
        widget.GenPollText(
            **WIDGET_DEFAULTS,
            func=stock_info.get_random_stock_price,
            update_interval=30,
            padding=7,
            mouse_callbacks={},
            background=COLORS["orange"]
        ),
        get_right_semicircle("orange")
    ]


def get_screen_two():
    return Screen(
        top=bar.Bar(
            [ 
                *get_xkill(),
                get_widget_sep(),
                *get_group_box(visible_groups=["6", "7"]),
                widget.Spacer(),
                *get_clock(),
                widget.Spacer(),
                *get_net(),
                #*get_stock_info(),
            ], 
            60, 
            opacity=1,
            margin=[10,10,4,10], 
            background=COLORS["transparent"]
        ),
    )


def get_screens():
    return [get_screen_one(), get_screen_two()]


def main():
    print(get_screens())


if __name__ == "__main__":
    main()
