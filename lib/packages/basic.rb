namespace :basic do
  desc 'Basic box for my cluster (used as a base for another packages)'
  box_task install: %w(
    ruby:install
    git:install
    security:install
    manual_management:install
    fake_gem:install
    custom_ruby:install
  )
end

namespace :os do
  desc 'Checks OS version and add some very basic stuff'
  box_task :install do
    apply_once do
      [config.apps_path!, config.data_path!].each do |dir| 
        box[dir].create
      end                  
    end
    verify{box.bash('cat /etc/lsb-release') =~ /DISTRIB_RELEASE=10.04/}    
  end
end
  
namespace :security do  
  desc 'security'
  box_task install: 'os:install' do
    apply_once do      
      ssh_config = "#{config.config_dir!}/ssh_config".to_file
      ssh_config.copy_to! box['/etc/ssh/ssh_config'] if ssh_config.exist?
      # box.upload_file ssh_config, '/etc/ssh/ssh_config', override: true if File.exist? ssh_config
      
      box.dir("~/.ssh").create
      # box.create_directory "~/.ssh", silent: true
      {
        "#{config.config_dir!}/id_rsa".to_file => "~/.ssh/id_rsa",
        "#{config.config_dir!}/id_rsa.pub".to_file => "~/.ssh/id_rsa.pub"
      }.each do |from, to|        
        # box.upload_file from, to, override: true if File.exist? from
        from.copy_to! box[to] if from.exist?
      end
      box.bash "chmod -R go-rwx ~/.ssh"
    end
  end
end

   
namespace :system_tools do
  desc 'System tools, mainly for build support'
  box_task install: 'os:install', version: 3 do
    apply_once do      
      "#{__FILE__.dirname}/basic/system_tools.sh".to_file.append_to_environment_of box
      
      box.bash 'packager update'
      box.bash 'packager upgrade'
      
      tools = %w(        
        gcc 
        g++ 
        build-essential 
        libssl-dev 
        libreadline5-dev 
        zlib1g-dev 
        linux-headers-generic 
        bison 
        autoconf 
        htop
        libxml2-dev
        libxslt-dev
      )
      box.bash "packager install #{tools.join(' ')}"
    end
  end  
end
  
namespace :manual_management do
  desc 'Makes box handy for manual management'
  box_task install: %w(os:install security:install system_tools:install) do
    apply_once do
      box.bash 'packager install mc'
      box.bash 'packager install locate'

      authorized_keys, target = "#{config.config_dir!}/authorized_keys".to_file, box['~/.ssh/authorized_keys']
      authorized_keys.copy_to! target if authorized_keys.exist?
      # box.upload_file authorized_keys, remote_path, override: true if File.exist? authorized_keys
    end    
    verify{box.bash('which mc') =~ /mc/}
  end
end  
  
namespace :git do
  desc 'git'
  box_task install: 'system_tools:install' do
    apply_once do
      box.bash 'packager install git-core'
    end
    verify{box.bash('git --version') =~ /git version/}
  end
end
      
namespace :ruby do
  desc 'ruby'
  box_task install: 'system_tools:install' do        
    apply_once do
      installation_dir = '/usr/local/ruby'
      ruby_name = "ruby-1.9.2-p136"
      
      logger.info '  building'
      box.tmp do |tmp|
        tmp.bash "wget ftp://ftp.ruby-lang.org//pub/ruby/1.9/#{ruby_name}.tar.gz"
        tmp.bash "tar -xvzf #{ruby_name}.tar.gz"
                    
        src_dir = tmp[ruby_name]
        src_dir.bash "./configure --prefix=#{installation_dir}"
        src_dir.bash 'make && make install'
      end
      
      logger.info '  configuring'
      box.home('.gemrc').write! "gem: --no-ri --no-rdoc\n"

      logger.info '  updating environment'
      bindir = "#{installation_dir}/bin"
      unless box.env_file.content =~ /PATH.*#{bindir}/
        box.env_file.append %(\nexport PATH="$PATH:#{bindir}"\n)
        box.reload_env
      end
    end    
    verify{box.bash('ruby -v') =~ /ruby 1.9.2/}
  end
end    
  
namespace :fake_gem do
  desc "fake_gem"
  box_task install: 'ruby:install' do
    apply_once do
      box["#{config.apps_path!}/fake_gem"].destroy
      fg_git = "git://github.com/alexeypetrushin/fake_gem.git"
      box[config.apps_path!].bash "git clone #{fg_git}"
    end
    verify{box["#{config.apps_path!}/fake_gem/lib/fake_gem.rb"].exist?}
  end
end
  
namespace :custom_ruby do
  desc 'custom ruby (with encoding globally set to unicode and enabled fake_gem hack)'
  box_task install: %w(ruby:install fake_gem:install), version: 2 do
    apply_once do
      logger.info "  fake_gem env"
      unless box.env_file.content =~ /FAKE_GEM_PATH/
        text = <<-BASH
      
# custom ruby
export FAKE_GEM_PATH="#{config.apps_path!}"
export RUBYOPT="-Ku -rrubygems -r#{config.apps_path!}/fake_gem/lib/fake_gem.rb"        
        BASH
      
        box.env_file.append text
        box.reload_env
      end
      
      logger.info "  rspec"
      box.bash 'gem install rspec'
    end
    verify{box.bash('ruby -v') =~ /ruby/}
  end
end

