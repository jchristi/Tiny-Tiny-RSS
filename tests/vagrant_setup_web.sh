#!/bin/bash -e

DBNAME=ttrss
DBUSER=ttrss_user
DBPASS=ttrss_pass
PGDATA=/var/lib/pgsql/data

# Disable SELinux
setenforce 0

# Install required RPMs
yum update -y
yum install -y httpd php php-pecl-zip php-xml php-pgsql postgresql postgresql-server # php-mysqlnd mariadb-server

# TT-RSS apache share
if [ ! -f /var/www/html/config.php ]; then
  rm -rf /var/www/html
  ln -s /vagrant /var/www/html
  cp /vagrant/tests/config/config.php /var/www/html/config.php
  systemctl start httpd.service
fi

sleep 5

# Setup PostgreSQL
if [ ! -e /var/lib/pgsql/initdb.log ] &&
    [ ! $(cat /var/lib/pgsql/initdb.log | grep Success) ]; then
  [ -e $PGDATA/pg_log ] && rm -rf $PGDATA/pg_log
  postgresql-setup initdb
fi

# Allow all local users access
cat /vagrant/tests/config/pg_hba.conf > $PGDATA/pg_hba.conf

# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" $PGDATA/postgresql.conf
# Explicitly set default client_encoding
sed -i "s/#client_encoding = sql_ascii/client_encoding = utf8" $PGDATA/postgresql.conf

systemctl restart postgresql.service

if [ ! -e $PGDATA/ttrss ]; then
  #su - postgres
  #CREATEUSER="createuser -e $DBUSER"
  #echo $CREATEUSER
  #$CREATEUSER || $CREATEUSER || $CREATEUSER
  #CREATEDB="createdb -e $DBNAME --owner=$DBUSER"
  #echo $CREATEDB
  #$CREATEDB || $CREATEDB || $CREATEDB
  #PGSQL="psql -X -q -a -1 -v ON_ERROR_STOP=1 --pset pager=off -d ${DBNAME} -f"
  #$PGSQL /vagrant/schema/ttrss_schema_pgsql.sql
  #exit
  cat << EOF | su - postgres -c pgsql
-- Create the database user:
CREATE USER $DBUSER WITH PASSWORD '$DBPASS';

-- Create the database:
CREATE DATABASE $DBNAME WITH OWNER=$DBUSER
  LC_COLLATE='en_US.utf8'
  LC_CTYPE='en_US.utf8'
  ENCODING='UTF8'
  TEMPLATE=template0;
EOF

fi

# Setup MariaDB


echo "Provision complete"
