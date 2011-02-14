class Users < ClusterManagement::Project
  project_options(
    require: {
      Services::Basic => :install,
      Services::Fs => :install,
      
      Projects::RadKit => :install
    },
    name: 'users',
    git: 'git@github.com:alexeypetrushin/users.git',
    skip_spec: true
  )
end