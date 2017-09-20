Dotenv.load

Vagrant.configure("2") do |config|
    config.vm.box = "archlinux/archlinux"
    config.vm.provider "virtualbox" do |v|
        v.name   = ENV['VM_NAME']
        v.gui    = true
        v.memory = ENV['VM_MEMORY']
        v.cpus   = ENV['VM_CPUS']
        v.customize [
            "modifyvm", :id,
            "--vram", ENV['VM_VRAM'],
            "--monitorcount", ENV['VM_MONITOR'],
            "--clipboard", "bidirectional",
        ]
    end
    # config.vm.network "forwarded_port", guest: 8080, host: 8080
    config.vm.provision "shell", path: "bootstrap.sh"
end
