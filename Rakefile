# $ gem install ruby_ext
require 'rake_ext'

lib_dir = "#{File.dirname __FILE__}/lib"
$LOAD_PATH << lib_dir unless $LOAD_PATH.include? lib_dir

# $ gem install class_loader
require 'class_loader' 
autoload_dir lib_dir

require 'support/my_cluster'

# %w(
#   basic
#   app_server
#   web_server
#   db
#   
#   app
#   
#   backup
# ).each{|n| require "packages/#{n}"}
# 
# %w(
# ).each{|n| require "deploy/#{n}"}
delete_task :default

task :default do
  config.servers!.to_h.each do |host, roles|            
    box = config.ssh? ? Box.new(host.to_s, config.ssh.to_h) : Box.new(host.to_s)
    box.open
    
    Services::Security.new(box).install
  end
end