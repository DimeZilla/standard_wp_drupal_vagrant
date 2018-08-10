#!/usr/bin/env bash

INSTALLPATH=/usr/share/vagrant-create
CURDIR=$(dirname $(readlink -f "$0"))

# make our vagrant-create script executable
chmod +x vagrant-create.sh

if [ ! -d $INSTALLPATH ]; then
  mkdir $INSTALLPATH
else
  rm -rf $INSTALLPATH
fi

cp -r $CURDIR $INSTALLPATH

LINKPATH=/usr/bin/vagrant-create

if [ -L $LINKPATH ]; then
    unlink $LINKPATH
fi

ln -s $INSTALLPATH/create_dev.sh $LINKPATH
