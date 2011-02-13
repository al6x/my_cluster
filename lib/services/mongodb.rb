class Mongodb < ClusterManagement::Service
  def install
    apply_once :install do
      require Services::Basic => :install
      
      logger.info "installing Mongodb to #{box}"
      
      data_dir = "#{config.data_path!}/db"
      
      box.bash 'packager install mongodb'      
      box[data_dir].create

      box.tmp do |tmp|
        template = "#{__FILE__.dirname}/mongodb.sh".to_file
        script = tmp[template.name].write template.read.gsub("%{data_dir}", data_dir)
        script.append_to_environment_of box
      end

      box.bash 'mongo --version', /MongoDB/
      box[data_dir].dir?.should_be true
    end
  end
  
  def start
    logger.info 'starting MongoDB'
    box.bash 'mongodb start'
    sleep 1
  end
  
  def stop
    logger.info 'stopping MongoDB'
    box.bash 'mongodb stop' rescue
    sleep 1
  end
  
  def started?
    box.bash('ps -A') =~ /\smongod\s/
  end
end