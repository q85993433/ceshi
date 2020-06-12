d# -*- mode: ruby -*-
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
   ansible.playbook = "/root/testcentos7/main.yml"
   end


  config.vm.define :k8s do |k8s|
	  k8s.vm.network "private_network", ip: "192.168.122.5"
                  k8s.vm.hostname = "k8s"
	  k8s.vm.provider "libvirt" do |vh|
		  vh.memory = "4096"
		  vh.cpus = 1
		
	  end
  end	  
config.vm.define :vpn do |vpn|
	  vpn.vm.network "private_network", ip: "192.168.122.6"
                  vpn.vm.network "forwarded_port", guest: 11094, host: 11094, host_ip: "192.168.22.42"
                  vpn.vm.hostname = "vpn"
	  vpn.vm.provider "libvirt" do |vl|
		  vl.memory = "1024"
		  vl.cpus = 1
               end
end
config.vm.define :jenkins do |jenkins|
	  jenkins.vm.network "private_network", ip: "192.168.122.7"
                  jenkins.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "192.168.22.42"
                  jenkins.vm.hostname = "jenkins"
	  jenkins.vm.provider "libvirt" do |vm|
		  vm.memory = "4096"
		  vm.cpus = 1
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
