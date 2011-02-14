class Bag < ClusterManagement::Project
  project_options(
    require: {
      Services::Basic => :install,
      Services::Fs => :install,
      
      Projects::RadKit => :install,
      Projects::Users => :install
    },
    name: 'bag',
    git: 'git@github.com:alexeypetrushin/bag.git',
    skip_spec: true
  )
end