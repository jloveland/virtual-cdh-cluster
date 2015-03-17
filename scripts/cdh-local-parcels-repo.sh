#!/bin/bash
source /vagrant/scripts/cm-api.sh
source /vagrant/scripts/cdh-parcels-functions.sh
source /vagrant/scripts/cdh-local-parcels-functions.sh

if [[ $CM_USE_PARCELS == true && $CM_LOCAL_PARCELS_REPO == true ]]; then
echo "Downloading parcels from cloudera to local parcel repo..this could take a while.."
add_local_parcels_config

echo "Installing local parcel repo"
yum install -y httpd
chmod -R 755 /data
cat >/etc/httpd/conf.d/repos.conf <<EOL
Alias /repos /data/repos
<Directory /data/repos>
Order allow,deny
Allow from all
</Directory>
EOL
service httpd start

# create repo folder
repos_folder=/data/repos
mkdir -p $repos_folder/cdh5/parcels/latest
mkdir -p $repos_folder/impala/parcels/latest
mkdir -p $repos_folder/search/parcels/latest
mkdir -p $repos_folder/spark/parcels/latest
mkdir -p $repos_folder/navigator-keytrustee5/parcels/latest
mkdir -p $repos_folder/sqoop-connectors/parcels/latest
mkdir -p $repos_folder/accumulo-c5/parcels/latest

# TODO: make this an array of parcels and interate, get this from the cloudera manager api
if [[ $CLUSTER_NAME == "mars-development" ]]; then
  echo "Getting Parcel List for $CLUSTER_NAME cluster"
  get_parcels_array

  for key in "${!myarray[@]}"
  do
    product=$(echo ${myarray[$key]} | jq -r '.product')
    version=$(echo ${myarray[$key]} | jq -r '.version')
    stage=$(echo ${myarray[$key]} | jq -r '.stage')
    echo $stage
    # Download the parcels using curl
  done


  declare -A repos=(
  ["cdh5"]="CDH-5.3.2-1.cdh5.3.2.p0.10-el6.parcel"
  ["impala"]="dog"
  )

  echo "${repos["cdh5"]}"
  for repos in "${!repos[@]}"; do echo "$repo - ${repos["$repo"]}"; done

  repo=cdh5
  cd $repos_folder/$repo/parcels/latest/
  parcel="CDH-5.3.2-1.cdh5.3.2.p0.10-el6.parcel"
  if [ ! -f $parcel ]; then curl -O http://archive.cloudera.com/$repo/parcels/latest/$parcel ; fi

  curl -O http://archive.cloudera.com/cdh5/parcels/latest/CDH-5.3.2-1.cdh5.3.2.p0.10-el6.parcel.sha1
  curl -O http://archive.cloudera.com/cdh5/parcels/latest/manifest.json
  cd /data/repos/impala/parcels/latest/
  curl -O http://archive-primary.cloudera.com/impala/parcels/latest/IMPALA-2.1.0-1.impala2.0.0.p0.1995-el6.parcel
  curl -O http://archive-primary.cloudera.com/impala/parcels/latest/manifest.json
  cd /data/repos/search/parcels/latest/
  curl -O http://archive.cloudera.com/search/parcels/latest/SOLR-1.3.0-1.cdh4.5.0.p0.9-el6.parcel
  curl -O http://archive.cloudera.com/search/parcels/latest/SOLR-1.3.0-1.cdh4.5.0.p0.9-el6.parcel.sha1
  curl -O http://archive.cloudera.com/search/parcels/latest/manifest.json
  cd /data/repos/spark/parcels/latest/
  curl -O http://archive.cloudera.com/spark/parcels/latest/SPARK-0.9.0-1.cdh4.6.0.p0.98-el6.parcel
  curl -O http://archive.cloudera.com/spark/parcels/latest/SPARK-0.9.0-1.cdh4.6.0.p0.98-el6.parcel.sha1
  curl -O http://archive.cloudera.com/spark/parcels/latest/manifest.json
  cd /data/repos/navigator-keytrustee5/parcels/latest
  curl -O http://archive.cloudera.com/navigator-keytrustee5/parcels/latest/KEYTRUSTEE-5.3.0-0.cdh5.3.0.p202-el6.parcel
  curl -O http://archive.cloudera.com/navigator-keytrustee5/parcels/latest/KEYTRUSTEE-5.3.0-0.cdh5.3.0.p202-el6.parcel.sha1
  curl -O http://archive.cloudera.com/navigator-keytrustee5/parcels/latest/manifest.json
  cd /data/repos/sqoop-connectors/parcels/latest
  curl -O http://archive.cloudera.com/sqoop-connectors/parcels/latest/SQOOP_NETEZZA_CONNECTOR-1.2c5-el6.parcel
  curl -O http://archive.cloudera.com/sqoop-connectors/parcels/latest/SQOOP_NETEZZA_CONNECTOR-1.2c5-el6.parcel.sha1
  curl -O http://archive.cloudera.com/sqoop-connectors/parcels/latest/SQOOP_TERADATA_CONNECTOR-1.3c5-el6.parcel
  curl -O http://archive.cloudera.com/sqoop-connectors/parcels/latest/SQOOP_TERADATA_CONNECTOR-1.3c5-el6.parcel.sha1
  curl -O http://archive.cloudera.com/sqoop-connectors/parcels/latest/manifest.json
  cd /data/repos/accumulo-c5/parcels/latest/
  curl -O http://archive-primary.cloudera.com/accumulo-c5/parcels/latest/ACCUMULO-1.6.0-1.cdh5.1.0.p0.51-el6.parcel
  curl -O http://archive-primary.cloudera.com/accumulo-c5/parcels/latest/ACCUMULO-1.6.0-1.cdh5.1.0.p0.51-el6.parcel.sha1
  curl -O http://archive-primary.cloudera.com/accumulo-c5/parcels/latest/manifest.json
  # TODO: curl the other parces down

  service httpd restart
  echo "Successully added local parcel repo"
else
  echo "cluster not ready yet, please provision again"
fi

fi
