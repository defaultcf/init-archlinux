Vagrant.configure("2") do |config|
    config.vm.box = "archlinux/archlinux"
    config.vm.provider "virtualbox" do |v|
        v.gui = true
        v.memory = 1536
        v.cpus = 2
        v.customize [
            "modifyvm", :id,
            "--vram", "32",
        ]
    end
    config.vm.network "forwarded_port", guest: 8080, host: 8080
    config.vm.provision "shell", path: "bootstrap.sh"
end
