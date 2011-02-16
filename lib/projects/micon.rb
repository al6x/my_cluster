class Micon < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic
    ],
    name: 'micon'
  )
end