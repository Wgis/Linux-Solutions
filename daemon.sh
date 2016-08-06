#!/bin/bash
# Restart script
SCREEN_NAME="ttg"
count=1
 
while [ $count ]
do
 
# If no screen under that name was found...
if [[ `screen -ls | grep $SCREEN_NAME` == "" ]]
  then
  # Nothing was found running ; restart the server.
  cd /home/steam/gmod_5/ ; screen -A -d -m -S $SCREEN_NAME ./srcds_run -game garrysmod +maxplayers 6 +map ttg_canyon_a1  +gamemode tacticaltoolgame -port 27015 -autoupdate
fi
 
done
