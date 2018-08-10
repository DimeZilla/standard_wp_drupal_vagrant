#!/usr/bin/env bash

NEWDIR=$1

if [ -z "$NEWDIR" ]; then
   echo "Please tell me what you want to call the new project"
   exit
fi

echo "Creating new project: $NEWDIR"
BASESOURCE=$(dirname $(readlink -f "$0"))/src
CURDIR=$(pwd)

PROJDIR=$CURDIR/$NEWDIR

# make our project directory
if [ ! -d $1 ]
then
    mkdir $PROJDIR
else
    echo "$PROJDIR already exists"
fi

# to do: move over to copying stubs
mkprojdir() {
    TMPDIR=$PROJDIR/$1
    if [ ! -d $TMPDIR ]
    then
        echo "CREATING DIRECTORY $TMPDIR"
        mkdir $TMPDIR
    else
        echo "$TMPDIR directory already exists"
    fi
}

# create the directories we want in the new project
mkprojdir apache_logs
mkprojdir downloads
mkprojdir webfiles
mkprojdir setup_assets

cpfile()
{
    TMPPATH=$PROJDIR/$1
    if [ ! -f $TMPPATH ]
    then
        echo "CREATING $TMPPATH"
        cp $BASESOURCE/$1 $TMPPATH
    else
        echo "File $2 already exists in $PROJDIR"
    fi
}

# Now lets copy over all of the files we need
cpfile downloads_README.txt downloads/README.txt
cpfile apache_config_README.txt apache_logs/README.txt
cpfile provisioner.sh setup_assets/provisioner.sh
cpfile Vagrantfile Vagrantfile
cpfile README.txt Readme.txt

# cp -r $BASESOURCE/src $CURDIR/$NEWDIR

echo "ALL SET! cd into $PROJDIR and run 'vagrant up' to get started"
