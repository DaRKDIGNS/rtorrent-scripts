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

if [[ $# -ne 1 ]]; then
	echo -e "\nThis script will compile rtorrent.\n"
	echo  "$0 current    ...: To compile bleeding edge version."
	echo  "$0 default    ...: To compile rtorrent 0.9.3/0.13.3."
	echo  "$0 previous   ...: To compile rtorrent 0.9.2/0.13.2."
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
rm -rf "$USER_HOME/compile/libtorrent"
if [[ $1 == "current" ]]; then
	cd $USER_HOME/compile/
	git clone https://github.com/rakshasa/libtorrent.git libtorrent
elif [[ $1 == "default" ]]; then
	cd $USER_HOME/compile/
	wget -c http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.3.tar.gz
	tar xfz libtorrent-0.13.3.tar.gz
	mv libtorrent-0.13.3 libtorrent
elif [[ $1 == "previous" ]]; then
	cd $USER_HOME/compile/
	wget -c http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.2.tar.gz
	tar xfz libtorrent-0.13.2.tar.gz
	mv libtorrent-0.13.2 libtorrent
fi
cd $USER_HOME/compile/libtorrent
/bin/sh ./autogen.sh
/bin/sh ./configure -q
make -j$cores
make install

# Install rtorrent
rm -rf "$USER_HOME/compile/rtorrent"
if [[ $1 == "current" ]]; then
	cd $USER_HOME/compile/
	git clone https://github.com/rakshasa/rtorrent.git rtorrent
elif [[ $1 == "default" ]]; then
	cd $USER_HOME/compile/
	wget -c http://libtorrent.rakshasa.no/downloads/rtorrent-0.9.3.tar.gz
	tar xfz rtorrent-0.9.3.tar.gz
	mv rtorrent-0.9.3 rtorrent
elif [[ $1 == "previous" ]]; then
	cd $USER_HOME/compile/
	wget -c http://libtorrent.rakshasa.no/downloads/rtorrent-0.9.2.tar.gz
	tar xfz rtorrent-0.9.2.tar.gz
	mv rtorrent-0.9.2 rtorrent
fi
cd $USER_HOME/compile/rtorrent
/bin/sh ./autogen.sh
/bin/sh ./configure --with-xmlrpc-c -q
make -j$cores
make install
ldconfig

# Install .rtorrent.rc if not already exists
if [ ! -f "$USER_HOME/.rtorrent.rc" ]; then
	wget --no-check-certificate https://raw.githubusercontent.com/jonnyboy/rtorrent-scripts/master/config/rtorrent.rc -O $USER_HOME/.rtorrent.rc
	sed -i -e "s/USERNAME/$SUDO_USER/" $USER_HOME/.rtorrent.rc
fi
mkdir -p $USER_HOME/Downloads/.session/
mkdir -p $USER_HOME/Downloads/watch
mkdir -p $USER_HOME/Downloads/incomplete
mkdir -p $USER_HOME/Downloads/complete

#start current rtorrent sessions but not attach
if [ -f "$USER_HOME/start_rtorrent.php" ]; then
    sudo su $SUDO_USER -c "php $USER_HOME/start_rtorrent.php cron"
fi

exit
