#!/bin/bash

cd /var/www/html/
/usr/local/bin/php aws-init/test.php

#create database and import sql
cd /var/www/html/
./install-sql.sh

#create configuration.php file
touch /var/www/html/videos/configuration.php

# setting config
./make-settings.sh

# 启动 apache
apache2-foreground

exec "$@"
