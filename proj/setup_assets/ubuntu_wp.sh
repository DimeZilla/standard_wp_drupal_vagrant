#!/bin/bash

DIR=$(pwd)
BASEDIR="/vagrant/setup_assets"
echo "SWITCHING directories to $BASEDIR"
cd $BASEDIR
#update our box
add-apt-repository ppa:ondrej/php
apt-get update -y && apt-get upgrade -y

#install apapche
apt-get install -y apache2 libapache2-mod-auth-mysql

#install php5 and php5 mysql dependencies
apt-get install -y php php-mysql libapache2-mod-php php-mcrypt php-common mysql-client
#specific drupal dependencies
apt-get install -y php-xml php-gd

#set our webfiles directory to the default var www html directory
if [ ! -d /vagrant/webfiles ]; then
    mkdir /vagrant/webfiles
    cp $BASEDIR/swdv_README.txt /vagrant/webfiles/
fi

rm -rf /var/www/html && ln -s /vagrant/webfiles /var/www/html

#sed install our directory rules if we have an allow block .conf file
if [ -f $BASEDIR/apache_allow_block.conf ]; then
	sed -i "/DocumentRoot\ \/var\/www\/html/r $BASEDIR/apache_allow_block.conf" /etc/apache2/sites-available/000-default.conf
fi

#enable mod_rewrite
a2enmod rewrite

#restart apache
service apache2 restart

cd $DIR
