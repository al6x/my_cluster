desc 'web server'
package :web_server => %w(nginx).collect{|name| "web_server:#{name}"}

namespace :web_server do
  desc "nginx"
  package nginx: :basic do
    apply_once do
      box.packager "install nginx"      
      box.append_to "/etc/environment", File.read("#{__FILE__.dirname}/web_server/nginx.sh"), reload: true
    end
    verify{|box| box.bash('nginx -v', ignore_stderr: true) =~ /nginx/}
  end
end