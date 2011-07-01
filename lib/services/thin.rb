class Thin < ClusterManagement::Service
  tag :app
  
  DEFAULT_OPTIONS = {
    '-p' => 4000,
    '-s' => 3
  }
  
  def install
    services.basic.install
    
    apply_once :install do |box|
      logger.info "installing :#{service_name} to #{box}"
      
      box.bash 'gem install thin -v 1.2.7'
      
      box.bash 'thin -v', /thin/
    end
  end
  
  def configure path
    self.path = path
    self
  end
  
  def stop
    boxes.each do |box|
      cmd = "thin stop #{thin_options}"
      logger.info "stopping :#{service_name} on #{box}"
      out = box[path].bash cmd #, /Stopping server/    
      sleep 1
      if started?
        logger.error out
        raise "can't stop Thin!"       
      end      
    end
    self
  end
  
  def start
    boxes.each do |box|
      cmd = "thin start #{thin_options}"
      logger.info "starting :#{service_name} on #{box}"      
      out = box[path].bash cmd, /Starting server/
      sleep 2
      unless started?        
        logger.error out
        logger.info "command: #{cmd}"
        raise "can't start Thin!"       
      end
    end
    self
  end
  
  def started?
    boxes.all?{|box| !!(box.bash('ps -A') =~ /\sthin\s/)}
  end  
  
  protected    
    def options
      DEFAULT_OPTIONS.merge config.thin
    end
  
    def thin_options
      options.to_a.collect{|k, v| "#{k} #{v}"}.join(' ')
    end
  
    # attr_writer :options
    # def options
    #   @options || raise(":options not defined (use :configure)!")
    # end
    
    attr_writer :path
    def path
      @path || raise(":path not difined (use :configure)!")
    end
end