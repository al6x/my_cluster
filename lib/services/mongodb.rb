class Mongodb < ClusterManagement::Service
  version 2
  
  def install
    apply_once :install do
      require Services::Basic => :install
      
      logger.info "installing Mongodb to #{box}"            
      
      box.bash 'packager install mongodb'      
      box[data_dir].create

      box.tmp do |tmp|
        template = "#{__FILE__.dirname}/mongodb.sh".to_file
        script = tmp[template.name].write template.read.gsub("%{data_dir}", data_dir)
        script.append_to_environment_of box
      end

      box.bash 'mongo --version', /MongoDB/
      box[data_dir].dir?.must_be.true
    end
  end
  
  def dump_to path
    raise "backup path #{path} already exist!" if path.to_entry.exist?
    must_be_running
    
    logger.info "dumping MongoDB to #{path}"    
    box.tmp do |tmp|            
      tmp_dump = tmp / 'mongodb_dump'
      
      logger.info "  dumping database to tmp file"
      box.bash("mongodb dump --out #{tmp_dump.path}")
      raise "unknown error, tmp backup file #{tmp_dump.path} hasn't been created!" unless tmp_dump.exist?
      
      logger.info "  copying tmp file to backup storage"
      tmp_dump.rsync_to path.to_dir
      raise "unknown error, dump hasn't been copied to backup storage (#{path} is empty)!" unless path.to_entry.exist?
    end
    logger.info "MongoDB has been dumped to #{path}"    
  end
  
  def restore_from path
    raise "backup path #{path} not exist!" unless path.to_entry.exist?
    must_be_running
    
    logger.info "restoring MongoDB from #{path}"    
    box.tmp do |tmp|
      tmp_dump = tmp / 'mongodb_dump'
      
      logger.info "  copying dump to tmp file"
      path.to_dir.rsync_to tmp_dump
      raise "unknown error, tmp backup file #{tmp_dump.path} hasn't been created!" unless tmp_dump.exist?
      
      logger.info "  restoring MongoDB"
      box.bash "mongodb restore #{tmp_dump.path}"
    end
    logger.info "MongoDB has been restored from #{path}"    
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
  
  def exec cmd
    box.bash("mongodb shell --eval ")
  end
  
  def data_dir
    "#{config.data_path!}/db"
  end
  
  protected
    def must_be_running
      raise "MongoDB is not running" unless started?
    end
end