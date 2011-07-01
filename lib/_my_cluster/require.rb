# 
# Gems
# 
# gem 'cluster_management' (commented out becouse I use it as 'false_gem')
require 'cluster_management'


# 
# Load paths
# 
root_path = "#{__FILE__}/../../..".to_entry.to_s
$LOAD_PATH << "#{root_path}/lib" unless $LOAD_PATH.include? "#{root_path}/lib"

autoload_dir "#{root_path}/lib"


# 
# Libraries
# 
require '_cluster_management_ext/service'
require '_cluster_management_ext/project'


#
# Configuring
#
ClusterManagement::Config.class_eval do
  require_attr :projects_path, :data_path, :nginx, :thin
end

runtime_path = "#{__FILE__}/../../..".to_dir.to_s
cluster.config.load_config! runtime_path