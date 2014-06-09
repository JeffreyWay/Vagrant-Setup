#!/usr/bin/env bash

echo "--- Good morning, master. Let's get to work. Installing now. ---"

echo "--- Updating packages list ---"
apt-get update

echo "--- MySQL time ---"
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

echo "--- Installing base packages ---"
apt-get install -y vim curl python-software-properties

echo "--- We want the bleeding edge of PHP, right master? ---"
add-apt-repository -y ppa:ondrej/php5

echo "--- Updating packages list ---"
apt-get update

echo "--- Installing PHP-specific packages ---"
apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core

echo "--- Installing and configuring Xdebug ---"
apt-get install -y php5-xdebug

cat << EOF | tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "--- Enabling mod-rewrite ---"
a2enmod rewrite

echo "--- Setting document root ---"
rm -rf /var/www
ln -fs /vagrant/public /var/www


echo "--- What developer codes without errors turned on? Not you, master. ---"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

echo "--- Restarting Apache ---"
service apache2 restart

echo "--- Composer is the future. But you knew that, did you master? Nice job. ---"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Laravel stuff here, if you want

echo "--- All set to go! Would you like to play a game? ---"
