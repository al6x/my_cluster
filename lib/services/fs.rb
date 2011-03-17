class Fs < ClusterManagement::Service
  tag :basic
  version 2
  
  def install
    services.os.install
    
    apply_once :install do |box|            
      logger.info "installing :#{service_name} to #{box}"
      box[data_path].create

      box[data_path].dir?.must_be.true
    end
    self
  end
  
  def dump_to path
    logger.info "dumping :#{service_name} to #{path}"    
    # box[data_path].rsync_to path.to_dir can't use rsync hands if used with ssh, known bug
    single_box.dir[data_path].copy_to path.to_dir
    raise "unknown error, files hasn't been copied to backup storage (#{path} is empty)!" unless path.to_dir.exist?
    logger.info ":#{service_name} has been dumped to #{path}"
    self
  end
  
  def restore_from path
    raise "backup path #{path} not exist!" unless path.to_entry.exist?
    fs = single_box[data_path]
    raise "Fs '#{data_path}' is not empty (clear it manually before restore)!" unless fs.empty?

    logger.info "restoring :#{service_name} from #{path}"    
    # path.to_dir.rsync_to fs can't use rsync hands if used with ssh, known bug
    path.to_dir.copy_to! fs
    
    raise "unknown error, backup file #{tmp_dump.path} hasn't been created!" unless fs.exist?
    logger.info ":#{service_name} has been restored from #{path}"
    self
  end
  
  def self.data_path
    "#{cluster.config.data_path!}/fs"
  end
  def data_path; self.class.data_path end
end