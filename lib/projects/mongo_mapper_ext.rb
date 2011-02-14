class MongoMapperExt < ClusterManagement::Project
  project_options(
    require: {
      Services::Basic => :install,
      
      Services::Mongodb => :started
    },
    name: 'mongo_mapper_ext'
  )
end