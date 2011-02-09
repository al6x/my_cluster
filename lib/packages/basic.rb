desc 'Basic box for my cluster (used as a base for another packages)'
package basic: %w(ruby git security manual_management fake_gem custom_ruby).collect{|name| "basic:#{name}"}

namespace :basic do
  desc 'Checks OS version and add some very basic stuff'
  package :os do
    apply_once do
      [config.app_path!, config.data_path!].each do |dir| 
        box[dir].create
      end                  
    end
    verify{box.bash('cat /etc/lsb-release') =~ /DISTRIB_RELEASE=10.04/}    
  end
  
  
  desc 'security'
  package :security do
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
    
    
  desc 'System tools, mainly for build support'
  package system_tools: :os do
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
      )
      box.bash "packager install #{tools.join(' ')}"
    end
  end  
  
  
  desc 'Makes box handy for manual management'
  package manual_management: [:os, :security, :system_tools] do
    apply_once do
      box.bash 'packager install mc'
      box.bash 'packager install locate'

      authorized_keys, target = "#{config.config_dir!}/authorized_keys".to_file, box['~/.ssh/authorized_keys']
      authorized_keys.copy_to! target if authorized_keys.exist?
      # box.upload_file authorized_keys, remote_path, override: true if File.exist? authorized_keys
    end    
    verify{box.bash('which mc') =~ /mc/}
  end
  
  
  desc 'git'
  package git: :system_tools do
    apply_once do
      box.bash 'packager install git-core'
    end
    verify{box.bash('git --version') =~ /git version/}
  end
    
    
  # desc 'rvm'
  # package rvm: [:system_tools] do
  #   apply_once do
  #     box.bash 'bash < <( curl -L http://bit.ly/rvm-install-system-wide )', true
  #   end
  #   verify{box.bash('rvm info') =~ /version.*rvm/}
  # end  
  
  
  desc 'ruby'
  package ruby: :system_tools do        
    apply_once do
      installation_dir = '/usr/local/ruby'
      ruby_name = "ruby-1.9.2-p136"
      
      log_operation 'building' do
        box.tmp do |tmp|
          tmp.bash "wget ftp://ftp.ruby-lang.org//pub/ruby/1.9/#{ruby_name}.tar.gz"
          tmp.bash "tar -xvzf #{ruby_name}.tar.gz"
                      
          src_dir = tmp[ruby_name]
          src_dir.bash "./configure --prefix=#{installation_dir}"
          src_dir.bash 'make && make install'
        end
      end
      
      log_operation 'configuring' do
        box.home('.gemrc').write! "gem: --no-ri --no-rdoc\n"
      end

      log_operation 'updating environment' do
        bindir = "#{installation_dir}/bin"
        unless box.env_file.content =~ /PATH.*#{bindir}/
          box.env_file.append %(\nexport PATH="$PATH:#{bindir}"\n)
          box.reload_env
        end
      end
    end    
    verify{box.bash('ruby -v') =~ /ruby 1.9.2/}
  end
    
  
  desc "fake_gem"
  package fake_gem: :ruby do
    apply_once do
      box["#{config.app_path!}/fake_gem"].destroy
      fg_git = "git://github.com/alexeypetrushin/fake_gem.git"
      box[config.app_path!].bash "git clone #{fg_git}"
    end
    verify{box["#{config.app_path!}/fake_gem/lib/fake_gem.rb"].exist?}
  end
  
  
  desc 'custom ruby (with encoding globally set to unicode and enabled fake_gem hack)'
  package custom_ruby: :fake_gem do
    apply_once do
      unless box.env_file.content =~ /FAKE_GEM_PATH/
        text = <<-BASH
      
# custom ruby
export FAKE_GEM_PATH="#{config.app_path!}"
export RUBYOPT="-Ku -rrubygems -r#{config.app_path!}/fake_gem/lib/fake_gem.rb"        
        BASH
      
        box.env_file.append text
        box.reload_env
      end
    end
    verify{box.bash('ruby -v') =~ /ruby/}
  end
end

