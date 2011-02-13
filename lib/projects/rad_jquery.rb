class RadJquery < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install,
        
        Projects::RadCore => :install
      },
      name: 'rad_jquery'
    }
  end
end