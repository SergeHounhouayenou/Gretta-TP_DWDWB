$script = <<- 'SCRIPT'
sudo apt-get install git-all 
SCRIPT
Vagrant.configure("2") do |config|
config.vm.provision "shell", inline: $script 
end
end
