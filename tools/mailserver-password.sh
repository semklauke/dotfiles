#!/bin/bash
if [ "$#" -eq 1 ]; then
	echo $(doveadm pw -s SHA512-CRYPT -p ${1});
else
	echo "ERROR: tool mailserver-password <password-to-hash>\n"
fi
