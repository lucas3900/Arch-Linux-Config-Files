#!/bin/bash
IDENTIFIER="ASUSTeK ROG FALCHION Consumer Control"

LINE=$(xinput list | grep "$IDENTIFIER")
ID=$(echo ${LINE#*id=} | tr '\t' ' ' | cut -d ' ' -f1)

if [ -n "$ID" ]; then
    xinput disable $ID
    echo "Disabled xinput ID $ID ($IDENTIFIER)"
else
    echo "No xinput ID for '$IDENTIFIER' found."
fi
