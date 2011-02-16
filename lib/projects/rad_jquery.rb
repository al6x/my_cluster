class RadJquery < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic,
      
      Projects::RadCore
    ],
    name: 'rad_jquery'
  )
end