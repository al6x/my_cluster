class RadCommonInterface < ClusterManagement::Project
  tag :app
  
  project_options(
    requires: [
      :basic,
      :rad_face, :rad_js
    ],
    name: 'rad_common_interface'
  )
end