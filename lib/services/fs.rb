# encoding: utf-8

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

  def dump_to backup_path
    logger.info "dumping :#{service_name} to #{backup_path}"
    backup_path = backup_path.to_dir

    require 'aws'
    s3 = AWS::S3.new config.aws
    bucket = s3.buckets[config.fs[:bucket]]
    counter = 0
    bucket.objects.each do |object|
      backup_path[object.key].write object.read
      counter += 1
      logger.info "  copied #{counter} files" if counter % 100 == 0
    end

    raise "unknown error, files hasn't been copied to backup storage (#{backup_path} is empty)!" unless backup_path.exist?
    logger.info ":#{service_name} has been dumped to #{backup_path}"
    self
  end

  # def dump_to backup_path
  #   logger.info "dumping :#{service_name} to #{backup_path}"
  #   backup_path = "#{backup_path}.tar.gz".to_file
  #
  #   fs_dir = box.dir data_path
  #   raise "directory for files '#{fs_dir.path}' not exist!" unless fs_dir.exist?
  #
  #   # TODO 3
  #   # hack, somehow there's a recursive /data/fs/fs link to itself (/data/fs) I don't know who creates it, don't have time to investigate
  #   # right now just deleting it.
  #   fs_dir['fs'].destroy
  #
  #   logger.info "  compressing"
  #   fs_tar = fs_dir.parent.file 'fs.tar.gz'
  #   fs_tar.destroy
  #   box.bash "tar -zcvf #{fs_tar.path} #{fs_dir.path}"
  #
  #   logger.info "  copying"
  #   # box[data_path].rsync_to path.to_dir can't use rsync hands if used with ssh, known bug
  #   fs_tar.copy_to backup_path
  #   fs_tar.destroy
  #   raise "unknown error, files hasn't been copied to backup storage (#{backup_path} is empty)!" unless backup_path.exist?
  #   logger.info ":#{service_name} has been dumped to #{backup_path}"
  #   self
  # end
  #
  # def restore_from restore_path
  #   restore_path =  "#{restore_path}.tar.gz".to_file
  #   raise "backup path #{restore_path} not exist!" unless restore_path.exist?
  #   fs_dir = box.dir data_path
  #
  #   # TODO 3
  #   # hack, somehow there's a recursive /data/fs/fs link to itself (/data/fs) I don't know who creates it, don't have time to investigate
  #   # right now just deleting it.
  #   fs_dir['fs'].destroy
  #
  #   raise "Fs '#{fs_dir}' is not empty (clear it manually before restore)!" if fs_dir.exist? and !fs_dir.empty?
  #
  #   logger.info "restoring :#{service_name} from #{restore_path}"
  #   # path.to_dir.rsync_to fs can't use rsync hands if used with ssh, known bug
  #
  #   logger.info "  copying"
  #   fs_tar = fs_dir.parent.file 'fs.tar.gz'
  #   fs_tar.destroy
  #   restore_path.copy_to fs_tar
  #
  #   logger.info "  uncompressing"
  #   box.bash "tar -zxvf #{fs_tar.path} -C #{fs_dir.path}"
  #
  #   raise "unknown error, dir #{fs_dir.path} hasn't been restored!" unless fs_dir.exist?
  #   logger.info ":#{service_name} has been restored from #{restore_path.path}"
  #   self
  # end

  def self.data_path
    "#{cluster.config.data_path}/fs"
  end
  def data_path; self.class.data_path end
end