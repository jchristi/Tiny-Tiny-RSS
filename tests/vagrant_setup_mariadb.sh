#!/bin/bash -e

export PATH="/usr/local/bin:$PATH"

DBNAME=ttrss
DBUSER=ttrss_user
DBPASS=ttrss_pass

# Disable SELinux
setenforce 0

# Install required RPMs
yum update -y
yum install -y httpd php php-mbstring php-pdo php-pecl-zip php-xml php-mysqlnd mariadb-server phpMyAdmin

# Setup phpMyAdmin
cp /vagrant/tests/config/phpMyAdmin.conf /etc/httpd/conf.d/phpMyAdmin.conf
cp /vagrant/tests/config/config.inc.phpMyAdmin /etc/phpMyAdmin/config.inc.php

# TT-RSS apache share
if [ ! -f /var/www/html/config.php ]; then
  rm -rf /var/www/html
  ln -s /vagrant /var/www/html
  cp /vagrant/tests/config/config.php /var/www/html/config.php
fi

systemctl restart httpd.service

# Setup MariaDB
systemctl start mariadb.service
mysql -u root -e "DROP DATABASE IF EXISTS $DBNAME;"
mysql -u root -e "DROP USER '$DBUSER'@'localhost'" >/dev/null 2>&1 || :
mysql -u root -e "CREATE USER '$DBUSER'@'localhost';"
mysql -u root -e "SET PASSWORD FOR '$DBUSER'@'localhost' = PASSWORD('$DBPASS');"
mysql -u root -e "CREATE DATABASE $DBNAME;"
mysql -u root -e "GRANT ALL ON $DBNAME.* TO '$DBUSER'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"
mysql -u root $DBNAME < /vagrant/schema/ttrss_schema_mysql.sql
systemctl restart mariadb.service

# Setup PHP Unit tests libraries
#pushd /var/www/html >/dev/null
#  if [ ! -e /usr/local/bin/composer ]; then
#    curl -sS https://getcomposer.org/installer | php
#    mv composer.phar /usr/local/bin/composer
#  fi
#  if [ ! -e /usr/local/bin/phpunit ]; then
#    curl -sS https://phar.phpunit.de/phpunit.phar -o phpunit.phar
#    chmod +x phpunit.phar
#    sudo mv phpunit.phar /usr/local/bin/phpunit
#  fi
#  composer install
#popd >/dev/null

echo "Provision complete"
