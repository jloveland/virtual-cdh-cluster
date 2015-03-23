Vagrant.configure("2") do |config|

  # Define base image
  config.vm.box = "centos65-x86_64-20140116"
  # config.vm.box_download_insecure = "true"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"
  master_disk2 = '.vagrant/disk-images/masterdisk2.vmdk'
  slave1_disk2 = '.vagrant/disk-images/slave1_disk2.vmdk'
  slave2_disk2 = '.vagrant/disk-images/slave2_disk2.vmdk'
  slave3_disk2 = '.vagrant/disk-images/slave3_disk2.vmdk'


  # Manage /etc/hosts on host and VMs
  config.hostmanager.enabled = false
  config.hostmanager.manage_host = true
  config.hostmanager.include_offline = true
  config.hostmanager.ignore_private_ip = false

 # TODO: When destroying VMs, it doesn't clean up disk2.
  config.vm.define :master do |master|
    master.vm.provider :virtualbox do |v|
      v.name = "nasa-orion-1"
      v.customize ["modifyvm", :id, "--memory", "2048"]
      unless File.exist?(master_disk2)
        v.customize ['createhd', '--filename', master_disk2, '--size', 20 * 1024]
      end
      v.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', master_disk2]
    end
    master.vm.network :private_network, ip: "10.211.55.100"
    master.vm.hostname = "nasa-orion-1"
    master.vm.provision :shell, path: "scripts/add-disk.sh"
    master.vm.provision :shell, path: "scripts/host-extras.sh"
    master.vm.provision :shell, path: "scripts/hosts-file.sh"
    master.vm.provision :hostmanager
    master.vm.provision :shell, path: "scripts/cm-install.sh"
    master.vm.provision :shell, path: "scripts/cdh-repo-config.sh"
    # install local parcel repo if specified in cm-api.sh
    master.vm.provision :shell, path: "scripts/cdh-local-parcels-repo.sh"
  end

  config.vm.define :slave1 do |slave1|
    slave1.vm.box = "centos65-x86_64-20140116"
    slave1.vm.provider :virtualbox do |v|
      v.name = "nasa-orion-2"
      v.customize ["modifyvm", :id, "--memory", "1024"]
      unless File.exist?(slave1_disk2)
        v.customize ['createhd', '--filename', slave1_disk2, '--size', 20 * 1024]
      end
      v.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', slave1_disk2]
    end
    slave1.vm.network :private_network, ip: "10.211.55.101"
    slave1.vm.hostname = "nasa-orion-2"
    slave1.vm.provision :shell, path: "scripts/add-disk.sh"
    slave1.vm.provision :shell, path: "scripts/hosts-file.sh"
    slave1.vm.provision :shell, path: "scripts/host-extras.sh"
    slave1.vm.provision :hostmanager
    slave1.vm.provision :shell, path: "scripts/cdh-repo-config.sh"
  end

  config.vm.define :slave2 do |slave2|
    slave2.vm.box = "centos65-x86_64-20140116"
    slave2.vm.provider :virtualbox do |v|
      v.name = "nasa-orion-3"
      v.customize ["modifyvm", :id, "--memory", "1024"]
      unless File.exist?(slave2_disk2)
        v.customize ['createhd', '--filename', slave2_disk2, '--size', 20 * 1024]
      end
      v.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', slave2_disk2]
    end
    slave2.vm.network :private_network, ip: "10.211.55.102"
    slave2.vm.hostname = "nasa-orion-3"
    slave2.vm.provision :shell, path: "scripts/add-disk.sh"
    slave2.vm.provision :shell, path: "scripts/hosts-file.sh"
    slave2.vm.provision :shell, path: "scripts/host-extras.sh"
    slave2.vm.provision :hostmanager
    slave2.vm.provision :shell, path: "scripts/cdh-repo-config.sh"
  end

  config.vm.define :slave3 do |slave3|
    slave3.vm.box = "centos65-x86_64-20140116"
    slave3.vm.provider :virtualbox do |v|
      v.name = "nasa-orion-4"
      v.customize ["modifyvm", :id, "--memory", "1024"]
      unless File.exist?(slave3_disk2)
        v.customize ['createhd', '--filename', slave3_disk2, '--size', 20 * 1024]
      end
      v.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', slave3_disk2]
    end
    slave3.vm.network :private_network, ip: "10.211.55.103"
    slave3.vm.hostname = "nasa-orion-4"
    slave3.vm.provision :shell, path: "scripts/add-disk.sh"
    slave3.vm.provision :shell, path: "scripts/hosts-file.sh"
    slave3.vm.provision :shell, path: "scripts/host-extras.sh"
    slave3.vm.provision :hostmanager
    slave3.vm.provision :shell, path: "scripts/cdh-repo-config.sh"
    # deploy hosts with cloudera manager agent (takes time to install..)
    slave3.vm.provision :shell, path: "scripts/cm-hosts.sh"
    # add hosts to mars-development cluster
    slave3.vm.provision :shell, path: "scripts/cm-cluster.sh"
    # deploy parcels after cluster is available
    slave3.vm.provision :shell, path: "scripts/cdh-parcels.sh"
    # provision cdh services
    slave3.vm.provision :shell, path: "scripts/cdh-zookeeper.sh"
    # slave3.vm.provision :shell, path: "scripts/cm-cluster-firstrun.sh"
  end

end
