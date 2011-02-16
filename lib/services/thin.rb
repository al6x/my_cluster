class Thin < ClusterManagement::Service
  DEFAULT_OPTIONS = {
    '-p' => 4000,
    '-s' => 3
  }
  
  def install
    apply_once :install do
      require Services::Basic => :install
      
      logger.info "installing Thin to #{box}"
      
      box.bash 'gem install thin'
      
      box.bash 'thin -v', /thin/
    end
  end
  
  def configure path, options
    self.path = path
    self.options = DEFAULT_OPTIONS.merge options
    self
  end
  
  def stop
    logger.info "stopping Thin on #{box}"
    box[path].bash "thin stop #{nginx_options}", /Stopping server/    
    sleep 1
    self
  end
  
  def start
    logger.info "starting Thin on #{box}"
    box[path].bash "thin start #{nginx_options}", /Starting server/
    sleep 1
    self
  end
  
  def started?
    !!(box.bash('ps -A') =~ /\sthin\s/)
  end
  
  protected
    def nginx_options
      options.to_a.collect{|k, v| "#{k} #{v}"}.join(' ')
    end
  
    attr_writer :options
    def options
      @options || raise(":options not defined (use :configure)!")
    end
    
    attr_writer :path
    def path
      @path || raise(":path not difined (use :configure)!")
    end
end