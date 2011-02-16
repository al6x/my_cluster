class AbstractInterface < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic,
      Projects::RadCore
    ],
    name: 'abstract_interface'
  )
end