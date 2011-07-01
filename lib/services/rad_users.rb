class RadUsers < ClusterManagement::Project
  tag :app
  
  project_options(
    requires: [
      :basic, :fs,
      :rad_kit
    ],
    name: 'rad_users',
    git: 'git@github.com:alexeypetrushin/rad_users.git',
    skip_spec: true
  )
end