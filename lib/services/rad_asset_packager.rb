class RadAssetPackager < ClusterManagement::Project
  tag 'app'
  
  project_options(
    requires: [:basic, :rad_core],
    name: 'rad_asset_packager'
  )
end