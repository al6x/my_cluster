class AssetPackager < ClusterManagement::Project
  project_options(
    require: {
      Services::Basic => :install, 
      
      Projects::RadCore => :install
    },
    name: 'asset_packager'
  )
end