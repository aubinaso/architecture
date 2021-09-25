Vagrant.configure(2) do |config|

	config.vm.box = "generic/debian9"
	etcHosts = ""

	NODES = [
		{ :hostname => "node1", :ip => "192.168.1.1", :cpus => 1, :mem => 20, :type => "k8snode" },
		{ :hostname => "node2", :ip => "192.168.1.2", :cpus => 1, :mem => 20, :type => "k8snode" },
		{ :hostname => "master", :ip => "192.168.1.3", :cpus => 1, :mem => 10, :type => "k8smaster" },
		{ :hostname => "deploy", :ip => "192.168.1.100", :cpus => 1, :mem => 10, :type => "deploy" },
	]


	#remplissage du fichier /etc/hosts des machines
	NODES.each do |node|
		etcHosts += "echo'" + node[:ip] + " " + node[:hostname] + "' >> /etc/hosts" + "\n"	
	end


	NODES.each do |node|
		config.vm.define node[:hostname] do |cfg|
			cfg.vm.hostname = node[:hostname]
			cfg.vm.network "private_network, ip: node[:ip]
			cfg.vm.provider "virtualbox" do |v|
				v.customize [ "modifyvm", :id, "--cpus", node[:cpus] ]
				v.customize [ "modifyvm", :id, "--natdnshostresolver1", "on" ]
				v.customize [ "modifyvm", :id, "--natdnsproxy1", "on" ]
				v.customize [ "modifyvm", :id, "--memory", node[:mem] ]
				v.customize [ "modifyvm", :id, "--name", node[:hostname] ]
			end
			cfg.vm.provision :shell, :inline => etcHosts

			if node[:type] == "deploy"
				cfg.vm.provision :shell, :path => ansible_install.sh
				cfg.vm.provision :shell, :path => installation_packet_base.sh
				cfg.vm.provision "file", source: "./ansible_dir", destination: "/ansible_dir"
			end
		end
	end
end
