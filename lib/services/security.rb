class Security < ClusterManagement::Service
  def install
    apply_once :install do
      require Services::Os => :install
      
      logger.info "installing Security to #{box}"
      
      ssh_config = "#{config.config_dir!}/ssh_config".to_file
      ssh_config.copy_to! box['/etc/ssh/ssh_config'] if ssh_config.exist?
      # box.upload_file ssh_config, '/etc/ssh/ssh_config', override: true if File.exist? ssh_config
      
      box.dir("~/.ssh").create
      # box.create_directory "~/.ssh", silent: true
      {
        "#{config.config_dir!}/id_rsa".to_file => "~/.ssh/id_rsa",
        "#{config.config_dir!}/id_rsa.pub".to_file => "~/.ssh/id_rsa.pub"
      }.each do |from, to|        
        # box.upload_file from, to, override: true if File.exist? from
        from.copy_to! box[to] if from.exist?
      end
      box.bash "chmod -R go-rwx ~/.ssh"
    end
  end
end