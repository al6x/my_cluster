require 'yaml'
require 'tmpdir'

# $ gem install ruby_ext
require 'ruby_ext'
require 'rake_ext'

# $ gem install vos
require 'vos'

# $ gem install cluster_management
require 'cluster_management'

%w(default spec spec:isolated).each{|name| delete_task name}

#
# Config
#
class DeployConfig < SafeHash
  def merge_config! file_path      
    raise("config file must have .yml extension (#{file_path})!") unless file_path.end_with? '.yml'
    if ::File.exist? file_path
      data = ::YAML.load_file file_path
      if data
        data.must_be.a ::Hash
        self.deep_merge! data            
      end
    end
  end
end

def config
  unless @config
    dir = File.expand_path "#{__FILE__.dirname}/../.."    
    @config = DeployConfig.new
    @config.config_dir = "#{dir}/config"
    @config.merge_config! "#{@config.config_dir!}/config.yml"
  end
  @config
end


#
# Logging
#
def log_operation msg, &block
  print "  #{msg} ... "
  block.call
  print "done\n"
end

#
# Vos
#
# module Vos
#   class Box
#     # def packager cmd, options = {}
#     #   bash "env DEBIAN_FRONTEND=noninteractive apt-get -y #{cmd}", options
#     # end
#     
#     # def append_to path, text, options = {}
#     #   reload = options.delete :reload
#     #   raise "invalid options #{options.keys}" unless options.empty?
#     #   
#     #   text.split("\n").each do |line|
#     #     bash "echo '#{line}' >> #{path}"
#     #   end
#     #   bash ". #{path}" if reload
#     # end
#   end
# end
module Vos
  class Box
    include Helpers::Ubuntu
  end
end

#
# boxes
#
module ClusterManagement
  def self.boxes
    unless @boxes    
      host = ENV['host'] || raise(":host not defined!")
      box = Vos::Box.new host: host, ssh: config.ssh!.to_h      
      box.open
      
      @boxes = [box]
    end
    @boxes
  end
end