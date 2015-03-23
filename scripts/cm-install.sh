#!/bin/bash
source /vagrant/scripts/cm-api.sh
source /vagrant/scripts/cdh-parcels-functions.sh
source /vagrant/scripts/nfs-functions.sh

install_package "curl"

REPOCM=${REPOCM:-5}
CM_REPO_HOST=${CM_REPO_HOST:-archive.cloudera.com}
CM_MAJOR_VERSION=$(echo $REPOCM | sed -e 's/cm\\([0-9]\\).*/\\1/')
CM_VERSION=$(echo $REPOCM | sed -e 's/cm\\([0-9][0-9]*\\)/\\1/')
MACH=$(uname -m)

if [ $CM_MAJOR_VERSION -ge 4 ]; then

cat > /etc/yum.repos.d/cloudera-manager.repo <<EOF
[cloudera-manager]
# Packages for Cloudera Manager, Version $CM_MAJOR_VERSION , on Redhat or Centos 6 x86_64
name=Cloudera Manager
baseurl=http://$CM_REPO_HOST/cm$CM_MAJOR_VERSION/redhat/6/x86_64/cm/5/
gpgkey = http://$CM_REPO_HOST/cm$CM_MAJOR_VERSION/redhat/6/x86_64/cm/RPM-GPG-KEY-cloudera
enabled=1
gpgcheck=1
#proxy=_none_
#sslverify=0
EOF

  curl -s http://$CM_REPO_HOST/cm$CM_MAJOR_VERSION/redhat/6/x86_64/cm/RPM-GPG-KEY-cloudera > key
  rpm --import key
  rm key
fi

install_package "oracle-j2sdk1.7"
install_package "cloudera-manager-server-db-2"
install_package "cloudera-manager-server"
install_package "cloudera-manager-daemons"
install_package "jq"
service cloudera-scm-server-db initdb
service cloudera-scm-server-db start
service cloudera-scm-server start

# wait until server starts
sleep 30

if [[ $CM_USE_PARCELS = true ]]; then
  if [[ $CM_PARCELS_NFS = true ]]; then
    # setup NFS share for parcels
    install_nfs_share_master "$CM_PARCELS_NFS_CLIENT_PATH" "cloudera-scm" "$CM_PARCELS_NFS_CLIENTS"
  fi
fi

# Say Hello to make sure the manager is running
echo_cloudera_manager
if [[ $CM_ECHO = "\"Hello, World!\"" ]]; then
  echo "Beginning the Cloudera Enterprise Trial."
  data='{}'
  cm_api_post "/cm/trial/begin" $data
else
  echo "Cloudera manager not running, please wait for server to start and re-rpovision."
fi
