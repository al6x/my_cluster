class Users < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic,
      Services::Fs,
      
      Projects::RadKit
    ],
    name: 'users',
    git: 'git@github.com:alexeypetrushin/users.git',
    skip_spec: true
  )
end