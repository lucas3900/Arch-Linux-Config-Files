#!/bin/sh

if ! updates_aur=$(yay -Qum 2> /dev/null | wc -l ); then
    updates_aur=0
fi

if [ $updates_aur -gt 0 ]; then
    echo $updates_aur
else
    echo "0"
fi
