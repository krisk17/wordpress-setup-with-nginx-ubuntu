#!/bin/bash
php -version > /dev/null # check php installed or not; if not next step to install it.
if [ $? != 0 ] 
then
	sudo apt-get install -y php php-cgi
fi
mysql -V > /dev/null # check mysql server installed or not; if not next step to install it.
if [ $? != 0 ] 
then
	sudo apt-get install -y mysql-server mysql-client
	sudo service mysql start
fi 
nginx -V 2> /dev/null # check nginx installed or not; if not next step to install it.
if [ $? != 0 ] 
then
	sudo apt-get install -y nginx
	sudo service nginx start 
fi 
echo "Please enter a domain name:"
read domain
hostip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v 'hostip' | grep -v '172.*.*.*'`
sudo chmod a+wx /etc/hosts 
echo "$hostip	$domain" >> /etc/hosts
sudo chmod a-w /etc/hosts
sudo chmod a+wx -R /etc/nginx/sites-available
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$domain.conf
sed --in-place 's/root\ \/var\/www\/html;/root\ \/var\/www\/'$domain'\/html;/g' /etc/nginx/sites-available/$domain.conf
sed --in-place 's/server_name\ _;/server_name\ '$domain';/g' /etc/nginx/sites-available/$domain.conf
sed --in-place 's/index.nginx-debian.html/index.php/g' /etc/nginx/sites-available/$domain.conf
sed -i '52 s/#//' /etc/nginx/sites-available/$domain.conf
sed -i '53 s/#//' /etc/nginx/sites-available/$domain.conf
sed -i '58 s/#//' /etc/nginx/sites-available/$domain.conf
sed -i '58 s/#//' /etc/nginx/sites-available/$domain.conf
sudo chmod 755 -R /etc/nginx/sites-available /etc/nginx/sites-available/$domain.conf
sudo ln -sf /etc/nginx/sites-available/$domain.conf /etc/nginx/sites-enabled/$domain.conf
sudo unlink /etc/nginx/sites-enabled/default
sudo mkdir -p /var/www/$domain
user=`whoami`
sudo chown $user:$user -R /var/www/$domain
cd /var/www/$domain
wget http://wordpress.org/latest.zip
unzip latest.zip
rm -f latest.zip
rm -rf html
mv wordpress html
cp -v /var/www/$domain/html/wp-config-sample.php /var/www/$domain/html/wp-config.php
echo "Please enter database name: "
read dbname
sed --in-place 's/database_name_here/'$dbname'/g' /var/www/$domain/html/wp-config.php
echo "Please enter username for mysql: "
read dbuser
sed --in-place 's/username_here/'$dbuser'/g' /var/www/$domain/html/wp-config.php 
echo "Please enter password for mysql: "
read dbpasswd
sed --in-place 's/password_here/'$dbpasswd'/g' /var/www/$domain/html/wp-config.php 
sed --in-place 's/localhost/'127.0.0.1'/g' /var/www/$domain/html/wp-config.php
echo "Please enter mysql root password : "
mysql -uroot -p -e "create database $dbname;
CREATE USER '$dbuser'@'127.0.0.1' IDENTIFIED BY '$dbpasswd';
GRANT ALL PRIVILEGES ON * . * TO '$dbuser'@'127.0.0.1';
FLUSH PRIVILEGES;"
cd -
sudo service nginx restart
echo "Hit this url on your browser: http://$domain/wp-admin/install.php"
