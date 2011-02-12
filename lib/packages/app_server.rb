namespace :app_server do
  desc 'app server'
  box_task :install => %w(
    thin:install
  )
end

namespace :thin do
  desc 'Thin App Server'
  box_task install: 'basic:install' do
    apply_once do
      box.bash 'gem install thin'
    end
    verify{box.bash('thin -v') =~ /thin/}
  end
end