class FireNet < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install,
        
        Projects::Users => :install,
        Projects::Bag => :install
      },
      name: '4ire.net',
      git: 'git@github.com:alexeypetrushin/4ire.net.git',
      skip_gems: true,
      skip_spec: true
    }
  end
end