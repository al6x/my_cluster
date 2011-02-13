class RadKit < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install,
        
        Projects::RadCore => :install,
        Projects::CommonInterface => :install,
        Projects::MongoMapperExt => :install
      },
      name: 'rad_kit'
    }
  end
end