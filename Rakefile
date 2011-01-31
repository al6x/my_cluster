%w(lib tasks).each do |name|
  lib_dir = "#{File.dirname __FILE__}/#{name}"
  $LOAD_PATH << lib_dir unless $LOAD_PATH.include? lib_dir
end

require 'cluster/support'

require 'box/base'