#!/bin/bash
if [ $(mount | grep -c /data) != 1 ]
then
  echo "formatting and mounting disk2 to /data"
  yum -y install parted
  parted /dev/sdb mklabel msdos
  parted -s /dev/sdb mkpart primary ext4 512 100%
  mke2fs -F -t ext4 /dev/sdb
  mkdir /data
  e2label /dev/sdb /data
  echo /dev/sdb /data      ext4    noatime,nobarrier        1 2 >> /etc/fstab
  mount /data
  chown -R vagrant:vagrant /data/
else
  echo "/data already mounted"
fi
