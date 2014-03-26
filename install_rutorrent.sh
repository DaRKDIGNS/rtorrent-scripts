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
	chown -RH www-data:www-data /var/www
	ln -sfv $USER_HOME/compile/rutorrent/trunk/rutorrent /var/www/
	rm -r /var/www/rutorrent/plugins
	ln -sfv $USER_HOME/compile/rutorrent/trunk/plugins /var/www/rutorrent/
else
	mkdir -p $USER_HOME/compile/rutorrent
	cd $USER_HOME/compile/rutorrent
	svn co http://rutorrent.googlecode.com/svn/trunk/
	mkdir -p /var/www
	chown -R www-data:www-data $USER_HOME/compile/rutorrent/
	chown -RH www-data:www-data /var/www
	ln -sfv $USER_HOME/compile/rutorrent/trunk/rutorrent /var/www/
	rm -r /var/www/rutorrent/plugins
	ln -sfv $USER_HOME/compile/rutorrent/trunk/plugins /var/www/rutorrent/
fi

# enable plugins
echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[autotools]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[check_port]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[chunks]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[cookies]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[cpuload]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[create]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[data]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[datadir]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[diskspace]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[edit]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[erasedata]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[extratio]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[extsearch]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[feeds]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[filedrop]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[geoip]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[_getdir]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[history]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[httprpc]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[ipad]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[loginmgr]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[lookat]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[mediainfo]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[_noty]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[ratio]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[retrackers]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[rpc]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[rss]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[rssurlrewrite]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[rutracker_check]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[scheduler]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[screenshots]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[seedingtime]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[show_peers_like_wtorrent]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[source]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[_task]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[theme]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[throttle]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[tracklabels]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = yes" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[trafic]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

echo "" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "[unpack]" >> $USER_HOME/compile/rutorrent/conf/plugins.ini
echo "enabled = no" >> $USER_HOME/compile/rutorrent/conf/plugins.ini

# Add poweroff
cd $USER_HOME/compile/rutorrent/trunk/plugins
svn checkout http://rutorrent-logoff.googlecode.com/svn/trunk/ logoff

# Add Instant Search
svn checkout http://rutorrent-instantsearch.googlecode.com/svn/trunk/ rutorrent-instantsearch

# Add Oblivion Theme
wget --no-check-certificate https://raw.githubusercontent.com/jonnyboy/rtorrent-scripts/master/config/rutorrent-oblivion.zip -O $USER_HOME/compile/rutorrent/trunk/plugins/rutorrent-oblivion.zip
cd /home/jonnyboy/compile/rutorrent/trunk/plugins/
unzip rutorrent-oblivion.zip
rm rutorrent-oblivion.zip
echo "" | tee -a $USER_HOME/compile/rutorrent/trunk/rutorrent/css/style.css > /dev/null
echo "/* for Oblivion */" | tee -a $USER_HOME/compile/rutorrent/trunk/rutorrent/css/style.css > /dev/null
echo ".meter-value-start-color { background-color: #E05400 }" | tee -a $USER_HOME/compile/rutorrent/trunk/rutorrent/css/style.css > /dev/null
echo ".meter-value-end-color { background-color: #8FBC00 }" | tee -a $USER_HOME/compile/rutorrent/trunk/rutorrent/css/style.css > /dev/null
echo "::-webkit-scrollbar {width:12px;height:12px;padding:0px;margin:0px;}" | tee -a $USER_HOME/compile/rutorrent/trunk/rutorrent/css/style.css > /dev/null
perl -pi -e "s/\$defaultTheme \= \"\"\;/\$defaultTheme \= \"Oblivion\"\;/g" $USER_HOME/compile/rutorrent/trunk/rutorrent/plugins/theme/conf.php

# Add NFO Viewer
cd $USER_HOME/compile/rutorrent/trunk/plugins/
wget http://srious.biz/nfo.tar.gz
tar xzfv nfo.tar.gz
rm nfo.tar.gz

chown -R www-data:www-data $USER_HOME/compile/rutorrent/
chown -hRLH www-data:www-data /var/www/

