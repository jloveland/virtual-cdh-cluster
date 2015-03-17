#!/bin/bash
source /vagrant/scripts/cm-api.sh

yum install -y curl

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

yum install -y oracle-j2sdk1.7 cloudera-manager-server-db-2 cloudera-manager-server cloudera-manager-daemons jq
service cloudera-scm-server-db initdb
service cloudera-scm-server-db start
service cloudera-scm-server start

# wait until server starts
sleep 10

echo "Beginning the Cloudera Enterprise Trial."
data='{}'
cm_api_post "/cm/trial/begin" $data
