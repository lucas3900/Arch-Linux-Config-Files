# Autostart X on login and auto mount
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  # sshfs storage@192.168.1.139:/home/storage/documents /home/lucas/server/mount
  exec startx
fi
