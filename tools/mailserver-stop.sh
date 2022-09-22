#!/bin/bash
echo "--------[Stopping Mail...]--------"
sudo systemctl stop postfix;
sudo postfix stop;
sudo systemctl stop dovecot;
sudo systemctl stop amavis;
tool postgrey-stop;
sudo systemctl status postfix dovecot amavis postgrey;
echo "--------[Done]--------";