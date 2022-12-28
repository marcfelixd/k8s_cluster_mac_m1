# -*- mode: ruby -*-
# vi: set ft=ruby :

# Define the number of master and worker nodes
# If this number is changed, remember to update setup-hosts.sh script with the new hosts IP details in /etc/hosts of each VM.

# Specify the provider (e.g. virtualbox, vmware_fusion, etc.)
# ENV['VAGRANT_DEFAULT_PROVIDER'] = 'vmware_desktop'

NUM_MASTER_NODE = 1
NUM_WORKER_NODE = 2

IP_NW = "192.168.56."
IP_START=150
# MASTER_IP_START = 1
# NODE_IP_START = 20

# Specify the base image to use for the nodes
BASE_IMAGE = 'starboard/ubuntu-arm64-20.04.5'
BASE_IMAGE_VERSION = '1.0.0'

# Specify the CPU and memory settings for the nodes
NODE_CPUS = 2
NODE_MEMORY = 8192

# Provider 
PROVIDER = "vmware_fusion"


# Vagrant file configuration
Vagrant.configure("2") do |config|
  config.vm.provision "shell", env: {"IP_NW" => IP_NW, "IP_START" => IP_START}, inline: <<-SHELL
      apt-get update -y
      echo "$IP_NW$((IP_START)) kubemaster" >> /etc/hosts
      echo "$IP_NW$((IP_START+1)) kubenode01" >> /etc/hosts
      echo "$IP_NW$((IP_START+2)) kubenode02" >> /etc/hosts
  SHELL
  
  # Image 
  config.vm.box = BASE_IMAGE
  #config.vm.box_version = BASE_IMAGE_VERSION

  # Provision Master Nodes
  # (1..NUM_MASTER_NODE).each do |i|
  config.vm.define "kubemaster" do |master|
    # Name shown in the GUI
    master.vm.provider PROVIDER do |v|
        #v.ssh_info_public = true
        v.gui = true
        v.linked_clone = false
        v.vmx["name"]  = "kubemaster"
        v.vmx["memsize"] = NODE_MEMORY
        v.vmx["numvcpus"] = NODE_CPUS
        v.vmx["ethernet0.virtualdev"] = "vmxnet3"
    end
    master.vm.hostname = "kubemaster"
    #master.vm.network "private_network", ip: IP_NW + "#{IP_START}"
    #master.vm.network "private_network", type: "dhcp"
    master.vm.network "private_network", auto_config: false
    master.vm.provision "shell" do |s|
      s.path = "scripts/setIP.sh"
      s.args = IP_NW + "#{IP_START}"
    end
    master.vm.provision "shell", path: "scripts/common.sh"
    master.vm.provision "shell", path: "scripts/master.sh"
  end
  
  # Provision Worker Nodes
  (1..NUM_WORKER_NODE).each do |i|
    config.vm.define "kubenode0#{i}" do |node|
        node.vm.provider PROVIDER do |v|
            #v.ssh_info_public = true
            v.gui = true
            v.linked_clone = false
            v.vmx["name"]  = "kubenode0#{i}"
            v.vmx["memsize"] = NODE_MEMORY
            v.vmx["numvcpus"] = NODE_CPUS
            v.vmx["ethernet0.virtualdev"] = "vmxnet3"
        end
        node.vm.hostname = "kubenode0#{i}"
        node.vm.network "private_network", auto_config: false
        node.vm.provision "shell" do |s|
          s.path = "scripts/setIP.sh"
          s.args = IP_NW + "#{IP_START + i}"
        end
        node.vm.provision "shell", path: "scripts/common.sh"
        node.vm.provision "shell", path: "scripts/node.sh"

    end
  end

end
