#!/bin/sh

echo "Server Backup $(date)" >> /var/log/server-backup.txt
cp -r /home/lucas/server/mount/* /home/lucas/server/backup/
