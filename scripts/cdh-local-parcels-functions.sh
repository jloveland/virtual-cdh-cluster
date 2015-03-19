#!/bin/bash
source /vagrant/scripts/cm-api.sh

add_local_parcels_config () {
  echo "Adding local parcel repo to cloudera manager configuration"
  data=$(jq . /vagrant/scripts/data/parcels-local-repo.json -c)
  cm_api_put "/cm/config" $data
  # TODO: check if we need to set a proxy
}

add_local_parcels_folder () {
  # create repo folder
  repos_folder=/data/repos
  mkdir -p $repos_folder/cdh5/parcels/latest
  mkdir -p $repos_folder/impala/parcels/latest
  mkdir -p $repos_folder/search/parcels/latest
  mkdir -p $repos_folder/spark/parcels/latest
  mkdir -p $repos_folder/navigator-keytrustee5/parcels/latest
  mkdir -p $repos_folder/sqoop-connectors/parcels/latest
  mkdir -p $repos_folder/accumulo-c5/parcels/latest
}

install_repo_server () {
  echo "Installing apache server, adding repo.conf and starting httpd."
  install_package "httpd"
  # setup permissions to write to /data dir
  chmod -R 755 /data

cat >/etc/httpd/conf.d/repos.conf <<EOL
Alias /repos /data/repos
<Directory /data/repos>
Order allow,deny
Allow from all
</Directory>
EOL

  service httpd start
}
