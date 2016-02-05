# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  config.vm.synced_folder './', '/vagrant', type: 'rsync'
  config.vm.network "forwarded_port", guest: 3306, host: 3306
  config.vm.network "forwarded_port", guest: 80, host: 8080

  #config.cache.scope = :box
  #config.cache.auto_detect = true

  config.ssh.username = 'root'

  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = 'kvm'
    libvirt.nested = true
    libvirt.volume_cache = 'none'
  end

  config.vm.box = 'blagah3'
  #config.vm.box_url = 'https://download.gluster.org/pub/gluster/purpleidea/vagrant/fedora-21/fedora-21.box'
  config.vm.box_url = '/home/jeremy/Downloads/fedora-21.box'
  config.vm.provision :shell, path: 'tests/vagrant_setup_mariadb.sh'
  config.vm.hostname = 'ttrss'

  # Apache/mod_php webserver
  #config.vm.define :web do |web|
  #  web.vm.box = 'web'
  #  web.vm.box_url = 'https://download.gluster.org/pub/gluster/purpleidea/vagrant/fedora-21/fedora-21.box'
  #  web.vm.hostname = 'ttrss-web.local'
  #  web.vm.provision :shell, path: 'tests/vagrant_setup_web.sh'
  #end

  # PostgreSQL db server
  #config.vm.define :db do |db|
  #  db.vm.box = 'fedora21'
  #  db.vm.box_url = 'https://download.gluster.org/pub/gluster/purpleidea/vagrant/fedora-21/fedora-21.box'
  #  db.vm.hostname = 'ttrss-db.local'
  #  db.vm.provision 'shell', inline: 'echo db'
  #end
end
