#!/bin/bash



echo "安装nginx"
  wget https://raw.githubusercontent.com/rookie2435/subscrible/master/embyUrl.tar.gz
  tar -zxvf embyUrl.tar.gz
  rm -rf embyUrl.tar.gz
  cd embyUrl
  /usr/local/bin/docker-compose up -d

