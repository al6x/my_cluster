namespace :web_server do
  desc 'web server'
  box_task(
    install: %w(
      nginx:install
    )
  )
end

namespace :nginx do
  desc "nginx"
  box_task install: 'basic:install' do
    apply_once do
      box.bash 'packager install nginx'
      "#{__FILE__.dirname}/web_server/nginx.sh".to_file.append_to_environment_of box
    end
    verify{box.bash('which nginx') =~ /nginx/}
  end
end