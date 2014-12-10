$script = <<SCRIPT
touch /etc/profile.d/java.sh
echo export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.71.x86_64/jre >> /etc/profile.d/java.sh
echo export PATH=${JAVA_HOME}/bin:${PATH} >> /etc/profile.d/java.sh
SCRIPT

Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.define :master do |master|
		master.vm.box = "centos6.4Min"
		master.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"
		master.vm.provider "virtualbox" do |v|
		  v.name = "hadoop-yarn"
		  v.customize ["modifyvm", :id, "--memory", "4096"]
		end
		master.vm.network :private_network, ip: "10.211.55.101"
		master.vm.hostname = "hadoop-yarn"

		# Proxy Setup (add your own file here if you need it. You will need yum.conf proxy & http_proxy configured)
		#master.vm.provision :shell, :path=> 'proxy.sh'

		# Bootstrap JAVA_HOME
		master.vm.provision "shell", inline: $script

		# Port Forwarding
		master.vm.network "forwarded_port", guest: 50070, host: 50070
		master.vm.network "forwarded_port", guest: 50075, host: 50075
		master.vm.network "forwarded_port", guest: 8088, host: 8088
		master.vm.network "forwarded_port", guest: 8042, host: 8042
		master.vm.network "forwarded_port", guest: 19888, host: 19888

		master.vm.provision "puppet" do |puppet|
	      puppet.manifests_path = "puppet/manifests"
	      puppet.module_path = "puppet/modules"
	      puppet.manifest_file = "init.pp"
	    end
	end
end
