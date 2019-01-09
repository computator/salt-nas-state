Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provider "virtualbox" do |v|
    v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.synced_folder ".", "/srv/salt/nas"
  config.vm.synced_folder ".test_pillar", "/srv/pillar"

  config.vm.provision "python-git", type: "shell", inline: "dpkg-query -s python-git > /dev/null || { apt-get update && apt-get install -y python-git; }"
  config.vm.provision "salt", minion_json_config: <<-CONF.gsub("\n", "")
    {
      "file_client": "local",
      "fileserver_backend": ["roots", "gitfs"],
      "gitfs_remotes": [
          "https://github.com/rlifshay/salt-master",
          {"https://github.com/rlifshay/salt-serviio-state": [{"mountpoint": "serviio"}]},
          {"https://github.com/rlifshay/salt-serviio-state": [
              {"name": "serviio_modules"},
              {"root": "_modules"},
              {"mountpoint": "_modules"}
            ]},
          {"https://github.com/rlifshay/salt-serviio-state": [
              {"name": "serviio_states"},
              {"root": "_states"},
              {"mountpoint": "_states"}
            ]}
        ]
    }
  CONF
  config.vm.provision "sync-modules", type: "shell", inline: "salt-call saltutil.sync_all"
  config.vm.provision "highstate", type: "shell", keep_color: true, inline: "salt-call --force-color state.apply nas --state-output changes"
end
