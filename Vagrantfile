# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "centos-7.2"
  #config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.33.11"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  config.vm.provider "virtualbox" do |vb|
    config.vm.hostname = "zabbix3.lab.local"
  end

  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "setRepo",type:"shell", inline: "wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo",privileged: true
  #config.vm.provision "installZabbix",type:"shell", path: "build.sh", privileged: true
  #config.vm.provision "installGrafana",type:"shell",  path: "build2.sh"
=begin
  config.vm.post_up_message="
========================================================================
  zabbix web console  :http://192.168.33.11
  Username            :admin     (default administrator)
  Password            :zabbix

  Username            :grafana   (zabbix admins, for grafana datasource)
  Password            :grafana-ro
------------------------------------------------------------------------
  grafana web console :http://192.168.33.10:3000
  Username            :admin
  password            :admin
------------------------------------------------------------------------
  MySQL password:
  username            :root
  password            :topsecret
========================================================================
  "
=end
end
