# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

inventory_file = ENV['INVENTORY_FILE'] || 'hosts.yml'

inventory = YAML.load_file(inventory_file)
inventory_vars = inventory['all']['vars']
inventory_groups = inventory['all']['children']

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_check_update = false

  config.vm.synced_folder "./vagrant-data/", "/vagrant", type: "rsync"

  # Define and provision name node

  config.vm.define "namenode" do |namenode|
    h = inventory_groups['namenode']['hosts']['namenode']
    namenode.vm.network "private_network", ip: h['ipv4_address']
    namenode.vm.provider "virtualbox" do |vb|
      vb.name = h['fqdn']
      vb.memory = 1024
    end
  end

  # Define and provision data nodes

  inventory_groups['datanode']['hosts'].keys.each do |machine_name|
    config.vm.define machine_name do |machine|
      h = inventory_groups['datanode']['hosts'][machine_name]
      machine.vm.network "private_network", ip: h['ipv4_address']
      machine.vm.provider "virtualbox" do |vb|
         vb.name = h['fqdn']
         vb.memory = 2560
      end
    end
  end

  # Define and provision manager node

  config.vm.define "manager" do |manager|
    h = inventory_groups['manager']['hosts']['manager']
    manager.vm.network "private_network", ip: h['ipv4_address']
    manager.vm.provider "virtualbox" do |vb|
      vb.name = h['fqdn']
      vb.memory = 1536
    end

  end 

  # Provision (common)
  
  config.vm.provision "file", source: "keys/id_rsa", destination: ".ssh/id_rsa"
  config.vm.provision "shell", path: "scripts/copy-key.sh", privileged: false
  config.vm.provision "file", source: "files/profile", destination: ".profile"
  config.vm.provision "file", source: "files/vimrc", destination: ".vimrc"
  config.vm.provision "shell", inline: <<-EOD
    apt-get update && apt-get install -y sudo python
  EOD
  
  config.vm.provision "setup-basic", type: "ansible" do |ansible| 
    ansible.playbook = 'play-basic.yml'
    ansible.become = true
    ansible.become_user = 'root'
    ansible.inventory_path = inventory_file
    ansible.verbose = true
  end
  
  config.vm.provision "setup-hadoop", type: "ansible" do |ansible| 
    ansible.playbook = 'play-hadoop.yml'
    ansible.become = true
    ansible.become_user = 'root'
    ansible.inventory_path = inventory_file
    ansible.verbose = true
  end
  
  config.vm.provision "setup-spark", type: "ansible" do |ansible| 
    ansible.playbook = 'play-spark.yml'
    ansible.become = true
    ansible.become_user = 'root'
    ansible.inventory_path = inventory_file
    ansible.verbose = true
  end
 
end
