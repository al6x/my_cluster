class Mongodb < ClusterManagement::Service
  tag :db
  version 3
  
  def install
    services.basic.install
    
    apply_once :install do |box|
      logger.info "installing :#{service_name} to #{box}"            
      
      # updating source list
      sources_list = box.file('/etc/apt/sources.list')
      new_source = "\ndeb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen"
      sources_list.append new_source unless sources_list.content.include? new_source
      box.bash 'sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10'
      
      # installing mongodb
      # box.bash 'packager install mongodb'
      box.bash 'sudo apt-get update'
      box.bash 'sudo apt-get install mongodb-10gen'
      
      box[data_path].create

      box.tmp do |tmp|
        template = "#{__FILE__.dirname}/mongodb.sh.erb".to_file
        script = tmp[template.name].write template.render(data_path: data_path)
        script.append_to_environment_of box
      end
      
      # box[data_path].create

      box.bash 'mongo --version', /MongoDB/
      box[data_path].dir?.must_be.true
    end
    self
  end
  
  def dump_to path
    raise "backup path #{path} already exist!" if path.to_entry.exist?
    must_be_running
    
    logger.info "dumping :#{service_name} to #{path}"    
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
    logger.info ":#{service_name} has been dumped to #{path}"    
    self
  end
  
  def restore_from path
    raise "backup path #{path} not exist!" unless path.to_entry.exist?
    must_be_running
    
    logger.info "restoring :#{service_name} from #{path}"    
    box.tmp do |tmp|
      tmp_dump = tmp / 'mongodb_dump'
      
      logger.info "  copying dump to tmp file"
      # path.to_dir.rsync_to tmp_dump can't use rsync hands if used with ssh, known bug
      path.to_dir.copy_to tmp_dump.to_dir

      raise "unknown error, tmp backup file #{tmp_dump.path} hasn't been created!" unless tmp_dump.exist?
      
      logger.info "  restoring :#{service_name}"
      box.bash "mongodb restore #{tmp_dump.path}" #, /MongoDB has been restored/
    end
    logger.info ":#{service_name} has been restored from #{path}"    
    self
  end
  
  def start
    logger.info "starting :#{service_name} on #{box}"
    box.bash 'mongodb start '
    sleep 1
    self
  end
  
  def stop
    logger.info "stopping :#{service_name} on #{box}"
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