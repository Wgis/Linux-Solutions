#!/bin/bash
USER="wgis"
SCREEN_NAME="gmod"
DIR_ROOT="gmod"
DAEMON_GAME="srcds_run"
PARAM_START="-console -game garrysmod +map gm_construct +gamemode sandbox +port 27015 +maxplayers 20 -autoupdate"

function start {
  if [ ! -d $DIR_ROOT ]; then echo "ERROR: $DIR_ROOT is not a directory"; exit 1; fi
  if [ ! -x $DIR_ROOT/$DAEMON_GAME ]; then echo "ERROR: $DIR_ROOT/$DAEMON_GAME does not exist or is not executable"; exit 1; fi
  if status; then echo "$SCREEN_NAME is already running"; exit 1; fi
 
  # Start game
  PARAM_START="${PARAM_START}"
  echo "Start command : $PARAM_START"
  
  if [ `whoami` = root ]
  then
    su - $USER -c "cd $DIR_ROOT ; screen -AmdS $SCREEN_NAME ./$DAEMON_GAME $PARAM_START"
  else
    cd $DIR_ROOT
    screen -AmdS $SCREEN_NAME ./$DAEMON_GAME $PARAM_START
  fi
}

function stop {
  if ! status; then echo "$SCREEN_NAME could not be found. Probably not running."; exit 1; fi

  if [ `whoami` = root ]
  then
    tmp=$(su - $USER -c "screen -ls" | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}')
    su - $USER -c "screen -r $tmp -X quit"
  else
    screen -r $(screen -ls | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}') -X quit
  fi
}

function console {
  if ! status; then echo "$SCREEN_NAME could not be found. Probably not running."; exit 1; fi

  if [ `whoami` = root ]
  then
    tmp=$(su - $USER -c "screen -ls" | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}')
    su - $USER -c "screen -r $tmp"
  else
    screen -r $(screen -ls | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}')
  fi
}
function status {
  if [ `whoami` = root ]
  then
    su - $USER -c "screen -ls" | grep [.]$SCREEN_NAME[[:space:]] > /dev/null
  else
    screen -ls | grep [.]$SCREEN_NAME[[:space:]] > /dev/null
  fi
}
case $1 in
	start)
		echo "Starting $SCREEN_NAME..."
		start
		sleep 5
		echo "$SCREEN_NAME started successfully"
		;;
     stop)
          echo "Эй! Это мой любимый серверный дистрибутив!"
          ;;
	  restart)
		echo "Restarting $SCREEN_NAME..."
		status && stop
		sleep 5
		start
		sleep 5
		echo "$SCREEN_NAME restarted successfully"
	  ;;
     console)
		echo "Open $SCREEN_NAME"
		console
		;;
     status)
          echo "Запрос статуса:"
		  if status
			then echo "$SCREEN_NAME - [ON] Line "
			ps aux | awk '{s += $3} END {print "Нагрузка: " s "%"}'
			else echo "Screen: $SCREEN_NAME - [OFF] Line"
			fi
          ;; 
     *)
       echo '$SCREEN_NAME (start|stop|restart|status|console)'
      exit 1

     ;;

esac

exit 0