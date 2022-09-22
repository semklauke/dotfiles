#!/bin/bash
echo "--------[Starting Mail...]--------"
sudo systemctl start postfix;
sudo postfix start;
sudo systemctl start dovecot;
sudo systemctl start amavis;
tool postgrey-start;
sudo systemctl status postfix dovecot amavis postgrey;
echo "--------[Done]--------";