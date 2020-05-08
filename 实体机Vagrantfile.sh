# -*- mode: ruby -*-
# vi: set ft=ruby :
$script = <<SCRIPT
   (echo 'admin217'; sleep 1; echo 'admin217') | sudo passwd 'root'
    echo nameserver 114.114.114.114 > /etc/resolv.conf
    sed  -i  's/PermitRootLogin/#PermitRootLogin/g' /etc/ssh/sshd_config
    sed  -i  's/PasswordAuthentication/#PasswordAuthentication/g' /etc/ssh/sshd_config
    systemctl restart sshd
SCRIPT


Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.ssh.insert_key=false #不更改密钥
  config.vm.provision :shell, :inline => $script
   config.vm.provision "ansible" do |ansible|
   ansible.verbose = "v"
   ansible.playbook = "/root/centos7/main.yml"
   end


  config.vm.define :docker do |docker|
	  docker.vm.network "private_network", ip: "192.168.122.10"
                  
	  docker.vm.hostname = "docker"
	  docker.vm.provider "libvirt" do |va|
		  va.memory = "4096"
		  va.cpus = 1
		
	  end
  end	  
  config.vm.define :zabbix do |zabbix|
	  zabbix.vm.network "private_network", ip: "192.168.122.11"
	  zabbix.vm.hostname = "zabbix"
	  zabbix.vm.provider "libvirt" do |vb|
		  vb.memory = "4096"
		  vb.cpus = 1
		 
	 end
  end
  config.vm.define :glusterFS1 do |glusterFS1|
	  glusterFS1.vm.network "private_network", ip: "192.168.122.12"
	  glusterFS1.vm.hostname = "glusterFS1"
	  glusterFS1.vm.provider "libvirt" do |vc|
		  vc.memory = "4096"
		  vc.cpus = 1
     end
  end
  config.vm.define :glusterFS2 do |glusterFS2|
	  glusterFS2.vm.network "private_network", ip: "192.168.122.13"
	  glusterFS2.vm.hostname = "glusterFS2"
	  glusterFS2.vm.provider "libvirt" do |vd|
		  vd.memory = "4096"
		  vd.cpus = 1	  
     end
  end
   config.vm.define :kms do |kms|
	  kms.vm.network "private_network", ip: "192.168.122.14"
	  kms.vm.hostname = "kms"
	  kms.vm.provider "libvirt" do |ve|
		  ve.memory = "4096"
		  ve.cpus = 1
     end
  end
   config.vm.define :openvpn do |openvpn|
	  openvpn.vm.network "private_network", ip: "192.168.122.15"
	  openvpn.vm.hostname = "openvpn"
	  openvpn.vm.provider "libvirt" do |vf|
		  vf.memory = "4096"
		  vf.cpus = 1
     end
  end
   config.vm.define :mysql do |mysql|
	  mysql.vm.network "private_network", ip: "192.168.122.16"
	  mysql.vm.hostname = "mysql"
	  mysql.vm.provider "libvirt" do |vg|
		  vg.memory = "4096"
		  vg.cpus = 1
     end
  end
 end
  
  

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "private_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
