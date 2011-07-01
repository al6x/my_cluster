class MySql < ClusterManagement::Service
  tag :db
  version 2
  
  def install
    services.basic.install
    
    apply_once :install do |box|
      logger.info "installing :#{service_name} to #{box}"            
      
      box.bash 'packager install mysql-server mysql-client libmysql-ruby libmysqlclient-dev'
      "#{__FILE__.dirname}/my_sql.sh".to_file.append_to_environment_of box
      box[data_path].create

      box.bash 'mysql status', /MySQL is not running/
      box[data_path].dir?.must_be.true
    end
    self
  end
    
  def start
    logger.info "starting :#{service_name} on #{box}"
    box.bash 'mysql start'
    sleep 1
    self
  end
  
  def stop
    logger.info "stopping :#{service_name} on #{box}"
    box.bash 'mysql stop' rescue
    sleep 7
    self
  end
    
  def started?
    !!(box.bash('mysql status') =~ /running/)
  end
end