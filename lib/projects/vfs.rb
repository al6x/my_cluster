class Vfs < ClusterManagement::Project
  project_options(
    require: {
      Services::Basic => :install
    },
    name: 'vfs'
  )
end