class AssetPackager < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install, 
        
        Projects::RadCore => :install
      },
      name: 'asset_packager'
    }
  end
end