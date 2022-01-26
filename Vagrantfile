Vagrant.configure("2") do |config|
    config.vm.define "machine1" do |m1|
      m1.vm.box = "hashicorp/bionic64"
      m1.vm.hostname = "machine1"
      m1.vm.network "private_network", ip: "192.168.56.110"
      m1.vm.provision "shell", path: "dependencies_m1.sh" 
    end

    config.vm.define "machine2" do |m2|
      m2.vm.box = "hashicorp/bionic64"
      m2.vm.hostname = "machine2"
      m2.vm.network "private_network", ip: "192.168.56.111"
      m2.vm.provision "shell", path: "dependencies_m2.sh"
    end
  end