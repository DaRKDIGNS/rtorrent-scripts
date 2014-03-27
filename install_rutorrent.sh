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

# Compile xlmrpc-c
if [ -d "$USER_HOME/compile/rutorrent/trunk" ]; then
	cd /$USER_HOME/compile/rutorrent/trunk
	svn up
	mkdir -p /var/www
	chown -R www-data:www-data $USER_HOME/compile/rutorrent/
	chown -R www-data:www-data /var/www
else
	mkdir -p $USER_HOME/compile/rutorrent
	cd $USER_HOME/compile/rutorrent
	svn co http://rutorrent.googlecode.com/svn/trunk/
	rm -r $USER_HOME/compile/rutorrent/trunk/rutorrent/plugins/
	mkdir -p /var/www
	chown -R www-data:www-data $USER_HOME/compile/rutorrent/
	chown -R www-data:www-data /var/www
fi

# disable all plugins
sed -i -e 's/^enabled = .*$/enabled = no/' $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini

# enable plugins
if ! grep -q "\[autotools\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[autotools]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[check_port\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[check_port]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[cpuload\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[cpuload]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[create\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[create]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[datadir\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[datadir]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[diskspace\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[diskspace]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[edit\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[edit]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[erasedata\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[erasedata]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[_getdir\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[_getdir]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[httprpc\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[httprpc]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[show_peers_like_wtorrent\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[show_peers_like_wtorrent]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[source\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[source]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[theme\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[theme]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[tracklabels\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[tracklabels]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[logoff\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[logoff]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[rutorrent-instantsearch\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[rutorrent-instantsearch]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

if ! grep -q "\[nfo\]" "$USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini" ; then
	echo "" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "[nfo]" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
	echo "enabled = yes" >> $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/plugins.ini
fi

# Add poweroff
if [ -d "$USER_HOME/compile/rutorrent/trunk/plugins/logff" ]; then
	cd $USER_HOME/compile/rutorrent/trunk/plugins/loggoff
	svn up
else
	cd $USER_HOME/compile/rutorrent/trunk/plugins
	svn checkout http://rutorrent-logoff.googlecode.com/svn/trunk/ logoff
fi

# Add Instant Search
if [ -d "$USER_HOME/compile/rutorrent/trunk/plugins/rutorrent-instantsearch" ]; then
	cd $USER_HOME/compile/rutorrent/trunk/plugins/rutorrent-instantsearch
	svn up
else
	cd $USER_HOME/compile/rutorrent/trunk/plugins
	svn checkout http://rutorrent-instantsearch.googlecode.com/svn/trunk/ rutorrent-instantsearch
fi

# Add Oblivion Theme
if [ ! -d "$USER_HOME/compile/rutorrent/trunk/plugins/oblivion" ]; then
	wget --no-check-certificate https://raw.githubusercontent.com/jonnyboy/rtorrent-scripts/master/config/rutorrent-oblivion.zip -O $USER_HOME/compile/rutorrent/trunk/plugins/rutorrent-oblivion.zip
	cd /home/jonnyboy/compile/rutorrent/trunk/plugins/
	unzip rutorrent-oblivion.zip
	rm rutorrent-oblivion.zip
fi

if ! grep -q 'for Oblivion' "$USER_HOME/compile/rutorrent/trunk/rutorrent/css/style.css" ; then
	echo "" | tee -a $USER_HOME/compile/rutorrent/trunk/rutorrent/css/style.css > /dev/null
	echo "/* for Oblivion */" | tee -a $USER_HOME/compile/rutorrent/trunk/rutorrent/css/style.css > /dev/null
	echo ".meter-value-start-color { background-color: #E05400 }" | tee -a $USER_HOME/compile/rutorrent/trunk/rutorrent/css/style.css > /dev/null
	echo ".meter-value-end-color { background-color: #8FBC00 }" | tee -a $USER_HOME/compile/rutorrent/trunk/rutorrent/css/style.css > /dev/null
	echo "::-webkit-scrollbar {width:12px;height:12px;padding:0px;margin:0px;}" | tee -a $USER_HOME/compile/rutorrent/trunk/rutorrent/css/style.css > /dev/null
fi

sed -i -e 's/plugin.prgStartColor =.*$/plugin.prgStartColor = new RGBackground("#9ADC00");/' $USER_HOME/compile/rutorrent/trunk/plugins/diskspace/init.js
sed -i -e 's/plugin.prgEndColor =.*$/plugin.prgEndColor = new RGBackground("#F90009");/' $USER_HOME/compile/rutorrent/trunk/plugins/diskspace/init.js
sed -i -e 's/plugin.prgStartColor =.*$/plugin.prgStartColor = new RGBackground("#9ADC00");/' $USER_HOME/compile/rutorrent/trunk/plugins/cpuload/init.js
sed -i -e 's/plugin.prgEndColor =.*$/plugin.prgEndColor = new RGBackground("#F90009");/' $USER_HOME/compile/rutorrent/trunk/plugins/cpuload/init.js
perl -pi -e "s/\$defaultTheme \= \"\"\;/\$defaultTheme \= \"Oblivion\"\;/g" $USER_HOME/compile/rutorrent/trunk/plugins/theme/conf.php
perl -pi -e "s/\"curl\"\t=> ''/\"curl\"\t=> '\/usr\/bin\/curl'/" $USER_HOME/compile/rutorrent/trunk/rutorrent/conf/config.php

# Add NFO Viewer
if [ ! -d "$USER_HOME/compile/rutorrent/trunk/plugins/nfo" ]; then
	cd $USER_HOME/compile/rutorrent/trunk/plugins/
	wget http://srious.biz/nfo.tar.gz
	tar xzfv nfo.tar.gz
	rm nfo.tar.gz
fi

cp -R $USER_HOME/compile/rutorrent/trunk/rutorrent /var/www/
cp -R $USER_HOME/compile/rutorrent/trunk/plugins /var/www/rutorrent/

chown -R www-data:www-data $USER_HOME/compile/rutorrent/
chown -hRLH www-data:www-data /var/www/
