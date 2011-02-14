class Micon < ClusterManagement::Project
  project_options(
    require: {
      Services::Basic => :install
    },
    name: 'micon'
  )
end