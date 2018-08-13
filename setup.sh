#!/usr/bin/env bash

INSTALLPATH=/usr/share/vagrant-create

echo "Installing vagrant-create"

CURDIR=$(dirname $(readlink -f "$0"))

# make our vagrant-create script executable
chmod +x vagrant-create.sh

if [ ! -d $INSTALLPATH ]; then
  mkdir $INSTALLPATH
else
  rm -rf $INSTALLPATH
fi

echo "Copying installation files to $INSTALLPATH"
cp -r $CURDIR $INSTALLPATH

LINKPATH=/usr/bin/vagrant-create

if [ -L $LINKPATH ]; then
    unlink $LINKPATH
fi

echo "Setting up command-line utility"

ln -s $INSTALLPATH/vagrant-create.sh $LINKPATH

echo "Thats it! You're good to go."

echo "To make sure it worked run:"
echo "    > which vagrant-create"
