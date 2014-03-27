rtorrent-scripts
================

My scripts for installing and running rtorrent and rutorrent on ubuntu. These scripts assume a server install with only ssh installed. The combination of nginx, php-fpm and httprpc make this a very speedy webui, even when managing 1000's of torrents.

To run:

```
git clone https://github.com/jonnyboy/rtorrent-scripts.git
cd rtorrent-scripts
sudo ./Ubuntu_13.10.sh
```
or
```
wget --no-check-certificate https://raw.githubusercontent.com/jonnyboy/rtorrent-scripts/master/Ubuntu_13.10.sh
sudo chmod +x Ubuntu_13.10.sh
sudo ./Ubuntu_13.10.sh
```

---
###### Original ideas and credits go to [Notos](https://github.com/Notos/seedbox-from-scratch)
###### additional rtorrent.rc options from [bryanjswift](https://gist.github.com/bryanjswift/1525912)
