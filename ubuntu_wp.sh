#!/bin/bash

#update our box
apt-get update -y && apt-get upgrade -y

#install apapche
apt-get install -y apache2 libapache2-mod-auth-mysql
#enable mod_rewrite
a2enmod rewrite

#install php5 and php5 mysql dependencies
apt-get install -y php5 php5-mysql libapache2-mod-php5 php5-mcrypt php5-common

#set our webfiles directory to the default var www html directory
if [ ! -d /vagrant/webfiles ]; then
    mkdir /vagrant/webfiles
fi
touch /vagrant/webfiles/README.txt
cp ./wp_setup_assets/webfiles_README.txt /vagrant/webfiles/README.txt

rm -rf /var/www/html && ln -s /vagrant/webfiles /var/www/html

#sed install our directory rules if we have an allow block .conf file
if [ -f ./wp_setup_assets/apache_allow_block.conf ]; then
	sed -i "/DocumentRoot\ \/var\/www\/html/r ./wp_setup_assets/apache_allow_block.conf" /etc/apach e2/sites-enabled/000-default.conf
fi
#restart apache
service restart apache2

#outputs ip address for host file configuration
echo "Server IP for hosts file "
ifconfig eth0 | grep inet | awk '{ print $2 }'
