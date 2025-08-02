#!/bin/bash


#email recipient list

#set x

To="omkar.kuratti@gmail.com"
Subject="Docker server alert"
current_date=$(date)

#Get Docker status

dockerStatus=$(systemctl is-active docker)
dockerVersion=$(docker -v | awk '{print $3}' | tr -d ",")

#Echo current status

echo "Current time is $current_date and docker status is: $dockerStatus"
echo "Current docker version is : $dockerVersion"

if [ "$dockerStatus" != "active" ]; then 
	echo -e "Docker is not running on $(hostname) at $current_date\nStatus: $dockerStatus\n Docker version : $dockerVersion" | mail -s "$Subject - docker is $dockerStatus" $To

	sleep 10 
	sudo systemctl restart docker
	new_status=$(systemctl is-active docker)
	new_date=$(date)

	if [ "$new_status" == "active" ]; then
		echo -e "Docker is restarted on $(hostname) at $new_date\nStatus : $new_status" | mail -s "$Subject - docker is restarted successfully..." $To
	else
		
		echo -e "Docker is restart on $(hostname) at $new_date\nStatus : $new_status" | mail -s "$Subject - docker restart is not successfully..." $To
	fi


fi
