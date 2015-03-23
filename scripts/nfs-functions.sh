#!/bin/bash
source /vagrant/scripts/cm-api.sh
source /vagrant/scripts/cm-hosts-functions.sh

install_nfs_packages () {
  install_package nfs-utils
  install_package nfs-utils-lib
}

create_nfs_client_path () {
  nfs_path=$1
  owner=$2
  host_installed $(hostname)
  if [[ ! -d "$nfs_path" && "$host_is_installed" ]]; then
    mkdir -p "$nfs_path"
    chown -R $owner:$owner "$nfs_path"
  fi
}

install_nfs_share_master () {
  nfs_path=$1
  owner=$2
  clients=$3

  echo "Installing NFS packages."
  install_nfs_packages
  chkconfig nfs on
  service rpcbind start
  service nfs start

  echo "Sharing folder over NFS."
  create_nfs_client_path "$1" "$2"

  echo "# Created by vagrant provisioner" > /etc/exports
  for i in "${!clients[@]}"
  do
    echo "$nfs_path           ${clients[$i]}(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
  done
  exportfs -a
  service nfs restart
}

install_nfs_share_client () {
  nfs_path=$1
  owner=$2
  server=$3

  install_nfs_packages
  create_parcel_client_path

  if [ ! -d "/mnt/nfs$nfs_path" ]; then
    mkdir -p "/mnt/nfs$nfs_path"
    chown -R "$owner":"$owner" "/mnt/nfs$nfs_path"
    mount "$server:$nfs_path" "/mnt/nfs$nfs_path"
    rm -rf "$nfs_path"
    ln -s "/mnt/nfs$nfs_path" "$nfs_path"
    # add to fstabs
    echo "$server:$nfs_path /mnt/nfs$nfs_path   nfs      auto,noatime,nolock,bg,nfsvers=3,intr,tcp,actimeo=1800 0 0" >> /etc/fstab
  fi
  # view mounted dirs
  mount
}
