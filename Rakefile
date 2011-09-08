dir = File.dirname __FILE__
$LOAD_PATH << "#{dir}/lib" unless $LOAD_PATH.include? "#{dir}/lib"
require 'my_cluster/require'

require 'rake_ext'
delete_task :default

desc 'deploy app'
task :deploy do
  cluster.services.fire_net.deploy
end

desc 'install basic tools'
task :install_basic do
  cluster.services.basic.install
end

desc "backup database and files"
task :backup do
  backup_dir = cluster.config.backup_path.to_dir[Time.now.to_date.to_s]
  raise "backup path #{backup_dir.path} already exist!" if backup_dir.exist?
  backup_dir.create

  cluster.services.mongodb.dump_to backup_dir['db'].path
  cluster.services.fs.dump_to backup_dir['fs'].path
end

desc "restore database"
task :restore_db do
  raise "Are You shure? Comment out this line to proceed."

  backup_dir = ENV['path'] || raise("backup path not specified (use path=... argument)!")
  backup_dir = backup_dir.to_dir
  raise "backup path '#{backup_dir.path}' not exist!" unless backup_dir.exist?

  cluster.services.mongodb.restore_from backup_dir['db'].path
end

desc "restore files"
task :restore_fs do
  raise "Are You shure? Comment out this line to proceed."

  backup_dir = ENV['path'] || raise("backup path not specified (use path=... argument)!")
  backup_dir = backup_dir.to_dir
  raise "backup path '#{backup_dir.path}' not exist!" unless backup_dir.exist?

  cluster.services.fs.restore_from backup_dir['fs'].path
end