class Users < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install,
        
        Projects::RadKit => :install
      },
      name: 'users',
      git: 'git@github.com:alexeypetrushin/users.git',
      skip_spec: true
    }
  end
end