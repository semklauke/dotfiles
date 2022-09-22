#!/bin/bash
echo "--------[Stopping ts3 server]--------"
echo -ne "Enter password for teamspeak user...\n"
su teamspeak -c "~/teamspeak3-server_linux_amd64/ts3server_startscript.sh stop; ~/teamspeak3-server_linux_amd64/ts3server_startscript.sh status";
echo "--------[Done]--------";