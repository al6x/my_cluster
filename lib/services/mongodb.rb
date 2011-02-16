class Mongodb < ClusterManagement::Service
  version 2
  
  def install
    apply_once :install do
      require Services::Basic => :install
      
      logger.info "installing MongoDB to #{box}"            
      
      box.bash 'packager install mongodb'      
      box[data_path].create

      box.tmp do |tmp|
        template = "#{__FILE__.dirname}/mongodb.sh".to_file
        script = tmp[template.name].write template.render(data_path: data_path)
        script.append_to_environment_of box
      end
      
      box[data_path].create

      box.bash 'mongo --version', /MongoDB/
      box[data_path].dir?.must_be.true
    end
    self
  end
  
  def dump_to path
    raise "backup path #{path} already exist!" if path.to_entry.exist?
    must_be_running
    
    logger.info "dumping MongoDB to #{path}"    
    box.tmp do |tmp|            
      tmp_dump = tmp / 'mongodb_dump'
      
      logger.info "  dumping database to tmp file"
      out = box.bash("mongodb dump --out #{tmp_dump.path}")      
      unless out =~ /accounts_production.*to/ and out =~ /global_production.*to/
        puts out
        raise "erorr during MongoDB dump!"
      end
      raise "unknown error, tmp backup file #{tmp_dump.path} hasn't been created!" unless tmp_dump.exist?
      
      logger.info "  copying tmp file to backup storage"      
      # tmp_dump.rsync_to path.to_dir can't use rsync hands if used with ssh, known bug
      tmp_dump.copy_to path.to_dir
      
      raise "unknown error, dump hasn't been copied to backup storage (#{path} is empty)!" unless path.to_dir.exist?
    end
    logger.info "MongoDB has been dumped to #{path}"    
    self
  end
  
  def restore_from path
    raise "backup path #{path} not exist!" unless path.to_entry.exist?
    must_be_running
    
    logger.info "restoring MongoDB from #{path}"    
    box.tmp do |tmp|
      tmp_dump = tmp / 'mongodb_dump'
      
      logger.info "  copying dump to tmp file"
      # path.to_dir.rsync_to tmp_dump can't use rsync hands if used with ssh, known bug
      path.to_dir.copy_to tmp_dump.to_dir

      raise "unknown error, tmp backup file #{tmp_dump.path} hasn't been created!" unless tmp_dump.exist?
      
      logger.info "  restoring MongoDB"
      box.bash("mongodb restore #{tmp_dump.path}", /MongoDB has been restored/)
    end
    logger.info "MongoDB has been restored from #{path}"    
    self
  end
  
  def start
    logger.info "starting MongoDB on #{box}"
    box.bash 'mongodb start'
    sleep 1
    self
  end
  
  def stop
    logger.info "stopping MongoDB on #{box}"
    box.bash 'mongodb stop' rescue
    sleep 1
    self
  end
    
  def started?
    !!(box.bash('ps -A') =~ /\smongod\s/)
  end
  
  # def exec cmd
  #   box.bash("mongodb shell --eval ")
  # end
  
  def data_path
    "#{config.data_path!}/db"
  end
  
  protected
    def must_be_running
      raise "MongoDB is not running" unless started?
    end
end