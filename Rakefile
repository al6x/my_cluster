dir = File.dirname __FILE__
$LOAD_PATH << "#{dir}/lib" unless $LOAD_PATH.include? "#{dir}/lib"
require 'my_cluster/require'

require 'rake_ext'
delete_task :default

desc 'deploy to cluster'
task :deploy do
  cluster.services.fire_net.deploy
end

task :basic do
  cluster.services.basic.install
end

desc 'install to cluster'
task :install do
  cluster.services do
    mongodb.install
    fs.install
    
    thin.install
    fire_net.install
    
    nginx.install
  end
end

desc "backup database and files"
task :backup do
  backup_dir = cluster.config.backup_path.to_dir[Time.now.to_date.to_s]
  raise "backup path #{backup_dir.path} already exist!" if backup_dir.exist?
  backup_dir.create

  cluster.services.mongodb.dump_to backup_dir['db'].path
  # cluster.services.fs.dump_to backup_dir['fs'].path
end

desc "restore database and files"
task :restore do
  backup_dir = ENV['path'] || raise("backup path not specified (use path=... argument)!")
  backup_dir = backup_dir.to_dir
  raise "backup path '#{backup_dir.path}' not exist!" unless backup_dir.exist?
  
  cluster.services.mongodb.restore_from backup_dir['db'].path
  # cluster.services.fs.restore_from backup_dir['fs'].path
end