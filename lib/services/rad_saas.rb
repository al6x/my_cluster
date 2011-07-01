class RadSaas < ClusterManagement::Project
  tag :app
  
  project_options(
    requires: [
      :basic, :fs
    ],
    name: 'rad_saas',
    git: 'git@github.com:alexeypetrushin/rad_saas.git',
    skip_spec: true
  )
end