namespace :box do  
  desc 'Checks OS version'
  package :os do |pkg|
    pkg.verify{|box| box.bash('cat /etc/lsb-release') =~ /DISTRIB_RELEASE=10.04/}
  end
  
  desc 'apt'
  package apt: :os do |pkg|
    pkg.apply_once do |box|
      box.apt 'update', true
      box.apt 'upgrade', true
    end
  end
    
  desc 'Makes box handy for manual management'
  package manual_management: [:os, :apt] do |pkg|
    pkg.apply_once do |box|
      box.apt 'install mc'
      box.apt 'install locate'

      path = "#{config.config_dir!}/authorized_keys"
      if File.exist? path
        log_operation 'installing authorized_keys' do
          ssh_dir = '~/.ssh'
          box.create_directory ssh_dir, silent: true

          remote_path = '~/.ssh/authorized_keys'
          box.upload_file path, remote_path, override: true
        end
      end
    end
    
    pkg.verify{|box| box.bash('which mc') =~ /mc/}
  end  
  
  desc 'build-essential'
  package system_tools: :apt do |pkg|
    pkg.apply_once do |box|
      box.apt 'install gcc g++ build-essential libssl-dev libreadline5-dev zlib1g-dev linux-headers-generic bison autoconf'
    end
    pkg.verify{|box| box.bash('make -v') =~ /GNU Make/}
  end  
  
  desc 'git'
  package git: :system_tools do |pkg|
    pkg.apply_once do |box|
      box.apt 'install git-core'
    end
    pkg.verify{|box| box.bash('git --version') =~ /git version/}
  end
    
  # desc 'rvm'
  # package rvm: [:apt, :system_tools] do |pkg|
  #   pkg.apply_once do |box|
  #     box.bash 'bash < <( curl -L http://bit.ly/rvm-install-system-wide )', true
  #   end
  #   pkg.verify{|box| box.bash('rvm info') =~ /version.*rvm/}
  # end  
  
  desc 'ruby'
  package ruby: :system_tools do |pkg|        
    pkg.apply_once do |box|
      installation_dir = '/usr/local/ruby'
      ruby_name = "ruby-1.9.2-p136"
      
      log_operation 'building' do
        box.remove_file "#{ruby_name}.tar.gz", silent: true
        box.remove_directory ruby_name, silent: true        
        
        box.bash "wget ftp://ftp.ruby-lang.org//pub/ruby/1.9/#{ruby_name}.tar.gz", true
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
    pkg.verify{|box| box.bash('ruby -v') =~ /ruby 1.9.2/}
  end  
  
  desc 'Box with basic packages installed'
  package base: [:ruby, :git, :manual_management]
end

