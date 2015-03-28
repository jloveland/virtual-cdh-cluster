# A Virtual Hadoop cluster provisioned by the Cloudera Manager

Leverage this project to provision a local, distributed, virtualized Hadoop cluster on Centos using [Vagrant](https://www.vagrantup.com/) and the [Cloudera Manager](http://www.cloudera.com/content/cloudera/en/products-and-services/cloudera-enterprise/cloudera-manager.html) [REST API]() for installing the [Cloudera Enterprise](http://www.cloudera.com/content/cloudera/en/products-and-services/cloudera-enterprise.html) or [Cloudera Express](http://www.cloudera.com/content/cloudera/en/products-and-services/cloudera-express.html) version of [CDH](http://www.cloudera.com/content/cloudera/en/products-and-services/cdh.html).

Thanks to [dandydev](http://dandydev.net/blog/installing-virtual-hadoop-cluster) for his ideas on how to provision the Cloudera Manager and using Vagrant.

Thanks to Cloudera who provides the Cloudera Manager and the RESTful web services API that enables us to deploy and manage a Hadoop cluster in an automated way.

## Cluster Details

### Default Cluster
The following *Default* cluster configuration is defined in the `Vagrantfile`. All VMs use a Centos 6.5 base box. This configuration requires at least 10GB of free RAM. You can remove slave nodes as needed, it will just be less performant.

* **Master node**
  * 4GB of RAM
  * Local Parcel Repo or Yum Repo
  * Cloudera Manager
  * Hue
  * Provisioning NameNodes, HBase Master, Spark Master, ResourceManager
* **3 Slave nodes**
  * 2GB of RAM
  * Provisioning Datanodes, Zookeeper, Region Servers, Node Manager

### TODO: Large Cluster
The following *Large* cluster configuration is defined in the `Vagrantfile`. All VMs use a Centos 6.5 base box. This configuration requires at least 12GB of free RAM. You can remove slave nodes as needed, it will just be less performant.

* **Manager node**
  * 1GB of RAM
  * Local Parcel Repo or Yum Repo
  * Cloudera Manager
  * Hue
* **Master node**
  * 5GB of RAM,
  * Provisioning NameNodes, HBase Master, Spark Master, ResourceManager
* **3 Slave nodes**
  * 2GB of RAM
  * Provisioning Datanodes, Zookeeper, Region Servers, Node Manager

### TODO: Docker Cluster

* **Vagrant VM**
* **Docker Containers**

## Prerequisites

This requires [VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/) to be installed on your machine before we proceed.

Then install the Vagrant [Hostmanager plugin](https://github.com/smdahlen/vagrant-hostmanager)

```bash
$ vagrant plugin install vagrant-hostmanager
```

## Installation
To fully provision a cluster, you will need to re-run vagrant provision multiple times. The scripts check if the system meets the requirements before proceeding. (i.e. HBase requires HDFS and Zookeeper) In the end, installation will require running `vagrant provision` 5 times will take ~30 minutes.

### Clone the repo

```bash
$ git clone https://github.com/jloveland/virtual-cdh-cluster.git
```

### Provision
Hostmanager will prompt you for your password so it can modify your `/etc/hosts` file. This adds all the machines so that your browser can resolve the machines

```bash
$ cd virtual-cdh-cluster
$ vagrant up
```

Go to the [Cloudera Manager web console](http://nasa-orion-1:7180) to see the progress of your installation.

### Re-provision
```bash
$ vagrant provision
```
Once complete, you can start locally testing your Hadoop projects!
