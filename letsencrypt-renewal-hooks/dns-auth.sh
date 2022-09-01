#!/bin/bash

# We add the dns auth to the bind zone file

### SETTINGS ### 
#!!! INSERT ZONE FILE LOCATION AND BACKUP LOCATION !!! 
ZONE_FILE=/etc/bind/...
BACKUP_ZONE_FILE=/etc/bind/...

RECORD=";\n_acme-challenge.${CERTBOT_DOMAIN}.  12h IN  TXT     \"${CERTBOT_VALIDATION}\""
ZONE_FILE_DATE=$(date +%Y%m%d)
NEWNUMBER="51"
NEWREF="$ZONE_FILE_DATE$NEWNUMBER"

rm -f ${BACKUP_ZONE_FILE}
cp ${ZONE_FILE} ${BACKUP_ZONE_FILE};
echo -e ${RECORD} >> ${ZONE_FILE};

exp1="s/20[[:digit:]][[:digit:]]\{7\}/$NEWREF/";

echo $exp1 | sed -f - $ZONE_FILE >$ZONE_FILE.tmp;
exp2=`sed -n -e 's/$ORIGIN[[:space:]]//p' $ZONE_FILE`
mv $ZONE_FILE.tmp $ZONE_FILE;

echo -e "zonefile setup done \n";

sudo systemctl reload bind9;
systemctl status bind9;

echo -e "dns auth setup done \n";
echo -e "sleeping for 120 now... \n";
sleep 20;
echo -e "Sleeping done!!!1\n";