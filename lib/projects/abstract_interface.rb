class AbstractInterface < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install, 
        
        Projects::RadCore => :install
      },
      name: 'abstract_interface'
    }
  end
end