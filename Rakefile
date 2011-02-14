# Load paths
my_cluster_dir = File.dirname __FILE__
$LOAD_PATH << "#{my_cluster_dir}/lib" unless $LOAD_PATH.include? "#{my_cluster_dir}/lib"

require 'my_cluster/support'

task :install do
  Services::Mongodb.new(boxes[:db]).install
  Services::Fs.new(boxes[:fs]).install
  boxes[:app].each do |box| 
    Services::Thin.new(box).install
    Projects::FireNet.new(box).install
  end
  # boxes[:web].each{|box| Services::Nginx.new(box).install}
end

task :backup do
  backup_dir = config.backup_path!.to_dir[Time.now.to_date.to_s]
  raise "backup path #{backup_dir.path} already exist!" if backup_dir.exist?
  
  Services::Mongodb.new(boxes[:db]).dump_to backup_dir['db'].path
  Services::Fs.new(boxes[:fs]).dump_to backup_dir['fs'].path
end

task :restore do
  backup_dir = ENV['path'] || raise("backup path not specified (use path=... argument)!")
  backup_dir = backup_dir.to_dir
  raise "backup path '#{backup_dir.path}' not exist!" unless backup_dir.exist?

  Services::Mongodb.new(boxes[:db]).restore_from backup_dir['db'].path
  Services::Fs.new(boxes[:fs]).restore_from backup_dir['fs'].path
end