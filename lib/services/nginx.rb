class Nginx < ClusterManagement::Service
  tag :router
  version 22
  
  def install
    services.basic.install
    
    apply_once :install do |box|
      logger.info "installing :#{service_name} to #{box}"
      
      box.bash 'packager install nginx'
      "#{__FILE__.dirname}/nginx.sh".to_file.append_to_environment_of box
      
      # writing configs
      configs_src = "#{__FILE__.dirname}/nginx".to_dir
      configs_src.file('nginx.conf').copy_to! box['/etc/nginx/nginx.conf']
      
      nginx_config = config.nginx!.fire_net!.to_h
      nginx_config[:static] = "#{config.projects_path!}/4ire.net/runtime/public"
      %w(nginx.fire_net.conf).each do |fname|
        data = configs_src[fname].render nginx_config
        box["/etc/nginx/#{fname}"].write! data   
      end
      
      box.bash 'nginx configtest', /successful/
    end
    self
  end
  
  def started?
    !!(single_box.bash('ps -A') =~ /\snginx\s/)
  end
  
  def start
    logger.info "starting :#{service_name} on #{single_box}"
    single_box.bash 'nginx start'
    sleep 1
    self
  end
  
  def stop
    logger.info "stopping :#{service_name} on #{single_box}"
    single_box.bash 'nginx stop'
    sleep 1
    self
  end  
end