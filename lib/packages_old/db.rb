namespace :db do
  desc 'db'
  box_task(
    install: %w(
      mongodb:install
    )
  )
end

namespace :mongodb do  
  desc 'MongoDB'
  box_task install: 'basic:install', version: 3 do
    data_dir = "#{config.data_path!}/db"
    apply_once do      
      box.bash 'packager install mongodb'      
      box[data_dir].create
      
      box.tmp do |tmp|
        template = "#{__FILE__.dirname}/db/mongodb.sh".to_file
        script = tmp[template.name].write template.read.gsub("%{data_dir}", data_dir)
        script.append_to_environment_of box
      end
    end
    verify do 
      (box.bash('mongo --version') =~ /MongoDB/) and 
      (box[data_dir].dir?)
    end
  end
end