Vagrant.configure(2) do |config| 
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", type: "dhcp"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory=2048
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant", "1"]
  end
  config.vm.provision "shell", path: "./setup_assets/ubuntu_wp.sh"
  config.vm.provision "shell", run: "always" do |s|
    s.inline = "echo \"IP address for host file: \" && ifconfig eth1 | grep \"inet addr\" | awk '{ print $2 }' | sed -n -e 's/.*://p'"
  end
end
