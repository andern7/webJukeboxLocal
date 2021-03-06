#!/bin/bash
apt-get update
apt-get -y upgrade

ssh-keygen -t rsa

addgroup --system www-data
adduser www-data www-data

apt-get -y install lighttpd mysql-server php5-cgi php5-mysql php5-cli git

usermod -a -G www-data www-data
usermod -a -G www-data pi
chown -R www-data:www-data /var/www
chgrp -R www-data /var/www
chmod -R g+w /var/www

find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod ug+rw {} \;

cd /var/www #I don't know if this is how i do it or not

wget https://packages.zendframework.com/releases/ZendFramework-1.12.3/ZendFramework-1.12.3.zip
wget https://github.com/JamesHeinrich/getID3/archive/1.9.7.zip
wget https://github.com/twbs/bootstrap/releases/download/v3.1.1/bootstrap-3.1.1-dist.zip
wget http://ajax.aspnetcdn.com/ajax/jQuery/jquery-2.1.0.min.js

unzip ZendFramework-1.12.3.zip
unzip getID3-1.9.7.zip
unzip bootstrap-3.1.1-dist.zip

mysql -u root -p

#might get an ssh type error, consider making this a fork or something
git clone git@github.com:badcab/webJukeboxLocal.git

sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' /etc/php5/cgi/php.ini
echo 'server.modules += ("mod_cgi")' >> /etc/lighttpd/conf-enabled/10-cgi-php.conf
echo ' cgi.assign = (".php" => "/usr/bin/php5-cgi")' >> /etc/lighttpd/conf-enabled/10-cgi-php.conf

/etc/init.d/lighttpd force-reload

#run the sql file in /var/www/webJukeboxLocal/db_setup.sql

chown -R www-data:www-data /var/www

