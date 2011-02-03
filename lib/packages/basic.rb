desc 'Basic box for my cluster (used as a base for another packages)'
package basic: %w(ruby git security manual_management fake_gem custom_ruby).collect{|name| "basic:#{name}"}

namespace :basic do  
  desc 'Checks OS version and add some very basic stuff'
  package :os do
    apply_once do
      [config.app_path!, config.data_path!].each{|dir| box.create_directory dir}
    end
    verify{|box| box.bash('cat /etc/lsb-release') =~ /DISTRIB_RELEASE=10.04/}    
  end
  
  
  desc 'security'
  package :security do
    apply_once do      
      ssh_config = "#{config.config_dir!}/ssh_config"
      box.upload_file ssh_config, '/etc/ssh/ssh_config', override: true if File.exist? ssh_config
      
      box.create_directory "~/.ssh", silent: true
      {
        "#{config.config_dir!}/id_rsa" => "~/.ssh/id_rsa",
        "#{config.config_dir!}/id_rsa.pub" => "~/.ssh/id_rsa.pub"
      }.each do |from, to|        
        box.upload_file from, to, override: true if File.exist? from
      end
      box.bash "chmod -R go-rwx ~/.ssh"
    end
  end
    
    
  desc 'Makes box handy for manual management'
  package manual_management: [:os, :security] do
    apply_once do
      box.packager 'install mc'
      box.packager 'install locate'

      path, remote_path = "#{config.config_dir!}/authorized_keys", '~/.ssh/authorized_keys'
      box.upload_file path, remote_path, override: true if File.exist? path
    end    
    verify{|box| box.bash('which mc') =~ /mc/}
  end  
  
  
  desc 'System tools, mainly for build support'
  package system_tools: :os do
    apply_once do
      box.packager 'update', ignore_stderr: true
      box.packager 'upgrade', ignore_stderr: true
      
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
      box.packager "install #{tools.join(' ')}"
      
      box.append_to environment_file, File.read("#{__FILE__.dirname}/basic/system_tools.sh"), reload: true
    end
  end  
  
  
  desc 'git'
  package git: :system_tools do
    apply_once do
      box.packager 'install git-core'
    end
    verify{|box| box.bash('git --version') =~ /git version/}
  end
    
    
  # desc 'rvm'
  # package rvm: [:system_tools] do
  #   apply_once do
  #     box.bash 'bash < <( curl -L http://bit.ly/rvm-install-system-wide )', true
  #   end
  #   verify{|box| box.bash('rvm info') =~ /version.*rvm/}
  # end  
  
  
  desc 'ruby'
  package ruby: :system_tools do        
    apply_once do
      installation_dir = '/usr/local/ruby'
      ruby_name = "ruby-1.9.2-p136"
      
      log_operation 'building' do
        box.remove_file "#{ruby_name}.tar.gz", silent: true
        box.remove_directory ruby_name, silent: true        
        
        box.bash "wget ftp://ftp.ruby-lang.org//pub/ruby/1.9/#{ruby_name}.tar.gz", ignore_stderr: true
        box.bash "tar -xvzf #{ruby_name}.tar.gz"
                      
        box.bash("cd #{ruby_name} && ./configure --prefix=#{installation_dir}")
        box.bash 'cd #{ruby_name} && make && make install'
        
        box.bash "rm -r #{ruby_name}"
        box.bash "rm #{ruby_name}.tar.gz"
      end

      log_operation 'updating path' do
        environment_file = '/etc/environment'

        tmpdir = Dir.tmpdir
        original_file, updated_file = "#{tmpdir}/env_original", "#{tmpdir}/env_updated"
        box.download_file environment_file, original_file, override: true
      
        content = File.read(original_file)
        path_re = /(?<path>PATH=".*")/
        path = if match = path_re.match(content)
          match[:path]
        else
          %(PATH="")
        end

        bindir = "#{installation_dir}/bin"        
        unless path.include? bindir
          path.insert -2, ":#{bindir}"
          updated_content = content.sub(path_re, path)
      
          File.write(updated_file, updated_content)
          box.upload_file(updated_file, environment_file, override: true)
      
          box.bash ". #{environment_file}"
        end
        [original_file, updated_file].each{|f| File.delete f if File.exist? f}
      end
    end    
    verify{|box| box.bash('ruby -v') =~ /ruby 1.9.2/}
  end
    
  
  desc "fake_gem"
  package :fake_gem do
    apply_once do
      fg_git = "git://github.com/alexeypetrushin/fake_gem.git"
      box.bash "cd #{config.app_path!} && git clone #{fg_git}"
    end
    verify{|box| box.file_exist? "#{config.app_path!}/fake_gem/lib/fake_gem.rb"}
  end
  
  
  desc 'custom ruby (with encoding globally set to unicode and enabled fake_gem hack)'
  package :custom_ruby => :fake_gem do
    apply_once do
      text = <<-BASH
      
# custom ruby
export FAKE_GEM_PATH="#{config.app_path!}"
export RUBYOPT="-Ku -rrubygems -r#{config.app_path!}/fake_gem/lib/fake_gem.rb"        
      BASH
      
      box.append_to '/etc/environment', text, reload: true
    end
    verify{|box| box.bash('ruby -v') =~ /ruby/}
  end
end

