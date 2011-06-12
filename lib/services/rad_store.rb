class RadStore < ClusterManagement::Project
  tag 'app'
  
  project_options(
    requires: [
      :basic, :fs,
      :rad_kit, :rad_users
    ],
    name: 'rad_store',
    git: 'git@github.com:alexeypetrushin/rad_store.git'
  )
end