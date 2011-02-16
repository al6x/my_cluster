class Nginx < ClusterManagement::Service
  version 11
  
  def install
    apply_once :install do
      require Services::Basic => :install
      
      logger.info "installing Nginx to #{box}"
      
      box.bash 'packager install nginx'
      "#{__FILE__.dirname}/nginx.sh".to_file.append_to_environment_of box
      
      # writing configs
      configs_src = "#{__FILE__.dirname}/nginx".to_dir
      configs_src.file('nginx.conf').copy_to! box['/etc/nginx/nginx.conf']
      
      nginx_config = config.nginx!.fire_net!.to_h
      nginx_config[:static] = "#{config.projects_path!}/4ire.net/runtime/public"
      data = configs_src['nginx.fire_net.conf'].render nginx_config
      box['/etc/nginx/nginx.fire_net.conf'].write! data   
      
      box.bash 'nginx configtest', /successful/
    end
    self
  end
  
  def started?
    !!(box.bash('ps -A') =~ /\snginx\s/)
  end
  
  def start
    logger.info "starting NginX on #{box}"
    box.bash 'nginx start'
    sleep 1
    self
  end
  
  def stop
    logger.info "stopping NginX on #{box}"
    box.bash 'nginx stop'
    sleep 1
    self
  end  
end