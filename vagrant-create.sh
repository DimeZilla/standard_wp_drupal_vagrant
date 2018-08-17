#!/usr/bin/env bash
NEWDIR="${@: -1}"

if [ -z "$NEWDIR" ] || [ ${NEWDIR:0:1} == "-" ]; then
   echo "Please tell me what you want to call the new project"
   exit
fi

PHP_VERSION="7.1"
APACHE_WEB_DIR="/var/www/html"
VAGRANT_BOX="ubuntu/xenial64"
NETWORK_TYPE="forwarded"
FORWARD_GUEST_PORT="80"
FORWARD_HOST_PORT="8080"

echooption() {
    echo "$1    $3"
    echo "    ALIAS: $2"
    echo "    DEFAULT: $4"
}

usage()
{
    echo "USAGE"
    echo ""
    echo "vagrant-create [options] [new project directory name]"
    echo ""
    echo "OPTIONS:"
    echooption "--php" "-p" "Defines the version of php to install in the vagrant box" "7.1"
    echooption "--vagrant-box" "-vb" "Use a different vagrant box" "ubuntu/xenial64"
    echooption "--network-type" "-nt" "Choose between 'private' and 'forwarded' networks" "forwarded"
    echooption "--forward-host-port" "-fhp" "The host port to which we will forward the guest port" "8080"
    echooption "--forward-guest-port" "-fgp" "The guest port from which we will forward to the host port" "80"
    echooption "--apache-web-dir" "-awd" "The apache web directory from which apache will serve the application" "/var/www/html"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    if [ ! -z "$VALUE" ]
    then
        case $PARAM in
            -h | --help)
                usage
                exit
                ;;
            --php | -p)
                unset PHP_VERSION
                PHP_VERSION=$VALUE
                ;;
            --forward-host-port | -fhp)
                unset FORWARD_HOST_PORT
                FORWARD_HOST_PORT=$VALUE
                ;;
            --forward-guest-port | -fgp)
                unset FORWARD_GUEST_PORT
                FORWARD_GUEST_PORT=$VALUE
                ;;
            --apache-web-dir | -awd)
                unset APACHE_WEB_DIR
                APACHE_WEB_DIR=$VALUE
                ;;
            --vagrant-box | -vb)
                unset VAGRANT_BOX
                VAGRANT_BOX=$VALUE
                ;;
            --network-type | -nt)
                unset NETWORK_TYPE
                NETWORK_TYPE=$VALUE
                ;;
        esac
    fi
    shift
done

echo "Creating new project: $NEWDIR"
BASESOURCE=$(dirname $(readlink -f "$0"))/src
CURDIR=$(pwd)

PROJDIR=$CURDIR/$NEWDIR

# make our project directory
if [ ! -d $PROJDIR ]
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
    TMPPATH=$PROJDIR/$2
    if [ ! -f $TMPPATH ]
    then
        cp $BASESOURCE/$1 $TMPPATH
    else
        echo "File $2 already exists in $PROJDIR"
    fi
}

# Now lets copy over all of the files we need
cpfile downloads_README.txt downloads/README.txt
cpfile apache_config_README.txt apache_logs/README.txt
cpfile provisioner.sh setup_assets/provisioner.sh
cpfile apache_config.conf setup_assets/apache_config.conf
cpfile Vagrantfile Vagrantfile
cpfile README.txt Readme.txt

replaceStubbedString()
{
    TMPFILE=$PROJDIR/$3
    SEDLINE="s|$1|$2|g"
    # echo $SEDLINE
    # echo $TMPFILE
    sed -i $SEDLINE $TMPFILE
}


echo "Building vagrant $VAGRANT_BOX box: "
replaceStubbedString VAGRANT_BOX $VAGRANT_BOX Vagrantfile

echo "PHP VERSION: $PHP_VERSION"
replaceStubbedString PHP_VERSION $PHP_VERSION Vagrantfile

echo "NETWORK TYPE IS: $NETWORK_TYPE"
replaceStubbedString NETWORK_TYPE $NETWORK_TYPE Vagrantfile
if [ "$NETWORK_TYPE" != "private" ]
then
    echo "FORWARD GUEST PORT $FORWARD_GUEST_PORT"
    replaceStubbedString FORWARD_GUEST_PORT $FORWARD_GUEST_PORT Vagrantfile
    echo "FORWARD HOST PORT $FORWARD_HOST_PORT"
    replaceStubbedString FORWARD_HOST_PORT $FORWARD_HOST_PORT Vagrantfile
fi

echo "APACHE WEB DIRECTORY: $APACHE_WEB_DIR"
replaceStubbedString DOCUMENT_ROOT $APACHE_WEB_DIR setup_assets/apache_config.conf

echo "IN NEW DIRECTORY $NEWDIR"

# cp -r $BASESOURCE/src $CURDIR/$NEWDIR

echo "ALL SET! cd into $PROJDIR and run 'vagrant up' to get started"
