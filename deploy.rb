require 'ruby_ext'

set :stages, %w(production)
set :default_stage, "production"

require 'capistrano/ext/multistage'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, true
# set :scm_verbose, true 

# require "#{File.dirname __FIlE__}/additional"

namespace :gems do
  desc "Install gems"
  task :install, :roles => :app do
    sudo "cd #{current_path} && rake RAILS_ENV=production gems:install", :as => 'root'
  end
end

namespace :deploy do  
  task :default do
    update_code
    custom_symlinks
    pack_assets
    delete_dev_stuff
    symlink
    restart
  end
  
  task :set_permissions do
    sudo "sudo chown #{user} -R #{deploy_to}"
  end
  
  task :custom_symlinks do
    # themes symlink
    run "ln -s #{release_path}/vendor/plugins/common_interface/public/common_interface #{release_path}/public/common_interface"
    
    # rails-ext symlink
    run %{ruby -e "require 'rubygems'; require 'rails_ext/micelaneous/create_public_symlinks'; RailsExt.create_public_symlinks!('#{release_path}')"}
    
    # config
    %w{database.yml setting.yml sunspot.yml}.each do |file|
      run "ln -s #{shared_path}/config/#{file} #{release_path}/config/#{file}"
    end
    
    # solr
    solr_dir = "#{shared_path}/solr"
    run "mkdir -p #{solr_dir}" unless File.exists? solr_dir 
    run "ln -s #{solr_dir} #{release_path}/solr_dir"
  end
  
  task :pack_assets do
    run "cd #{release_path} && rake RAILS_ENV=#{rails_env} asset:packager:build_all --trace"
  end
  
  task :delete_dev_stuff do
    # run "cd #{release_path}/vendor/plugins && rm -r annotate_models"
  end
    
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
end
after 'deploy:setup', 'deploy:set_permissions'