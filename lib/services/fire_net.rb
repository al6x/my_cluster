class FireNet < ClusterManagement::Service
  tag :app
  version 2
  
  DEPENDENCIES = [:basic, :fs, :thin, :code_highlighter, :mail, :mongodb, :nginx]
  FAKE_GEMS = {
    class_loader: 'git://github.com/alexeypetrushin/class_loader.git',
    micon: 'git://github.com/alexeypetrushin/micon.git',
    mongoid_misc: 'git://github.com/alexeypetrushin/mongoid_misc.git',
    rad_assets: 'git://github.com/alexeypetrushin/rad_assets.git',    
    rad_common_interface: 'git://github.com/alexeypetrushin/rad_common_interface.git',
    rad_core: 'git://github.com/alexeypetrushin/rad_core.git',
    rad_face: 'git://github.com/alexeypetrushin/rad_face.git',
    rad_js: 'git://github.com/alexeypetrushin/rad_js.git',
    rad_kit: 'git://github.com/alexeypetrushin/rad_kit.git',
    rad_themes: 'git://github.com/alexeypetrushin/rad_themes.git',
    rad_users: 'git://github.com/alexeypetrushin/rad_users.git',
    ruby_ext: 'git://github.com/alexeypetrushin/ruby_ext.git',
    vfs: 'git://github.com/alexeypetrushin/vfs.git',
    
    rad_bag: 'git@github.com:alexeypetrushin/rad_bag.git',
    rad_saas: 'git@github.com:alexeypetrushin/rad_saas.git',
    rad_store: 'git@github.com:alexeypetrushin/rad_store.git'
  }
  NAME = '4ire.net'
  GIT = 'git@github.com:alexeypetrushin/4ire.net.git'
  
  def install
    apply_once :install do |box|
      DEPENDENCIES.each{|name| services[name].install}
      
      logger.info "installing :#{service_name} to #{box}"
      projects = box[config.projects_path]
      projects.create
    
      logger.info "  installing fake gems"      
      FAKE_GEMS.merge(NAME => GIT).each do |name, git|
        projects[name].destroy
        projects.bash "git clone #{git}"
      end
            
      logger.info "  installing gems"
      box.bash 'gem install bundler', /Successfully/
      fire_net = projects / NAME
      fire_net.bash 'bundle install', /Your bundle is complete/
    end
    self
  end
  
  def update
    install
    
    boxes.each do |box|
      logger.info "updating :#{service_name} on #{box}"
      
      logger.info "  updating fake gems"
      projects = box[config.projects_path]
      FAKE_GEMS.merge(NAME => GIT).each do |name, git|
        fgem = projects[name]
        raise "project :#{name} not exist!" unless fgem.exist?
        fgem.bash "git reset HEAD --hard && git pull"
      end
      
      logger.info "  updating gems"
      fire_net = projects / NAME
      fire_net.bash 'bundle install', /Your bundle is complete/
    end
    
    self
  end
  
  def deploy    
    update
    services do
      nginx.started    
      mongodb.started
    end

    boxes.each do |box|      
      logger.info "deploying :#{service_name} to #{box}"
    
      fire_net = (box / config.projects_path) / NAME
      runtime = fire_net / :runtime
    
      logger.info "  configuring"
      config_src = "#{config.config_path}/services/fire_net/config".to_dir
      raise "no config for 4ire.net (#{production_config})!" unless config_src.exist?
      config_src.copy_to! runtime['config']
        
      logger.info "  symlinks"
      runtime['public/fs'].symlink_to! box[Services::Fs.data_path]
      
      logger.info "  copying assets"
      runtime.bash "rake assets:copy_to_public m=production"
    
      logger.info "  restarting thin"

      services.thin.configure(runtime.path).restart
    end
    self
  end
end