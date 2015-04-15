# -*- mode: ruby; -*-
Vagrant.configure("2") do |config|
  config.ssh.shell = "sh"
  config.vm.guest = :freebsd
  config.vm.box_url = "http://www.iver.mx/vagrant/freebsd-10.1_chef.box"
  config.vm.box = "freebsd-10.1-amd64"
  config.vm.network "private_network", ip: "10.0.1.10"
  config.vm.provision :shell, path: "bin/setup.sh"

  # Use NFS as a shared folder
  config.vm.synced_folder ".", "/vagrant", :nfs => true, id: "vagrant-root"

  config.vm.provider :virtualbox do |vb|
    # vb.customize ["startvm", :id, "--type", "gui"]
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
    vb.customize ["modifyvm", :id, "--audio", "none"]
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
  end
end
