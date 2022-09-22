#!/bin/bash
echo "--------[Starting ts3 server]--------"
#sudo rm -rf /home/teamspeak/server_linux_amd64/ts3server.pid;
echo -ne "Enter password for teamspeak user...\n"
su teamspeak -c "~/teamspeak3-server_linux_amd64/ts3server_startscript.sh start inifile=ts3server.ini; ~/teamspeak3-server_linux_amd64/ts3server_startscript.sh status; netstat -lnp | grep ts3";
echo "--------[Done]--------";