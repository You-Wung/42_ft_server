#!/bin/bash

# set permission
chown -R www-data:www-data /var/www/
chmod -R 755 /var/www/

# openssl 
openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoual/O=42/OU=42Seoul/CN=localhost" -keyout localhost.dev.key -out localhost.dev.crt
mv localhost.dev.crt etc/ssl/certs/
mv localhost.dev.key etc/ssl/private/
chmod 600 etc/ssl/certs/localhost.dev.crt etc/ssl/private/localhost.dev.key

# set nginx
cp -rp /tmp/default /etc/nginx/sites-available/

# wordpress installation and setting
wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
mv wordpress/ var/www/html/
chown -R www-data:www-data /var/www/html/wordpress
cp -rp ./tmp/wp-config.php /var/www/html/wordpress

# to make DB table
service mysql start
echo "CREATE DATABASE IF NOT EXISTS wordpress;" \
	| mysql -u root --skip-password
echo "CREATE USER IF NOT EXISTS 'tyou'@'localhost' IDENTIFIED BY '';" \
	| mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'tyou'@'localhost' WITH GRANT OPTION;" \
	| mysql -u root --skip-password

# phpMyAdmin installation and setting
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages phpmyadmin
mv phpmyadmin /var/www/html/
rm phpMyAdmin-5.0.2-all-languages.tar.gz
cp -rp /tmp/config.inc.php /var/www/html/phpmyadmin/

service nginx start
service php7.3-fpm start
service mysql restart

bash
