namespace 'fake_gems' do
  desc 'fake_gems'
  box_task :install => %w(
    abstract_interface:install
    asset_packager:install
    class_loader:install
    common_interface:install
    micon:install
    mongo_mapper_ext:install
    rad_core:install
    rad_ext:install
    rad_jquery:install
    rad_kit:install
    ruby_ext:install
    vfs:install
  )
end


namespace '4ire.net' do
  desc '4ire.net'
  app_task(
    install: %w(basic:install users:install bag:install),
    name: '4ire.net',
    git: 'git@github.com:alexeypetrushin/4ire.net.git'
  )
end


namespace :abstract_interface do
  desc 'abstract_interface'
  app_task(
    install: %w(basic:install rad_core:install),
    name: 'abstract_interface'
  )
end

namespace :asset_packager do
  desc 'asset_packager'
  app_task(
    install: %w(basic:install rad_core:install),
    name: 'asset_packager'
  )
end

namespace :class_loader do
  desc 'class_loader'
  app_task(
    install: %w(basic:install),
    name: 'class_loader'
  )
end


namespace :common_interface do
  desc 'common_interface'
  app_task(
    install: %w(basic:install abstract_interface:install rad_jquery:install),
    name: 'common_interface'
  )
end


namespace :micon do
  desc 'micon'
  app_task(
    install: %w(basic:install),
    name: 'micon'
  )
end


namespace :mongo_mapper_ext do
  desc 'mongo_mapper_ext'
  app_task(
    install: %w(basic:install),
    name: 'mongo_mapper_ext',
    version: 3
  )
end


namespace :rad_core do
  desc 'rad_core'
  app_task(
    install: %w(
      ruby_ext:install 
      micon:install
      vfs:install
      class_loader:install
      
      basic:install 
      app_server:install
    ),
    name: 'rad_core'
  )
end


namespace :rad_ext do
  desc 'rad_ext'
  app_task(
    install: %w(rad_core:install),
    name: 'rad_ext',
    version: 3,
    apply_once: -> obj {
      text = <<-BASH
    
# rad
function rad(){
	#{config.apps_path!}/rad_ext/bin/rad $*
}
      BASH

      unless box.env_file.content.include? text
        box.env_file.append text
        box.reload_env
      end
    },
    verify: -> obj {
      box.bash('rad -v') =~ /Rad/
    }
  )
end


namespace :rad_jquery do
  desc 'rad_jquery'
  app_task(
    install: %w(basic:install rad_core:install),
    name: 'rad_jquery'
  )
end


namespace :rad_kit do
  desc 'rad_kit'
  app_task(
    install: %w(basic:install rad_ext:install),
    name: 'rad_kit'
  )
end


namespace :ruby_ext do
  desc 'ruby_ext'
  app_task(
    install: %w(basic:install),
    name: 'ruby_ext'
  )
end


namespace :vfs do
  desc 'vfs'
  app_task(
    install: %w(basic:install),
    name: 'vfs'
  )
end