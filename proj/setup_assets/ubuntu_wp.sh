#!/bin/bash
#
DIR=$(pwd)
BASEDIR="/vagrant/setup_assets"
VERSION=$1
echo "SWITCHING directories to $BASEDIR"
cd $BASEDIR
#update our box
apt-get update -y
apt-get upgrade -y

# This takes a little longer but it ensures that the whole command won't necessarily
# fail when a package no longer exsists
dependencies=( "apache2" "libapache2-mod-auth-mysql" "mysql-client" "python-software-properties" )

phpdeps=( "php" "php-mysql" "php-mcrypt" "php-common" "php-xml" "php-gd" "libapache2-mod-php" "php-mbstring" )
phpVersionedDeps=( "php$VERSION" "php$VERSION-mysql" "php$VERSION-mcrypt" "php$VERSION-common" "php$VERSION-xml" "php$VERSION-gd" "libapache2-mod-php$VERSION" "php$VERSION-mbstring" )

depInstaller(){
    deps=("${!1}")
    for elem in ${deps[@]}
    do
      echo "---------------"
      echo "INSTALLING $elem"
      echo "---------------"
      apt-get install -y $elem
    done
}

installOther(){
    apt-get update -y
    depInstaller phpVersionedDeps[@]
}

add-apt-repository ppa:ondrej/php
apt-get update -y

# Install apache first
depInstaller dependencies[@]

if [ $VERSION == "latest" ] || [ $VERSION == "" ]; then
    echo "Installing latest php"
    depInstaller phpdeps[@]
else
    echo "Installing $VERSION version of php"
    installOther
fi


#set our webfiles directory to the default var www html directory
if [ ! -d /vagrant/webfiles ]; then
    mkdir /vagrant/webfiles
    cp $BASEDIR/swdv_README.txt /vagrant/webfiles/
fi

rm -rf /var/www/html && ln -s /vagrant/webfiles /var/www/html

#sed install our directory rules if we have an allow block .conf file
# if [ -f $BASEDIR/apache_allow_block.conf ]; then
#     sed -i "/DocumentRoot\ \/var\/www\/html/r $BASEDIR/apache_allow_block.conf" /etc/apache2/sites-available/000-default.conf
# fi
if [ -f $BASEDIR/apache_config.conf ]; then
    cat $BASEDIR/apache_config.conf > /etc/apache2/sites-available/000-default.conf
fi

# one more update
apt-get update -y
apt-get upgrade -y

#enable mod_rewrite
a2enmod rewrite

#restart apache
service apache2 restart

cd $DIR
