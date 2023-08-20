#!/bin/bash


echo -e "更新"
  apt update -y && apt install -y curl && apt install -y socat && apt install wget -y && apt install unzip

echo -e "同步时间"
  rm -rf /etc/localtime
  ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  localectl set-locale LC_TIME=en_GB.UTF-8

echo -e "安装docker"
  curl -fsSL https://get.docker.com | bash -s docker
  curl -L "https://github.com/docker/compose/releases/download/v2.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose

echo -e "安装rclone"
  curl https://rclone.org/install.sh |bash
  apt install -y fuse3
  mkdir ~/.config/rclone
  cd ~/.config/rclone
  wget https://github.com/rookie2435/subscrible/blob/master/emby2/rclone.conf
  cd ~

echo -e "安装emby"
  wget https://github.com/MediaBrowser/Emby.Releases/releases/download/4.7.13.0/emby-server-deb_4.7.13.0_arm64.deb
  dpkg -i emby-server-deb_4.7.13.0_amd64.deb
  systemctl stop emby-server
  rm -rf /opt/emby-server
  rm -rf /var/lib/emby
  rclone copy -P peach:backup/server.tar.gz /opt
  cd /opt
  tar -zxvf  server.tar.gz
  rclone copy -P peach:backup/emby2.tar.gz /var/lib
  cd /var/lib
  tar -zxvf  emby2.tar.gz  
  rclone copy -P peach:backup/metadata.tar.gz /var/lib/emby  
  cd /var/lib/emby
  tar -zxvf  metadata.tar.gz  
  systemctl start emby-server
  cd ~

echo -e "安装nginx"
  wget https://raw.githubusercontent.com/rookie2435/subscrible/master/emby2/embyLinear.zip
  unzip embyLinear.zip
  cd embyLinear
  docker compose -d
  cd ~

echo -e "安装jellyseer"
  wget https://raw.githubusercontent.com/rookie2435/subscrible/master/emby2/jellyseer.zip
  unzip jellyseer.zip
  cd jellyseer
  docker compose -d
  cd ~

echo -e "挂载网盘"

echo "[Unit]
Description = rclone mount for mnt
AssertPathIsDirectory=/mnt
Wants=network-online.target
After=network-online.target
[Service]
Type=notify
KillMode=none
Restart=on-failure
RestartSec=5
User = root
ExecStart = /usr/bin/rclone mount union: /mnt --use-mmap --umask 000 --default-permissions --vfs-cache-mode minimal --no-check-certificate --allow-other --allow-non-empty 
ExecStop=/bin/fusermount -u /mnt
Restart = on-abort
[Install]
WantedBy = multi-user.target" > /etc/systemd/system/rclone-mnt.service
  sleep 1s
  systemctl enable rclone-mnt.service
  systemctl start rclone-mnt.service 

echo -e "启动直链服务"

echo "[Unit]
Description = rclone mount for http
[Service]
ExecStart = /usr/bin/rclone serve http union: -v --vfs-cache-mode full --vfs-cache-max-age 1h --buffer-size 256M --vfs-read-ahead 512M --vfs-read-chunk-size 32M --vfs-read-chunk-size-limit off --vfs-cache-max-size 100G --no-modtime --fast-list --addr :10000
Restart=on-abortlway
[Install]
WantedBy = multi-user.target" > /etc/systemd/system/rclone-http.service
  sleep 1s
  systemctl enable rclone-http.service 
  systemctl start rclone-http.service 