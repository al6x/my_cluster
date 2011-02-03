lib_dir = "#{File.dirname __FILE__}/lib"
$LOAD_PATH << lib_dir unless $LOAD_PATH.include? lib_dir

require 'cluster/support'

%w(
  basic
  app_server
  web_server
  db
).each{|n| require "packages/#{n}"}