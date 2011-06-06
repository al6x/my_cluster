class MongoidExt < ClusterManagement::Project
  tag 'app'
  
  project_options(
    name: 'mongoid_ext'
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