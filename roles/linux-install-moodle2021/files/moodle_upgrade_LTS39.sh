#!/bin/bash

# Enable maintence mode
/usr/bin/php /var/www/html/admin/cli/maintenance.php --enable 

# ----------------------------- BACKUPa egin /moodle_upgrade/moodle_upgrade barruan

now=$(date +%Y%m%d%H)

backupfolder="/moodlebackup/moodle_upgrade/$now-backup"
mkdir -p $backupfolder
file="$backupfolder/$now-moodle.sql"

# DB Backup
mysqldump -umoodleuser -p-pMOODLEDBPASSWORD --opt moodledb > "$file"

# Moodle folder backup
moodledata_backupfolder="$backupfolder/$now-moodledata"
mkdir $moodledata_backupfolder

# Copy moodledata files
#cp -rp /var/moodledata/* $moodledata_backupfolder
rsync --stats -avz  --times --perms --links --delete  /var/moodledata/ $moodledata_backupfolder

# Copy html folder
cp -rp /var/www/html $backupfolder

# ----------------------------  Orain /opt barruan dugun azken bertsioa eguneratu GIT bidez

cd /opt/moodle
git branch --track MOODLE_37_STABLE origin/MOODLE_39_STABLE
git checkout MOODLE_39_STABLE
git pull

# config.php kopiatu. Plantillak edo pertsonalizatutako gauzarik bagenu, hau da kopiatzeko unea
cp /var/www/html/config.php /var/www/

mv /var/www/html/mod/hvp /var/www/  # h5p plugina
mv /var/www/html/mod/bigbluebuttonbn /var/www/  #bbb plugina
mv /var/www/html/theme/adaptable /var/www/ #adaptable plugina
mv /var/www/html/course/format/buttons /var/www # format_buttons plugina

# bertsio zaharra ezabatu
rm -rf /var/www/html/*

# git bidez deskargatu duguna html karpetan jarri
cp -pa /opt/moodle/* /var/www/html/

# aurrez kopiatu degun config.php bere lekuan jarri
cp /var/www/config.php /var/www/html/
mv /var/www/hvp /var/www/html/mod/hvp  # h5p plugina
mv /var/www/bigbluebuttonbn /var/www/html/mod/bigbluebuttonbn  #bbb plugina
mv /var/www/adaptable /var/www/html/theme/adaptable  #adaptable plugina
mv /var/www/buttons /var/www/html/course/format/buttons # format_buttons plugina



# upgrade-a martxan jarri interactive moduan, eskuz eginda arazoren bat gertatuko balitz ikusi ahal izateko
# /usr/bin/php /var/www/html/admin/cli/upgrade.php --non-interactive
/usr/bin/php /var/www/html/admin/cli/upgrade.php

# Maintence egoeratik atera
/usr/bin/php /var/www/html/admin/cli/maintenance.php --disable

/etc/init.d/apache2 restart
