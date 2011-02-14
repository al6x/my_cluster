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
my_cluster_dir = File.expand_path "#{File.dirname __FILE__}/../.."
require 'class_loader'
autoload_dir "#{my_cluster_dir}/lib"


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
ClusterManagement.load_config "#{my_cluster_dir}/config/config.yml"
def config; ClusterManagement.config end
config.config_dir = "#{my_cluster_dir}/config"


# 
# Rake
# 
require 'rake_ext'
delete_task :default
