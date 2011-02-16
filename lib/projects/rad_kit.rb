class RadKit < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic,
      
      Projects::RadCore,
      Projects::CommonInterface,
      Projects::MongoMapperExt
    ],
    name: 'rad_kit'
  )
end