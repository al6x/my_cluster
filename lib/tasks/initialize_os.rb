namespace :os do  
  package :handy_dev do |pkg|
    pkg.applied?{|box| box.has_mark? pkg.name}
    
    pkg.apply do |box|
      log_operation 'installing mc' do
        box.bash "apt-get install mc"
      end

      authorized_keys_path = "#{config.config_dir!}/authorized_keys"
      if File.exist? authorized_keys_path
        log_operation 'installing authorized_keys' do
          ssh_dir = box.home "/.ssh"
          box.create_directory ssh_dir unless box.directory_exist? ssh_dir

          authorized_keys_remote_path = box.home "/.ssh/authorized_keys"
          box.remove_file authorized_keys_remote_path if box.file_exist? authorized_keys_remote_path
          box.upload_file authorized_keys_path, authorized_keys_remote_path
        end
      end    

      box.mark pkg.name
    end
    
    pkg.verify{|box| box.bash('which mc') =~ /mc/}
  end
end