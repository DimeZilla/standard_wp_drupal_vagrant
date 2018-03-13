#!/bin/bash

DIR=$(pwd)
BASEDIR="/vagrant/setup_assets"
echo "SWITCHING directories to $BASEDIR"
cd $BASEDIR
#update our box
add-apt-repository ppa:ondrej/php
apt-get update -y && apt-get upgrade -y

# This takes a little longer but it ensures that the whole command won't necessarily
# fail when a package no longer exsists
dependencies=( "apache2" "libapache2-mod-auth-mysql" "libapache2-mod-php" "mysql-client" )
phpdeps=( "php" "php-mysql" "php-mcrypt" "php-common" "php-xml" "php-gd" )

depInstaller(){
    deps=("${!1}")
    for elem in ${deps[@]}
    do
      apt-get install -y $elem
    done
}

depInstaller dependencies[@]
depInstaller phpdeps[@]

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

# one more update
apt-get update -y && apt-get upgrade -y

#enable mod_rewrite
a2enmod rewrite

#restart apache
service apache2 restart


cd $DIR
