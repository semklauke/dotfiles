#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
UPLINE=$(tput cuu1)
ERASELINE=$(tput el)

echo -e "[NETWORK]: testing...";
sleep 1;
while true; do
	p=$(ping -c 1 1.1.1.1);
	if [[ $p == *"64 bytes from 1.1.1.1"* ]]; then
		echo -n "$UPLINE$ERASELINE";
		echo -e "[NETWORK]: Connected";
	else
		echo -n "$UPLINE$ERASELINE";
		echo -e "[NETWORK]: ${RED}Down${NC}";
	fi
	sleep 2;

done