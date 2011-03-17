class ClassLoader < ClusterManagement::Project
  tag 'app'
  
  project_options(
    requires: [:basic],
    name: 'class_loader'
  )
end