class Git < ClusterManagement::Service
  tag :basic
  
  def install
    services.system_tools.install
    
    apply_once :install do |box|
      logger.info "installing :#{service_name} to #{box}"
      
      box.bash 'packager install git-core'
    
      box.bash 'git --version', /git version/
    end
    self
  end
end