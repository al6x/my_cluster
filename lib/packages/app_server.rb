desc 'app server'
package :app_server => %w(thin).collect{|name| "app_server:#{name}"} 

namespace :app_server do
  desc 'Thin App Server'
  package thin: :basic do
    apply_once do
      box.bash 'gem install thin'
    end
    verify{box.bash('thin -v') =~ /thin/}
  end
end