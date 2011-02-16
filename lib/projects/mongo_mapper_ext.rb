class MongoMapperExt < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic,
      
      Services::Mongodb
    ],
    name: 'mongo_mapper_ext'
  )
end