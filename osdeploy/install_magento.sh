export MAGENTO_VERSION=2.3.0
export INSTALL_DIR=/var/www/html/magento2
export COMPOSER_HOME=/var/www/.composer/
cp auth.json $COMPOSER_HOME
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

export requirements="libpng12-dev libmcrypt-dev libmcrypt4 libcurl3-dev libfreetype6 libjpeg-turbo8 libjpeg-turbo8-dev libpng12-dev libfreetype6-dev libicu-dev libxslt1-dev"
apt-get install -y $requirements 
apt-get install php7.1-mcrypt php7.1-mbstring php7.1-curl php7.1-xml php7.1-zip php7.1-mysql php7.1-gd php7.1-imagick php7.1-recode php7.1-tidy php7.1-xmlrpc php7.1-intl php7.1-xsl php7.1-soap php7.1-bcmath

 cd /var/www/html/magento2
 find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
 find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
 chown -R :www-data .
 chmod u+x bin/magento

echo now run setup-magento.sh

