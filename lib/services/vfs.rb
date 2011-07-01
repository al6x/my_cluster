class Vfs < ClusterManagement::Project
  tag :app
  
  project_options(
    requires: [:basic],
    name: 'vfs'
  )
end