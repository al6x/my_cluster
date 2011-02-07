desc 'web server'
package :web_server => %w(nginx).collect{|name| "web_server:#{name}"}

namespace :web_server do
  desc "nginx"
  package nginx: :basic do
    apply_once do
      box.bash 'packager install nginx'
      box.append_to_environment "#{__FILE__.dirname}/web_server/nginx.sh".to_file
    end
    verify{box.bash('which nginx') =~ /nginx/}
  end
end