class ManualManagement < ClusterManagement::Service
  def install
    apply_once :install do
      require(
        Services::Os => :install, 
        Services::Security => :install,
        Services::SystemTools => :install
      )
      
      logger.info "installing ManualManagement to #{box}"
      
      box.bash 'packager install mc'
      box.bash 'packager install locate'

      authorized_keys, target = "#{config.config_path!}/services/manual_management/authorized_keys".to_file, box['~/.ssh/authorized_keys']
      authorized_keys.copy_to! target if authorized_keys.exist?

      box.bash 'which mc', /mc/
    end
    self
  end
end