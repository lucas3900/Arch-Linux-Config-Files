#!/bin/sh

AUR_WRAPPER=paru

if ! updates_aur=$($AUR_WRAPPER -Qum 2> /dev/null | wc -l ); then
    updates_aur=0
fi

if [ $updates_aur -gt 0 ]; then
    echo $updates_aur
else
    echo "0"
fi
