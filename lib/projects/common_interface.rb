class CommonInterface < ClusterManagement::Project
  project_options(
    require: {
      Services::Basic => :install,
      
      Projects::AbstractInterface => :install,
      Projects::RadJquery => :install,
      Projects::AssetPackager => :install
    },
    name: 'common_interface'
  )
end