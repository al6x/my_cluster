class Fs < ClusterManagement::Service
  version 2
  
  def install
    apply_once :install do
      require Services::Os => :install
      
      logger.info "installing Fs to #{box}"
      box[data_path].create

      box[data_path].dir?.must_be.true
    end
  end
  
  def dump_to path
    logger.info "dumping Fs to #{path}"    
    # box[data_path].rsync_to path.to_dir can't use rsync hands if used with ssh, known bug
    box.dir[data_path].copy_to path.to_dir
    raise "unknown error, files hasn't been copied to backup storage (#{path} is empty)!" unless path.to_dir.exist?
    logger.info "Fs has been dumped to #{path}"
  end
  
  def restore_from path
    raise "backup path #{path} not exist!" unless path.to_entry.exist?
    fs = box[data_path]
    raise "Fs '#{data_path}' is not empty (clear it manually before restore)!" unless fs.empty?

    logger.info "restoring Fs from #{path}"    
    # path.to_dir.rsync_to fs can't use rsync hands if used with ssh, known bug
    path.to_dir.copy_to! fs
    
    raise "unknown error, backup file #{tmp_dump.path} hasn't been created!" unless fs.exist?
    logger.info "Fs has been restored from #{path}"
  end
  
  def data_path
    "#{config.data_path!}/fs"
  end
end