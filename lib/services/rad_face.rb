class RadFace < ClusterManagement::Project
  tag :app
  
  project_options(
    requires: [:basic, :rad_core],
    name: 'rad_face'
  )
end