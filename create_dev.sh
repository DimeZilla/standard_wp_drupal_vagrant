#!/usr/bin/env bash

NEWDIR=$1

if [ -z "$NEWDIR" ]; then
   echo "Please tell me what you want to call the new project"
   exit
fi

echo "Creating new project: $NEWDIR"
BASESOURCE=$(dirname $(readlink -f "$0"))
CURDIR=$(pwd)

cp -r $BASESOURCE/proj $CURDIR/$NEWDIR 
