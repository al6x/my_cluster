class RadThemes < ClusterManagement::Project
  tag 'app'
  
  project_options(
    requires: [:rad_common_interface],
    name: 'rad_themes'
  )
end