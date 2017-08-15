Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.provider "virtualbox" do |v|
    v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.synced_folder ".", "/srv/salt/nas"
  config.vm.synced_folder ".test_pillar", "/srv/pillar"

  config.vm.provision "states", type: "shell", inline: <<-SHELL
    #curl -sL https://github.com/rlifshay/salt-nginx-state/archive/master.tgz | tar -xvf - -C /srv/salt/nginx
    curl -sL https://github.com/rlifshay/salt-master/raw/master/nginx.sls -o /srv/salt/nginx.sls
  SHELL

  config.vm.provision "salt"
  config.vm.provision "salt-local", type: "shell", inline: "sed -ri '/^#?file_client:/ c file_client: local' /etc/salt/minion"
  config.vm.provision "highstate", type: "shell", keep_color: true, inline: "salt-call --force-color state.apply nas --state-output changes"
end
