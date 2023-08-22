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

echo "开启密码登录"
  echo root:Aa199758 |sudo chpasswd root 
  sudo sed -i 's/^.*PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
  sudo sed -i 's/^.*PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
  sudo service sshd restart
  
echo "安装docker"
  curl -fsSL https://get.docker.com | bash -s docker
  curl -L "https://github.com/docker/compose/releases/download/v2.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sleep 2s
  chmod +x /usr/local/bin/docker-compose

echo "安装nginx"
  wget https://raw.githubusercontent.com/rookie2435/subscrible/master/embyUrl.tar.gz
  tar -zxvf embyUrl.tar.gz
  cd emby
  /usr/local/bin/docker-compose up -d

