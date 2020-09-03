#!/bin/bash

# Hemen gero sartuko dira ikastaro bakoitzeko backupak
mkdir -p /moodlebackup/coursebackup
chown -Rf www-data.www-data /moodlebackup/coursebackup


mkdir -p /moodlebackup/moodle_backup
mkdir -p /moodlebackup/moodle_backup/moodle_data
mkdir -p /moodlebackup/moodle_backup/html

# Enable maintence mode
/usr/bin/php /var/www/html/admin/cli/maintenance.php --enable 

# DB Backup
mysqldump -umoodleuser -pMOODLEDBPASSWORD --opt moodledb > /moodlebackup/moodle_backup/moodle_backup.sql

# RSYNC Moodle folder
rsync --stats -avz  --times --perms --links --delete  /var/moodledata/ /moodlebackup/moodle_backup/moodle_data/

# RSYNC html folder
rsync --stats -avz  --times --perms --links --delete  /var/www/html/ /moodlebackup/moodle_backup/html/

# Maintence egoeratik atera
/usr/bin/php /var/www/html/admin/cli/maintenance.php --disable

# bzip2 the sql dump
rm -f /moodlebackup/moodle_backup/moodle_backup.sql.bz2
cd /moodlebackup/moodle_backup/
bzip2 /moodlebackup/moodle_backup/moodle_backup.sql
