#!/bin/bash

cd /opt/
#git clone git://git.moodle.org/moodle.git
git clone https://github.com/moodle/moodle.git
cd moodle
# git branch -a
git branch --track MOODLE_39_STABLE origin/MOODLE_39_STABLE
git checkout MOODLE_39_STABLE
cd /var/www/html/
cp -pa /opt/moodle/* .
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
mkdir -p /var/moodledata
chown -R www-data:www-data /var/moodledata
chmod -R 770 /var/moodledata

cd /var/www/html

/usr/bin/php admin/cli/install.php --lang=en --wwwroot= {{ wwwroot }} --dataroot=/var/moodledata --dbtype=mariadb --dbname=moodledb --dbuser=moodleuser --dbpass= {{ dbpass }} --fullname= {{ fullname }} --shortname= {{ shortname }} --adminuser= {{ adminuser }}  --adminpass= {{ adminpass }} --adminemail= {{ adminemail }}  --non-interactive --agree-license
