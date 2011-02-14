# Load paths
my_cluster_dir = File.dirname __FILE__
$LOAD_PATH << "#{my_cluster_dir}/lib" unless $LOAD_PATH.include? "#{my_cluster_dir}/lib"

require 'my_cluster/support'

task :default do
  config.servers!.to_h.each do |host, roles|            
    box = config.ssh? ? Box.new(host.to_s, config.ssh.to_h) : Box.new(host.to_s)
    
    box.open
    # Services::Basic.new(box).install
    # Services::Mongodb.new(box).install
    # Services::Mongodb.new(box).dump_to "/tmp/mongodb_dump"
    Services::Mongodb.new(box).restore_from "/tmp/mongodb_dump"
  end
end