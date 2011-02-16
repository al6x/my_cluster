class Bag < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic,
      Services::Fs,
      
      Projects::RadKit,
      Projects::Users
    ],
    name: 'bag',
    git: 'git@github.com:alexeypetrushin/bag.git',
    skip_spec: true
  )
end