desc 'app server'
package :app_server => %w().collect{|name| "app_server:#{name}"} 

namespace :app_server do  
end