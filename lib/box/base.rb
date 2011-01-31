namespace :box do  
  desc 'Checks OS version'
  package :os do |pkg|
    pkg.verify{|box| box.bash('cat /etc/lsb-release') =~ /Ubuntu.*10/}
  end
  
  desc 'apt'
  package :apt => :os do |pkg|
    pkg.apply_once do |box|
      box.apt 'update', true
      box.apt 'upgrade', true
    end
  end
  
  desc 'Makes box handy for manual management'
  package :manual_management => [:os, :apt] do |pkg|
    pkg.apply_once do |box|
      box.apt 'install mc'
      box.apt 'install locate'

      authorized_keys_path = "#{config.config_dir!}/authorized_keys"
      if File.exist? authorized_keys_path
        log_operation 'installing authorized_keys' do
          ssh_dir = '~/.ssh'
          box.create_directory ssh_dir unless box.directory_exist? ssh_dir

          authorized_keys_remote_path = '~/.ssh/authorized_keys'
          box.remove_file authorized_keys_remote_path if box.file_exist? authorized_keys_remote_path
          box.upload_file authorized_keys_path, authorized_keys_remote_path
        end
      end    
    end
    
    pkg.verify{|box| box.bash('which mc') =~ /mc/}
  end  
  
  desc 'build-essential'
  package :build_essential => :apt do |pkg|
    pkg.apply_once do |box|
      box.apt 'install build-essential bison autoconf'
    end
    pkg.verify{|box| box.bash('make -v') =~ /GNU Make/}
  end  
  
  desc 'git'
  package :git => :core do |pkg|
    pkg.apply_once do |box|
      box.apt 'install git-core'
    end
    pkg.verify{|box| box.bash('git --version') =~ /git version/}
  end
    
  desc 'rvm'
  package :rvm => [:apt, :build_essential] do |pkg|
    pkg.apply_once do |box|
      box.bash 'bash < <( curl -L http://bit.ly/rvm-install-system-wide )', true
    end
    pkg.verify{|box| box.bash('rvm info') =~ /version.*rvm/}
  end  
  
  desc 'ruby'
  package :ruby => :rvm do |pkg|        
    pkg.apply_once do |box|
      box.bash 'rvm install 1.9.2'
      box.bash 'rvm --default use 1.9.2'
    end    
    pkg.verify{|box| box.bash('ruby -v') =~ /ruby 1.9.2/}
  end  
  
  desc 'Box with basic packages installed'
  package :base => [:ruby, :git, :manual_management]
end