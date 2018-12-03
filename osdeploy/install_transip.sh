#!/bin/bash
#
mkdir -p /opt/letsencryptssl/dnsbackups
/usr/bin/wget https://api.transip.nl/download/transapi_transip.nl_v5_8.tar.gz -O /opt/letsencryptssl/transapi_transip.nl_v5_8.tar.gz
/bin/tar -xf https://api.transip.nl/download/transapi_transip.nl_v5_8.tar.gz -C /opt/letsencryptssl


cp secrets/ApiSettings.php /opt/letsencryptssl/Transip/ApiSettings.php
cp DnsEntry.php /opt/letsencryptssl/Transip/DnsEntry.php
cp create_CAA.php /opt/letsencryptssl/
cp create_cert.sh /opt/letsencryptssl/
cp hooks.php /opt/letsencryptssl
chmod 700 /opt/letsencryptssl/*.sh

git clone https://github.com/roy-bongers/certbot-transip-dns-01-validator.git /opt/letsencryptssl/certbotvalidator
ln -s /opt/letsencryptssl/certbotvalidator/auth-hook.php /opt/letsencryptssl/auth-hook.php
ln -s /opt/letsencryptssl/certbotvalidator/cleanup-hook.php /opt/letsencryptssl/cleanup-hook.php
ln -s /opt/letsencryptssl/certbotvalidator/dns.php /opt/letsencryptssl/dns.php

sed -i -E "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.1/cli/php.ini

add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install python-certbot-apache

echo "add entry to crontab example:   0 1* * 0 certbot renew --config-dir /etc/letsencrypt"

cd /opt/letsencrypt

echo start php create_CAA.sh for creation of CAA records
echo start create_cert.sh for creation of certs
