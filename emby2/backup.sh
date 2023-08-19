#!/bin/sh
rclone delete peach:backup/emby2.tar.gz
cd /var/lib
rm -rf /var/lib/emby/cache
tar -czvf emby2.tar.gz --exclude=metadata  emby
rclone copy -P emby2.tar.gz peach:backup
rm -rf emby2.tar.gz
