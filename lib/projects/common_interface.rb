class CommonInterface < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic,
      
      Projects::AbstractInterface,
      Projects::RadJquery,
      Projects::AssetPackager
    ],
    name: 'common_interface'
  )
end