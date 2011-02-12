lib_dir = "#{File.dirname __FILE__}/lib"
$LOAD_PATH << lib_dir unless $LOAD_PATH.include? lib_dir

require 'support/my_cluster'

%w(
  basic
  app_server
  web_server
  db
  
  app
).each{|n| require "packages/#{n}"}

%w(
).each{|n| require "deploy/#{n}"}