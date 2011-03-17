module ClusterManagement
  class Service
    def started
      unless started?
        start        
        raise "can't start #{self.class}" unless started?
      end
      self            
    end
    
    def restart
      stop
      raise "can't stop #{self.class}" if started?
      start
      raise "can't start #{self.class}" unless started?
      self
    end
  end
end