VM_MEMORY = ENV.fetch('VM_MEMORY', 2*1024).to_i
VM_CORES = ENV.fetch('VM_CORES', 2).to_i

Vagrant.configure('2') do |config|
  config.vm.network :private_network, ip: '192.168.100.4', id: :local
  config.vm.hostname = 'concourse'

  config.vm.provider :virtualbox do |vbox, override|
    vbox.customize ['modifyvm', :id, '--memory', VM_MEMORY]
    vbox.customize ['modifyvm', :id, '--cpus', VM_CORES]
    vbox.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vbox.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
  end

  [:vmware_fusion, :vmware_desktop, :vmware_workstation].each do |provider|
    config.vm.provider provider do |vmware, override|
      vmware.vmx["numvcpus"] = VM_CORES
      vmware.vmx["memsize"] = VM_MEMORY
    end
  end

  config.vm.provider :parallels do |prl, override|
    prl.memory = VM_MEMORY
    prl.cpus = VM_CORES
    override.vm.synced_folder ".", "/vagrant", mount_options: %w(share)
  end

  config.vm.synced_folder ".", "/vagrant", mount_options: %w( dmode=777 fmode=777 )
end
