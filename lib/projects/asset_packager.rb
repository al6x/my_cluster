class AssetPackager < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic,       
      Projects::RadCore
    ],
    name: 'asset_packager'
  )
end