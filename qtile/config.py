import os
import socket

import screen_config
import key_config
import group_layout_config


# import stuff
screens = screen_config.get_screens()
keys = key_config.get_keys()
mouse = key_config.get_mouse()
groups, layouts = group_layout_config.get_groups_and_layouts(keys)
layouts = group_layout_config.get_layouts()
floating_layout = group_layout_config.get_floating_rules()

# misc configuration
prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
auto_fullscreen = True
focus_on_window_activation = "smart"
dgroups_key_binder = None
dgroups_app_rules = []  
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
wmname = "LG3D"