#!/bin/sh 
main_drive="nvme0n1p2"
row=$(df -h | grep /dev/$main_drive)
echo $row | awk '{print $5}' 
