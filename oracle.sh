#!/bin/bash

echo "更新"
  apt update -y && apt install -y curl && apt install -y socat && apt install wget -y 

echo "开启bbr"
  wget -N --no-check-certificate "https://github.000060000.xyz/tcp.sh"
  sleep 2s
  chmod +x /root/tcp.sh
  bash /root/tcp.sh

echo "同步时间"
  rm -rf /etc/localtime
  ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  sleep 2s
  localectl set-locale LC_TIME=en_GB.UTF-8
  
echo "安装docker"
  curl -fsSL https://get.docker.com | bash -s docker
  curl -L "https://github.com/docker/compose/releases/download/v2.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sleep 2s
  chmod +x /usr/local/bin/docker-compose

echo "安装nginx"
  wget https://raw.githubusercontent.com/rookie2435/subscrible/master/embyUrl1.tar.gz
  tar -zxvf embyUrl1.tar.gz
  rm -rf embyUrl1.tar.gz
  cd embyUrl
  /usr/local/bin/docker-compose up -d

echo "挂载网盘"
echo "[Unit]
Description = Plexdrive mount for peach

[Service]
ExecStart = /usr/local/bin/plexdrive mount  -c /home/.peach \
--drive-id=0AOQD3sPHjKcGUk9PVA  \
--cache-file=/home/.peach/cache.bolt -o allow_other  -v 4 \
--refresh-interval=1m  --chunk-check-threads=6  \
--chunk-load-threads=16 --chunk-load-ahead=10 \
--max-chunks=1024  --chunk-size=2M    /mnt
Restart=always
User=root
MemoryHigh=80%
OOMScoreAdjust=-1000

[Install]
WantedBy = multi-user.target" > /etc/systemd/system/rclone-mnt.service
  sleep 1s
  systemctl enable rclone-mnt.service
  systemctl start rclone-mnt.service 