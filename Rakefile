# $ gem install ruby_ext
require 'rake_ext'

lib_dir = "#{File.dirname __FILE__}/lib"
$LOAD_PATH << lib_dir unless $LOAD_PATH.include? lib_dir

# $ gem install class_loader
require 'class_loader' 
autoload_dir lib_dir

# $ gem install cluster_management
require 'cluster_management'
require 'cluster_management_ext/service'
require 'cluster_management_ext/project'

# We are using Ubuntu
module Vos
  class Box
    include Helpers::Ubuntu
  end
end

# config
dir = "#{__FILE__.dirname}/config"
ClusterManagement.load_config "#{dir}/config.yml"
def config; ClusterManagement.config end
config.config_dir = dir

# 
# Tasks
# 
delete_task :default

task :default do
  config.servers!.to_h.each do |host, roles|            
    box = config.ssh? ? Box.new(host.to_s, config.ssh.to_h) : Box.new(host.to_s)
    box.open
    
    # Services::Basic.new(box).install
    Projects::FireNet.new(box).install
  end
end