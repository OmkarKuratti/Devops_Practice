#!/bin/bash


#Gathering Info

To=omkar.kuratti@gmail.com
Load=$(uptime | awk '{print $8}' | tr -d ',')


if [ $Load -gt 0.6 ]; then
	echo -e "This server $(hostname) is running over the thershould mark" | mail -s "High load alert" $To
else
	echo -e "This server $(hostname) is running normal" | mail -s "Server functioning normal" $To
fi
