require 'cluster_management'
require 'vos/drivers/ssh'

dir = "#{__FILE__}/../../..".to_dir.to_s

require 'my_cluster/service'
autoload_path "#{dir}/lib"

# Configuring
ClusterManagement::Config.class_eval do
  attr_required :projects_path, :data_path, :nginx, :thin
end
cluster.config.load_config! dir