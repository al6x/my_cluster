class MongoMapperExt < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install,
        
        Services::Mongodb => :started
      },
      name: 'mongo_mapper_ext'
    }
  end
end