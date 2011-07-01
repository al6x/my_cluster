class RadBag < ClusterManagement::Project
  tag :app
  
  project_options(
    requires: [
      :basic, :fs,
      :rad_kit, :rad_users
    ],
    name: 'rad_bag',
    git: 'git@github.com:alexeypetrushin/rad_bag.git',
    skip_spec: true
  )
end