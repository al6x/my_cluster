class Mail < ClusterManagement::Service
  tag :basic
  version 2
  
  def install
    services.system_tools.install
    
    apply_once :install do |box|
      logger.info "installing :#{service_name} to #{box}"
      
      box.bash 'packager install sendmail', /done/
    end
    self
  end
  
  def start
    self
  end
  
  def stop
    self
  end
    
  def started?
    true
  end
end