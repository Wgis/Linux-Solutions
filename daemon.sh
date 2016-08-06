#!/bin/bash
# Restart script
SCREEN_NAME="gmod"
count=1
 
while [ $count ]
do
 
# If no screen under that name was found...
if [[ `screen -ls | grep $SCREEN_NAME` == "" ]]
 then
 # Nothing was found running ; restart the server.
	./start.sh start
	else ./start.sh status
fi
 
done
