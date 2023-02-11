from libqtile.config import Click, Drag, Key
from libqtile.lazy import lazy

MOD = "mod4"
TERMINAL = 'kitty'
BROWSER = 'brave'

def get_movement_keys():
    return [
        Key([MOD], "j", lazy.layout.down(), desc="Move focus down in stack pane"),
        Key([MOD], "k", lazy.layout.up(), desc="Move focus up in stack pane"),
    ]


def get_window_keys():
    return [ 
        Key([MOD, "shift"], "j", lazy.layout.shuffle_down(),
            desc="Move window down in current stack "),
        Key([MOD, "shift"], "k", lazy.layout.shuffle_up(),
            desc="Move window up in current stack "),
        Key([MOD], "l", lazy.layout.grow(), desc="Increase focused window"),
        Key([MOD], "h", lazy.layout.shrink(), desc="Decrease focused window"),
        Key([MOD], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
        Key([MOD], "q", lazy.window.kill(), desc="Kill focused window"),
        Key([MOD], 'm', lazy.layout.maximize()),
        Key([MOD], "f", lazy.window.toggle_fullscreen(), desc="toggle fullscreen"),
        Key([MOD, "shift"], "f", lazy.window.toggle_floating(), desc="toggle fullscreen"),
    ]


def get_application_keys():
    return [
        Key([MOD], "Return", lazy.spawn(TERMINAL), desc="Launch terminal"),
        Key([MOD], "w", lazy.spawn(BROWSER), desc="Launch Browser"),
        # Key([MOD], "c", lazy.spawn("code"), desc="Launch VS-Code"),
        Key([MOD], "e", lazy.spawn("emacsclient -a '' -c"), desc="Launch emacs"),
        Key([MOD], "x", lazy.spawn("sh /home/lucas/Arch-Linux-Config-Files/bash_scripts/rofi-power-menu.sh"), desc="Lock Screen"),
        Key([MOD], "r", lazy.spawn("rofi -lines 2 -show run -show-icons -columns 4 -width 50 -location 0 -opacity 75"), desc="Launch rofi"),
        Key([MOD], "p", lazy.spawn('bwmenu -- -lines 1 -show run -columns 20 -width 100 -location 2'), desc="Launch password"),
        Key([MOD], "s", lazy.spawn("steam"), desc="Launch Steam"),
    ]


def get_system_keys():
    return [
        Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")), 
        Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -q set Master 5%+")),
        Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -q set Master 5%-")),
        Key([MOD, "control"], "r", lazy.restart(), desc="Restart qtile"),
        Key([MOD, "control"], "q", lazy.shutdown(), desc="Shutdown qtile"),
        Key([MOD], "n", lazy.layout.normalize(), desc="normalize layout"),
    ]


def get_keys():
    return [
        *get_movement_keys(),
        *get_window_keys(),
        *get_application_keys(),
        *get_system_keys()
    ]


def get_mouse():
    return [
        Drag([MOD], "Button1", lazy.window.set_position_floating(),
            start=lazy.window.get_position()),
        Drag([MOD], "Button3", lazy.window.set_size_floating(),
            start=lazy.window.get_size()),
        Click([MOD], "Button2", lazy.window.bring_to_front())
    ]


def main():
    print(get_keys())


if __name__ == "__main__":
    main()
