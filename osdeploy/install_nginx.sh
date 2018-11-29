#!/bin/bash
#
mkdir -p /var/www/html/magento2



sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
apt-get -y install nginx php7.1-fpm php7.1-cli

sed -i -E "s/memory_limit =.*/memory_limit = 2G/" /etc/php/7.1/cli/php.ini
sed -i -E "s/max_execution_time =.*/max_execution_time = 1800/" /etc/php/7.1/cli/php.ini
sed -i -E "s/zlib.output_compression =.*/zlib.output_compression = On/" /etc/php/7.1/cli/php.ini

sed -i -E "s/memory_limit =.*/memory_limit = 2G/" /etc/php/7.1/fpm/php.ini
sed -i -E "s/max_execution_time =.*/max_execution_time = 1800/" /etc/php/7.1/fpm/php.ini
sed -i -E "s/zlib.output_compression =.*/zlib.output_compression = On/" /etc/php/7.1/fpm/php.ini

systemctl restart php7.1-fpm

cat << EOF > /etc/nginx/sites-available/magento
upstream fastcgi_backend {
     server unix:/run/php/php7.1-fpm.sock;
 }

 server {

     listen 80;
     server_name test.repairwebshop.nl;
     set \$MAGE_ROOT /var/www/html/magento2;
     include /var/www/html/magento2/nginx.conf.sample;
 }
EOF

ln -s /etc/nginx/sites-available/magento /etc/nginx/sites-enabled
service nginx restart
