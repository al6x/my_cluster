class Micon < ClusterManagement::Project
  tag :app
  
  project_options(
    requires: [:basic],
    name: 'micon'
  )
end