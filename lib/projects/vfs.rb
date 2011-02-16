class Vfs < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic
    ],
    name: 'vfs'
  )
end