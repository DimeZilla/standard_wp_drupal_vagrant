#!/usr/bin/env bash

INSTALLPATH=/usr/share/jhd_create_dev
CURDIR=$(dirname $(readlink -f "$0"))

if [ ! -d $INSTALLPATH ]; then
  mkdir $INSTALLPATH
else
  rm -rf $INSTALLPATH
fi

cp -r $CURDIR $INSTALLPATH

LINKPATH=/usr/bin/create_dev

if [ -L $LINKPATH ]; then
    unlink $LINKPATH
fi

ln -s $INSTALLPATH/create_dev.sh $LINKPATH 
