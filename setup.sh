#!/bin/bash

# 更新
apt update -y && apt install -y curl && apt install -y socat && apt install wget -y

# 交互式提示询问用户是否执行同步时间操作
read -p "是否执行同步时间操作？（y/n）：" sync_time
if [ "$sync_time" == "y" ]; then
  rm -rf /etc/localtime
  ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  localectl set-locale LC_TIME=en_GB.UTF-8
fi

# 交互式提示询问用户是否执行密码登录操作
read -p "是否执行密码登录操作？（y/n）：" password_login
if [ "$password_login" == "y" ]; then
  echo root:Aa199758 | sudo chpasswd root 
  sudo sed -i 's/^.*PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
  sudo sed -i 's/^.*PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
  sudo service ssh restart
fi

# 交互式提示询问用户是否需要安装docker
read -p "是否安装docker？（y/n）：" download_docker
if [ "$download_docker" == "y" ]; then
  curl -fsSL https://get.docker.com | bash -s docker
  curl -L "https://github.com/docker/compose/releases/download/v2.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
fi

# 交互式提示询问用户是否需要安装rclone
read -p "是否安装rclone？（y/n）：" download_rclone
if [ "$download_rclone" == "y" ]; then
  curl https://rclone.org/install.sh |bash
  apt install -y fuse3
  wget https://raw.githubusercontent.com/rookie2435/subscrible/master/accounts.tar.gz
  tar -zxvf accounts.tar.gz
  mkdir ~/.config/rclone
  cd ~/.config/rclone
  wget https://github.com/rookie2435/subscrible/blob/master/rclone.conf
  cd ~
fi

# 交互式提示询问用户是否安装nginx脚本
read -p "是否安装nginx脚本？（y/n）：" download_nginx
if [ "$download_nginx" == "y" ]; then
  # 下载 GitHub 上的 zip 压缩包
  wget https://raw.githubusercontent.com/rookie2435/subscrible/master/embyUrl.zip
  unzip embyUrl.zip
  cd embyUrl
  chmod +x run.sh
  ./run.sh
  cd ~
fi