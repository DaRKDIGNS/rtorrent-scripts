#!/usr/bin/env bash
set -e

if [[ $EUID -ne 0 ]]; then
    if [[ whoami != $SUDO_USER ]]; then
        export script=`basename $0`
        echo
        echo -e "\033[1;31mYou must run this script as a user using sudo ${script}.\033[0m" 1>&2
        echo
        exit
    fi
    export script=`basename $0`
    echo
    echo -e "\033[1;31mYou must run this script as a user using sudo ${script}, not as the root user.\033[0m" 1>&2
    echo
    exit
fi

#get user home folder
export USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

#stop current rtorrent sessions
if [ -f "$USER_HOME/start_rtorrent.php" ]; then
	sudo su $SUDO_USER -c "php $USER_HOME/start_rtorrent.php kill"
fi

#create working folder
mkdir -p $USER_HOME/compile

# get system core count
cores=`cat /proc/cpuinfo | grep processor | wc -l`
((cores++))

# Compile xlmrpc-c
if [ -d "$USER_HOME/compile/xmlrpc-c" ]; then
	cd $USER_HOME/compile/xmlrpc-c
	svn up
	make clean
else
	cd $USER_HOME/compile/
	svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c
	cd $USER_HOME/compile/xmlrpc-c
fi
/bin/sh ./configure --disable-cplusplus -q
make -j$cores
make install

# Install libtorrent
if [ -d "$USER_HOME/compile/libtorrent" ]; then
	cd $USER_HOME/compile/libtorrent
	git pull
	make clean
else
	cd $USER_HOME/compile/
	git clone https://github.com/rakshasa/libtorrent.git libtorrent
	cd $USER_HOME/compile/libtorrent
fi
/bin/sh ./autogen.sh
/bin/sh ./configure -q
make -j$cores
make install

# Install rtorrent
if [ -d "$USER_HOME/compile/rtorrent" ]; then
	cd $USER_HOME/compile/rtorrent
	git pull
	make clean
else
	cd $USER_HOME/compile/
	git clone https://github.com/rakshasa/rtorrent.git rtorrent
	cd $USER_HOME/compile/rtorrent
fi
/bin/sh ./autogen.sh
/bin/sh ./configure --with-xmlrpc-c -q
make -j$cores
make install
ldconfig

#stop current rtorrent sessions
if [ -f "$USER_HOME/start_rtorrent.php" ]; then
	sudo su $SUDO_USER -c "php $USER_HOME/start_rtorrent.php"
fi

# Install .rtorrent.rc
wget --no-check-certificate https://raw.githubusercontent.com/jonnyboy/rtorrent-scripts/master/config/rtorrent.rc -O $USER_HOME/.rtorrent.rc
sed -i -e "s/USERNAME/$SUDO_USER/" $USER_HOME/.rtorrent.rc
mkdir -p $USER_HOME/Downloads/.session/
mkdir -p $USER_HOME/Downloads/watch
mkdir -p $USER_HOME/Downloads/incomplete

