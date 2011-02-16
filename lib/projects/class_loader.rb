class ClassLoader < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic
    ],
    name: 'class_loader'
  )
end