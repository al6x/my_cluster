require 'rake_ext'
delete_task :default

require '_my_cluster/require'

task :deploy do
  cluster.services.fire_net.deploy
end

task :install do
  cluster.services do
    mongodb.install
    fs.install
    
    thin.install
    fire_net.install
    
    nginx.install
  end
end

task :backup do
  backup_dir = config.backup_path!.to_dir[Time.now.to_date.to_s]
  raise "backup path #{backup_dir.path} already exist!" if backup_dir.exist?
  
  cluster.services.mongodb.dump_to backup_dir['db'].path
  cluster.services.fs.dump_to backup_dir['fs'].path
end

task :restore do
  backup_dir = ENV['path'] || raise("backup path not specified (use path=... argument)!")
  backup_dir = backup_dir.to_dir
  raise "backup path '#{backup_dir.path}' not exist!" unless backup_dir.exist?
  
  cluster.services.mongodb.restore_from backup_dir['db'].path
  cluster.services.fs.restore_from backup_dir['fs'].path
end