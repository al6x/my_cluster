desc 'db'
package :db => %w(mongodb).collect{|name| "db:#{name}"}

namespace :db do  
  desc 'MongoDB'
  package mongodb: :basic do
    apply_once do      
      box.packager 'install mongodb', ignore_stderr: true
      data_dir = "#{config.data_path!}/mongodb"
      box.create_directory data_dir
      
      box.append_to "/etc/environment", File.read("#{__FILE__.dirname}/db/mongodb.sh"), reload: true
    end
    verify do 
      (box.bash('mongo --version') =~ /MongoDB/) and 
      (box.directory_exist?("#{config.data_path!}/mongodb"))
    end
  end
end

