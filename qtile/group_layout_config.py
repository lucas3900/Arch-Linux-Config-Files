from libqtile import layout 
from libqtile.config import Group, Key, Match
from libqtile.lazy import lazy

LAYOUT_PARAMS =  {
    "margin": 10,
    "border_width": 10,
    "single_border_width": 10,
    "border_focus": "#007fdf"
}
MOD = "mod4"

def get_layouts():
    return [
        layout.MonadTall(**LAYOUT_PARAMS),
        layout.Matrix(**LAYOUT_PARAMS),
        layout.Floating(),
        layout.VerticalTile(**LAYOUT_PARAMS),
    ]


def get_floating_rules():
    return layout.Floating(float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        Match(wm_class='confirm'),
        Match(wm_class='dialog'),
        Match(wm_class='download'),
        Match(wm_class='error'),
        Match(wm_class='file_process'),
        Match(wm_class='notification'),
        Match(wm_class='splash'),
        Match(wm_class='toolbar'),
        Match(wm_class='confirmreset'),
        Match(wm_class='makebranch'),
        Match(wm_class='maketag'),
        Match(wm_class='branchdialog'),
        Match(wm_class='pinentry'),
        Match(wm_class='ssh-askpass')
    ])


def go_to_group(group):
    def f(qtile):
        if group in "12345":
            qtile.focus_screen(0)
            qtile.groups_map[group].cmd_toscreen()
        else:
            qtile.focus_screen(1)
            qtile.groups_map[group].cmd_toscreen()

    return f


def get_groups_and_layouts(keys):
    layouts = get_layouts()
    group_nums = "1234567"
    groups = []
    for i in group_nums:
        if i in "12345":
            groups.append(Group(i, layout="monadtall"))
        else:
            groups.append(Group(i, layouts=layouts[-2:], layout="verticaltile"))

        keys.extend([
            Key([MOD], i,  lazy.function(go_to_group(i)),
                desc="Switch to group {}".format(i)),
            #Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            #    desc="Switch to & move focused window to group {}".format(i.name)),
            Key([MOD, "shift"], i, lazy.window.togroup(i),
                desc="move focused window to group {}".format(i)),
        ])

    return groups, layouts


def main():
    keys = []
    print(get_groups_and_layouts(keys))
    print(keys)


if __name__ == "__main__":
    main()