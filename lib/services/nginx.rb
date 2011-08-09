class Nginx < ClusterManagement::Service
  tag :router
  version 29
  
  def install
    services.basic.install
    
    apply_once :install do |box|
      logger.info "installing :#{service_name} to #{box}"
      
      box.bash 'packager install nginx'
      "#{__FILE__.dirname}/nginx.sh".to_file.append_to_environment_of box
      
      # writing configs
      configs_src = "#{__FILE__.dirname}/nginx".to_dir
      configs_src.file('nginx.conf').copy_to! box['/etc/nginx/nginx.conf']
      
      nginx_config = config.nginx['fire_net']
      nginx_config[:static] = "#{config.projects_path}/4ire.net/runtime/public"
      {'nginx.fire_net.conf.erb' => 'nginx.fire_net.conf'}.each do |template, fname|
        data = configs_src[template].render nginx_config        
        box["/etc/nginx/#{fname}"].write! data
      end
      
      box.bash 'nginx configtest', /^Testing nginx configuration: nginx.$/
    end
    self
  end
  
  def started?
    install
    
    !!(box.bash('ps -A') =~ /\snginx\s/)
  end
  
  def start
    install
    
    logger.info "starting :#{service_name} on #{box}"
    box.bash 'nginx start'
    sleep 1
    self
  end
  
  def stop
    install
    
    logger.info "stopping :#{service_name} on #{box}"
    box.bash 'nginx stop'
    sleep 1
    self
  end  
end