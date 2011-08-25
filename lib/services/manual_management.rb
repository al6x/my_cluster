class ManualManagement < ClusterManagement::Service
  tag :basic

  def install
    services do |ss|
      os.install
      security.install
      system_tools.install
    end

    apply_once :install do |box|
      logger.info "installing :#{service_name} to #{box}"

      box.bash 'packager install mc'
      box.bash 'packager install locate'

      authorized_keys, target = "#{config.config_path}/services/manual_management/authorized_keys".to_file, box['~/.ssh/authorized_keys']
      authorized_keys.copy_to! target if authorized_keys.exist?

      box.bash 'which mc', /mc/
    end
    self
  end
end