class SystemTools < ClusterManagement::Service
  tag :basic
  
  def install
    services.os.install
    
    apply_once :install do |box|
      logger.info "installing :#{service_name} to #{box}"
      
      "#{__FILE__.dirname}/system_tools.sh".to_file.append_to_environment_of box
      
      box.bash 'packager update'
      box.bash 'packager upgrade'
      
      tools = %w(        
        gcc 
        g++ 
        build-essential 
        libssl-dev 
        libreadline5-dev 
        zlib1g-dev 
        linux-headers-generic 
        bison 
        autoconf 
        htop
        libxml2-dev
        libxslt-dev
      )
      box.bash "packager install #{tools.join(' ')}"
    end
    self
  end
end