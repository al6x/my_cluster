require 'ruby_ext'
require 'yaml'
require 'rsh'
require 'ros'
require 'tmpdir'

require 'rake_ext'
delete_task :default

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
# Ros
#
module Ros
  class Dsl
    # combine applied? and apply in one.
    def apply_once &b      
      applied?{|box| box.has_mark? name}
      apply &b
      after_applying{|box| box.mark name}      
    end
  end
end


#
# Rsh
#
module Rsh
  class Box
    def apt cmd, ignore_stderr = false
      bash "env DEBIAN_FRONTEND=noninteractive apt-get -y #{cmd}", ignore_stderr
    end
  end
end


#
# boxes
#
def boxes
  unless @boxes
    @boxes = []
    
    host = ENV['host'] || raise(":host not defined!")
    box = Rsh::Box.new host: host, ssh: config.ssh!.to_h
    box.open_connection
    
    @boxes << box
  end
  @boxes
end