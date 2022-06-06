#!/bin/sh 
total_space=$(free | grep -iF mem | awk '{print $2}')
used_space=$(free | grep -iF mem | awk '{print $3}')
decimal=$(echo "scale=2 ; $used_space / $total_space" | bc)
percent=$(echo "$decimal * 100" | bc)
int=$(echo "$percent/1" | bc)
echo $int%
