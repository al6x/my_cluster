# 
# Gems (commented out becouse I use it as 'false_gem')
# 
# gem 'ruby_ext'
# gem 'class_loader'
# gem 'vos'
# gem 'cluster_management'


# 
# Autoload paths
# 
my_cluster_path = File.expand_path "#{File.dirname __FILE__}/../.."
require 'class_loader'
autoload_dir "#{my_cluster_path}/lib"


# 
# ClusterManagement
# 
require 'cluster_management'
require 'cluster_management_ext/service'
require 'cluster_management_ext/project'

module Vos
  class Box
    include Helpers::Ubuntu
  end
end


# 
# Config
# 
ClusterManagement.load_config "#{my_cluster_path}/config/config.yml"
def config; ClusterManagement.config end
config.config_path = "#{my_cluster_path}/config"


# 
# Rake
# 
require 'rake_ext'
delete_task :default


# 
# Boxes
# 
def boxes
  $boxes ||= {}
end

config.servers!.to_h.each do |host, roles|            
  box = config.ssh? ? Box.new(host.to_s, config.ssh.to_h) : Box.new(host.to_s)  
  box.open
  
  roles.each do |role|
    (boxes[role.to_sym] ||= []) << box
  end  
  (boxes[:all] ||= []) << box
end

raise "db server not defined!" unless boxes[:db]
raise "can't support more than one db server!" if boxes[:db] and (boxes[:db].size > 1)
boxes[:db] = boxes[:db].first

raise "fs server not defined!" unless boxes[:fs]
raise "can't support more than one fs server!" if boxes[:fs] and (boxes[:fs].size > 1)
boxes[:fs] = boxes[:fs].first