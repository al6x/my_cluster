class MongoMapperExt < ClusterManagement::Project
  tag 'app'
  
  project_options(
    name: 'mongo_mapper_ext'
  )
  
  def update
    services do
      basic.install
      mongodb.install.started
    end

    super
  end
  
  def install
    services do
      basic.install      
      mongodb.install.started
    end
    
    super
  end
end