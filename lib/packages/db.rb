desc 'db'
package :db => %w(mongodb).collect{|name| "db:#{name}"}

namespace :db do  
  desc 'MongoDB'
  package mongodb: :basic do
    data_dir = "#{config.data_path!}/mongodb"
    apply_once do      
      box.bash 'packager install mongodb'      
      box[data_dir].create
      
      box.append_to_environment "#{__FILE__.dirname}/db/mongodb.sh".to_file
    end
    verify do 
      (box.bash('mongo --version') =~ /MongoDB/) and 
      (box[data_dir].dir?)
    end
  end
end

