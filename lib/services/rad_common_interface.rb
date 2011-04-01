class RadCommonInterface < ClusterManagement::Project
  tag 'app'
  
  project_options(
    requires: [
      :basic,
      :rad_abstract_interface, :rad_js, :rad_asset_packager
    ],
    name: 'rad_common_interface'
  )
end