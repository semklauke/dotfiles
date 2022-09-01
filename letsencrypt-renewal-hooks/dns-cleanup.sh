#!/bin/bash

### SETTINGS ### 
#!!! INSERT ZONE FILE LOCATION AND TMP LOCATION !!! 
ZONE_FILE=/etc/bind/...
TMP_ZONE_FILE=/etc/bind/...
ZONE_FILE_DATE=$(date +%Y%m%d)
NEWNUMBER="52"
NEWREF="$ZONE_FILE_DATE$NEWNUMBER"

cp ${ZONE_FILE} ${TMP_ZONE_FILE}
sed '$ d' ${TMP_ZONE_FILE} > ${ZONE_FILE}
rm -f ${TMP_ZONE_FILE}
exp1="s/20[[:digit:]][[:digit:]]\{7\}/$NEWREF/";

echo $exp1 | sed -f - $ZONE_FILE >$ZONE_FILE.tmp;
exp2=`sed -n -e 's/$ORIGIN[[:space:]]//p' $ZONE_FILE`
mv $ZONE_FILE.tmp $ZONE_FILE;
echo -e "zonefile cleanup done \n";

sudo named-checkconf;
sudo systemctl reload bind9;
systemctl status bind9;

### RELOAD ALL SERVICES THAT USE CERTIFICATES HERE ###
sudo nginx -s reload;
sudo dovecot reload;

echo -e "dns auth cleanup done \n";