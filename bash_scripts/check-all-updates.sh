#!/bin/sh

AUR_WRAPPER=paru

if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
    updates_arch=0
fi

if ! updates_aur=$($AUR_WRAPPER -Qum 2> /dev/null | wc -l ); then
    updates_aur=0
fi

updates_all=$((updates_aur + updates_arch))
if [ $updates_all -gt 0 ]; then
    echo $updates_all
else
    echo "0"
fi
