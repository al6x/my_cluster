class AbstractInterface < ClusterManagement::Project
  project_options(
    require: {
      Services::Basic => :install, 
      
      Projects::RadCore => :install
    },
    name: 'abstract_interface'
  )
end