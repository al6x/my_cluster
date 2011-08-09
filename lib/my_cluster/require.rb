require 'cluster_management'

dir = "#{__FILE__}/../../..".to_dir.to_s

require 'my_cluster/service'
autoload_dir "#{dir}/lib"

# Configuring
ClusterManagement::Config.class_eval do
  attr_required :projects_path, :data_path, :nginx, :thin
end
cluster.config.load_config! dir