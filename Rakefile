# Load paths
my_cluster_path = File.dirname __FILE__
$LOAD_PATH << "#{my_cluster_path}/lib" unless $LOAD_PATH.include? "#{my_cluster_path}/lib"

require 'my_cluster/support'

task :default do
  dir = __FILE__.dirname
  # puts "#{dir}/lib/services/nginx/nginx.fire_net.conf".to_file.render(value: 10)
  # boxes[:db].projects.rad_core.update
  boxes[:db].services.nginx.install.restart
  
end

task :deploy do
  boxes[:app].each do |box|
    box.projects.fire_net.deploy
  end
end

task :install do
  boxes[:db].services.mongodb.install
  boxes[:fs].services.fs.install
  
  boxes[:app].each do |box| 
    box.services.thin.install
    box.projects.fire_net.install
  end
  
  boxes[:web].each do |box| 
    box.services.nginx.install
  end
end

task :backup do
  backup_dir = config.backup_path!.to_dir[Time.now.to_date.to_s]
  raise "backup path #{backup_dir.path} already exist!" if backup_dir.exist?
  
  boxes[:db].services.mongodb.dump_to backup_dir['db'].path
  boxes[:fs].services.fs.dump_to backup_dir['fs'].path
end

task :restore do
  backup_dir = ENV['path'] || raise("backup path not specified (use path=... argument)!")
  backup_dir = backup_dir.to_dir
  raise "backup path '#{backup_dir.path}' not exist!" unless backup_dir.exist?
  
  boxes[:db].services.mongodb.restore_from backup_dir['db'].path
  boxes[:fs].services.fs.restore_from backup_dir['fs'].path
end