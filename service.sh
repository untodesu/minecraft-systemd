#!/bin/bash

MINECRAFT_EXEC="java -server -Xms$MINECRAFT_XMS -Xmx$MINECRAFT_XMX -jar /srv/minecraft/$1/server.jar nogui"
MINECRAFT_TERM="minecraft-$1"

if [[ "$2" == "start" ]]
then
    /usr/bin/screen -DmS "$MINECRAFT_TERM" $MINECRAFT_EXEC
    exit 0
fi

if [[ "$2" == "reload" ]]
then
    /usr/bin/screen -p 0 -S "$MINECRAFT_TERM" -X stuff "reload\\015"
    exit 0
fi

if [[ "$2" == "stop" ]]
then
    /usr/bin/screen -p 0 -S "$MINECRAFT_TERM" -X stuff "say Server shutdown in 30 seconds.\\015"
    /bin/sleep 20
    /usr/bin/screen -p 0 -S "$MINECRAFT_TERM" -X stuff "say Server shutdown in 10 seconds.\\015"
    /usr/bin/screen -p 0 -S "$MINECRAFT_TERM" -X stuff "save-all\\015"
    /bin/sleep 5
    /usr/bin/screen -p 0 -S "$MINECRAFT_TERM" -X stuff "say Server shutdown in  5 seconds.\\015"
    /bin/sleep 5
    /usr/bin/screen -p 0 -S "$MINECRAFT_TERM" -X stuff "stop\\015"
    exit 0
fi

echo "$0: Invalid operand $2"
exit 1
