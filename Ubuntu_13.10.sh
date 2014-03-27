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

clear
echo -e "\033[1;33mThis installs rtorrent, rutorrent, Nginx Web Server, php, php-fpm."
echo "and everything that is needed for your Ubuntu install."
echo -e "This will also completely remove apparmor.\033[0m"
echo
echo "This program is free software. You can redistribute it and/or modify it under the terms of the GNU General Public License"
echo "version 3, as published by the Free Software Foundation."
echo
echo "This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied"
echo "warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
echo "See the GNU General Public License for more details."
echo
echo "DISCLAIMER"
echo " # This script is made available to you without any express, implied or "
echo " # statutory warranty, not even the implied warranty of "
echo " # merchantability or fitness for a particular purpose, or the "
echo " # warranty of title. The entire risk of the use or the results from the use of this script remains with you."

echo "---------------------------------------------------------------------------------------------------------------"
echo
echo
echo "Do you Agree?"
echo "y=YES n=NO"
echo

read CHOICE
if [[ $CHOICE != "y" ]]; then
	exit
fi

# get working path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

clear
echo -e "\033[1;33mNginx needs to have the ip or FQDN, localhost will not work in most cases"
echo "Enter the ip or FQDN of this server."
echo -e "Detected IP's:\n\033[0m"
/sbin/ifconfig | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'
#curl -s icanhazip.com
netcat icanhazip.com 80 <<< $'GET / HTTP/1.0\nHost: icanhazip.com\n\n' | tail -n1

echo
read IPADDY

clear

function updateapt() {
	echo -e "\033[1;33mUpdating Apt Catalog\033[0m"
	apt-get -yqq update
}

updateapt

echo -e "\033[1;33mRemoving Apparmor\033[0m"
if [ -f "/etc/init.d/apparmor" ]; then
	/etc/init.d/apparmor stop
	/etc/init.d/apparmor teardown
	update-rc.d -f apparmor remove
fi
apt-get purge -yqq apparmor* apparmor-utils

echo -e "\033[1;33mAllow adding PPA's\033[0m"
apt-get install -yqq software-properties-common
apt-get install -yqq git subversion
apt-get install -yqq nano

#get user home folder
export USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

cp /etc/nanorc $USER_HOME/.nanorc
sed -i -e 's/^# include/include/' $USER_HOME/.nanorc
sed -i -e 's/^# set tabsize 8/set tabsize 4/' $USER_HOME/.nanorc
sed -i -e 's/^# set historylog/set historylog/' $USER_HOME/.nanorc
ln -sf $USER_HOME/.nanorc /root/

echo -e "\033[1;33mConfiguring OpenNTPD\033[0m"
if ! grep -q 'server 0.us.pool.ntp.org' "/etc/openntpd/ntpd.conf" ; then
	ntpdate pool.ntp.org
	apt-get install openntpd
fi
if [ -f "/etc/openntpd/ntpd.conf.orig" ]; then
	rm -f /etc/openntpd/ntpd.conf
else
	mv /etc/openntpd/ntpd.conf /etc/openntpd/ntpd.conf.orig
fi
echo 'server 0.us.pool.ntp.org' >> /etc/openntpd/ntpd.conf
echo 'server 1.us.pool.ntp.org' >> /etc/openntpd/ntpd.conf
echo 'server 2.us.pool.ntp.org' >> /etc/openntpd/ntpd.conf
echo 'server 3.us.pool.ntp.org' >> /etc/openntpd/ntpd.conf

# This allows for this server to be the network ntp server and you should point all other
# servers on the lan to this one, or comment this out
if ! grep -q 'listen on' "/etc/openntpd/ntpd.conf" ; then
	echo "listen on $IPADDY" >> /etc/openntpd/ntpd.conf
else
	sed -i -e "s/listen on.*$/listen on $IPADDY/" /etc/openntpd/ntpd.conf
fi
service openntpd restart

echo -e "\033[1;33mConfiguring ssh\033[0m"
sed -i -e 's/^#ClientAliveInterval.*$/ClientAliveInterval 30/' /etc/ssh/sshd_config
sed -i -e 's/^#TCPKeepAlive.*$/TCPKeepAlive yes/' /etc/ssh/sshd_config
sed -i -e 's/^#ClientAliveCountMax.*$/ClientAliveCountMax 99999/' /etc/ssh/sshd_config
touch /root/.Xauthority
touch $USER_HOME/.Xauthority
mkdir -p $USER_HOME/.local/share/
mkdir -p /root/.local/share/
service ssh restart

# set to non interactive
export DEBIAN_FRONTEND=noninteractive

#Installing Prerequirements
echo -e "\033[1;33mInstalling Nginx (engineX)\033[0m"
export nginx=stable
add-apt-repository -y ppa:nginx/$nginx
updateapt
apt-get install -yqq nginx-extras apache2-utils
mkdir -p /var/log/nginx
chmod 755 /var/log/nginx

echo -e "\033[1;33mInstalling PHP, PHP-FPM\033[0m"
add-apt-repository -y ppa:ondrej/php5
updateapt
apt-get install -yqq php5-fpm
apt-get install -yqq php5 php5-dev php-pear php5-gd php5-curl openssh-server openssl software-properties-common ca-certificates ssl-cert php5-json php5-xdebug

echo -e "\033[1;33mEditing PHP config files\033[0m"
sed -i 's/max_execution_time.*$/max_execution_time = 180/' /etc/php5/cli/php.ini
sed -i 's/max_execution_time.*$/max_execution_time = 180/' /etc/php5/fpm/php.ini
sed -i 's/memory_limit.*$/memory_limit = -1/' /etc/php5/cli/php.ini
sed -i 's/memory_limit.*$/memory_limit = -1/' /etc/php5/fpm/php.ini
sed -i 's/[;?]date.timezone.*$/date.timezone = America\/New_York/' /etc/php5/cli/php.ini
sed -i 's/[;?]date.timezone.*$/date.timezone = America\/New_York/' /etc/php5/fpm/php.ini
sed -i 's/[;?]cgi.fix_pathinfo.*$/cgi.fix_pathinfo = 0/' /etc/php5/fpm/php.ini
sed -i 's/[;?]cgi.fix_pathinfo.*$/cgi.fix_pathinfo = 0/' /etc/php5/cli/php.ini
sed -i 's/short_open_tag.*$/short_open_tag = Off/' /etc/php5/fpm/php.ini
sed -i 's/short_open_tag.*$/short_open_tag = Off/' /etc/php5/cli/php.ini
sed -i 's/display_errors.*$/display_errors = On/' /etc/php5/fpm/php.ini
sed -i 's/display_errors.*$/display_errors = On/' /etc/php5/cli/php.ini
sed -i 's/display_startup_errors.*$/display_startup_errors = On/' /etc/php5/fpm/php.ini
sed -i 's/display_startup_errors.*$/display_startup_errors = On/' /etc/php5/cli/php.ini

echo -e "\033[1;33mCommpile TMUX\033[0m"
# get system core count
cores=`cat /proc/cpuinfo | grep processor | wc -l`
((cores++))

apt-get install -yqq pkg-config libncurses5-dev libevent-dev
mkdir -p /home/$SUDO_USER/compile

if [ -d "$USER_HOME/compile/tmux" ]; then
	cd $USER_HOME/compile/tmux
	git pull
	make clean
else
	cd $USER_HOME/compile
	git clone https://github.com/ThomasAdam/tmux.git
	cd tmux
fi
./autogen.sh
./configure && make -j$cores
make install

if [ -f "config/tmux.conf" ]; then
	cp config/tmux.conf /home/$SUDO_USER/.tmux.conf
else
	wget --no-check-certificate https://raw.githubusercontent.com/jonnyboy/rtorrent-scripts/master/config/tmux.conf -O /home/$SUDO_USER/.tmux.conf
fi
if [ -f "config/rutorrent" ]; then
	cp config/rutorrent /etc/nginx/sites-available/rutorrent
else
	wget --no-check-certificate https://raw.githubusercontent.com/jonnyboy/rtorrent-scripts/master/config/rutorrent -O /etc/nginx/sites-available/rutorrent
fi
if [ -f "config/nginx.conf" ]; then
	cp config/nginx.conf /etc/nginx/nginx.conf
else
	wget --no-check-certificate https://raw.githubusercontent.com/jonnyboy/rtorrent-scripts/master/config/nginx.conf -O /etc/nginx/nginx.conf
fi

cores=`cat /proc/cpuinfo | grep processor | wc -l`
sed -i "s/^worker_processes.*$/worker_processes $cores;/" /etc/nginx/nginx.conf
sed -i "s/localhost/$IPADDY/" /etc/nginx/sites-available/rutorrent
if ! grep -q 'fastcgi_index index.php;' "/etc/nginx/fastcgi_params" ; then
	echo "" >> /etc/nginx/fastcgi_params
	echo "fastcgi_index index.php;" | tee -a /etc/nginx/fastcgi_params
fi
if ! grep -q 'fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' "/etc/nginx/fastcgi_params" ; then
	echo "fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;" | tee -a /etc/nginx/fastcgi_params
fi

if [ -f "/etc/nginx/sites-enabled/default" ]; then
	unlink /etc/nginx/sites-enabled/default
fi
ln -sf /etc/nginx/sites-available/rutorrent /etc/nginx/sites-enabled/rutorrent

echo -e "\033[1;33mInstalling Extras\033[0m"
unset DEBIAN_FRONTEND
apt-get install -yqq vnstat ifstat htop pastebinit pigz iperf tinyca unrar p7zip-full make screen cifs-utils nfs-common vlan
apt-get install -yqq libcurl4-openssl-dev libsigc++-2.0-dev libcppunit-dev
if [ ! -f "/bin/gzip.old" ]; then
	mv /bin/gzip /bin/gzip.old
fi
ln -sf /usr/bin/pigz /bin/gzip
sed -i 's/DAEMON=\/usr\/sbin\//DAEMON=\/usr\/bin\//' /etc/init.d/vnstat

# Update Certificates
wget -P /usr/share/ca-certificates/ --no-check-certificate https://certs.godaddy.com/repository/gd_intermediate.crt https://certs.godaddy.com/repository/gd_cross_intermediate.crt
update-ca-certificates
c_rehash

echo -e "\033[1;33mCleaning Up\033[0m"
apt-get -yqq autoclean
apt-get -yqq autoremove

#ssl
if [ ! -f "/etc/ssl/nginx/conf/server.key" ] || [ ! -f "/etc/ssl/nginx/conf/server.crt" ] || [ ! -f "/etc/ssl/nginx/conf/server.csr" ]; then
	echo -e "\033[1;33mCreating Self Signed Certificate\033[0m"
	mkdir -p /etc/ssl/nginx/conf
	cd /etc/ssl/nginx/conf
	echo -e "\033[1;33mEnter a Secure password\033[0m"
	openssl genrsa -des3 -out server.key 4096
	echo -e "\033[1;33mRe-enter a Secure password\033[0m"
	openssl req -new -key server.key -out server.csr
	cp server.key server.key.org
	echo -e "\033[1;33mRe-enter a Secure password\033[0m"
	openssl rsa -in server.key.org -out server.key
	openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt
fi
service php5-fpm stop
service php5-fpm start
service nginx restart
exit
echo -e "\033[1;33mCompiling and Installing rtorrent\033[0m"
cd $DIR
if [ -f "rtorrent-compile.sh" ]; then
	./rtorrent-compile.sh
else
	wget --no-check-certificate https://raw.githubusercontent.com/jonnyboy/rtorrent-scripts/master/rtorrent-compile.sh -O $DIR/rtorrent-compile.sh
	./rtorrent-compile.sh
fi

# chown your users folder
chown -R $SUDO_USER:$SUDO_USER $USER_HOME

echo -e "\033[1;33mInstalling rutorrent\033[0m"
if [ -f "install_rutorrent.sh" ]; then
	./install_rutorrent.sh
else
	wget --no-check-certificate https://raw.githubusercontent.com/jonnyboy/rtorrent-scripts/master/install_rutorrent.sh -O $DIR/install_rutorrent.sh
	./install_rutorrent.sh
fi

echo -e "\033[1;33mCreating VNSTAT Database for ETH0\033[0m"
rm /var/lib/vnstat/*
chmod o+x /usr/bin/vnstat
chmod o+wx /var/lib/vnstat/
sudo su $SUDO_USER -c "/usr/bin/vnstat -u -i eth0"

clear
echo -e "\033[1;33m-----------------------------------------------"
echo -e "\033[1;33mInstall Complete...."
echo
echo "rutorrent is installed and located at:"
echo "https://$IPADDY/rutorrent"
echo -e "\n\n\033[0m"
exit
