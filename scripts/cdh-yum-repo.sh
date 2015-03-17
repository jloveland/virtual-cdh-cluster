#!/bin/bash
source /vagrant/scripts/cm-api.sh

if [[ $CM_USE_PARCELS == false ]]; then
echo " Installing CDH5 yum repo."
yum install -y curl

REPOCM=${REPOCM:-5}
CM_REPO_HOST=${CM_REPO_HOST:-archive.cloudera.com}
CM_MAJOR_VERSION=$(echo $REPOCM | sed -e 's/cm\\([0-9]\\).*/\\1/')
CM_VERSION=$(echo $REPOCM | sed -e 's/cm\\([0-9][0-9]*\\)/\\1/')
MACH=$(uname -m)

if [ $CM_MAJOR_VERSION -ge 4 ]; then
  cat > /etc/yum.repos.d/cloudera-cdh5.repo <<EOF
[cloudera-cdh5]
# Packages for Cloudera's Distribution for Hadoop CDH5, Version $CM_MAJOR_VERSION , on Redhat or Centos 6 x86_64
name=Cloudera's Distribution for Hadoop, Version 5
baseurl=http://$CM_REPO_HOST/cdh$CM_MAJOR_VERSION/redhat/6/x86_64/cdh/5/
gpgkey = http://$CM_REPO_HOST/cdh$CM_MAJOR_VERSION/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera
enabled=1
gpgcheck=1
#proxy=_none_
#sslverify=0
EOF
curl -s http://$CM_REPO_HOST/cdh$CM_MAJOR_VERSION/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera > key
rpm --import key
rm key
fi

fi
