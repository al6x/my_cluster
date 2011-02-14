class RadJquery < ClusterManagement::Project
  project_options(
    require: {
      Services::Basic => :install,
      
      Projects::RadCore => :install
    },
    name: 'rad_jquery'
  )
end