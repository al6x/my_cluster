class Bag < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install,
        Services::Fs => :install,
        
        Projects::RadKit => :install,
        Projects::Users => :install
      },
      name: 'bag',
      git: 'git@github.com:alexeypetrushin/bag.git',
      skip_spec: true
    }
  end
end