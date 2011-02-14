class ClassLoader < ClusterManagement::Project
  project_options(
    require: {
      Services::Basic => :install
    },
    name: 'class_loader'
  )
end