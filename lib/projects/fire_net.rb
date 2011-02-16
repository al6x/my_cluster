class FireNet < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic,
      Services::Fs,
      Services::Thin,
      
      Projects::Users,
      Projects::Bag
    ],
    name: '4ire.net',
    git: 'git@github.com:alexeypetrushin/4ire.net.git',
    skip_gems: true,
    skip_spec: true
  )
  
  def deploy
    require self.class => :update
    require Services::Nginx => :started
    
    logger.info "deploying 4ire.net to #{box}"
    
    project = box[config.projects_path!].dir project_options[:name]
    runtime = project / :runtime
    
    logger.info "  configuring"
    config_src = "#{config.config_path}/projects/fire_net/config".to_dir
    raise "no config for 4ire.net (#{production_config})!" unless config_src.exist?
    config_src.copy_to! runtime['config']
        
    logger.info "  symlinks"
    runtime['public/fs'].symlink_to! box[Services::Fs.data_path]
    
    logger.info "  restarting thin"
    box.services.thin.configure(runtime.path, config.thin!).restart
  end
end