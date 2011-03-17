class Security < ClusterManagement::Service
  tag :basic
  
  def install
    services.os.install
    
    apply_once :install do |box|
      logger.info "installing :#{service_name} to #{box}"
      
      ssh_config = "#{config.config_path!}/services/security/ssh_config".to_file
      ssh_config.copy_to! box['/etc/ssh/ssh_config'] if ssh_config.exist?
      # box.upload_file ssh_config, '/etc/ssh/ssh_config', override: true if File.exist? ssh_config
      
      box.dir("~/.ssh").create
      # box.create_directory "~/.ssh", silent: true
      {
        "#{config.config_path!}/services/security/id_rsa".to_file => "~/.ssh/id_rsa",
        "#{config.config_path!}/services/security/id_rsa.pub".to_file => "~/.ssh/id_rsa.pub"
      }.each do |from, to|        
        # box.upload_file from, to, override: true if File.exist? from
        from.copy_to! box[to] if from.exist?
      end
      box.bash "chmod -R go-rwx ~/.ssh"
    end
    self
  end
end