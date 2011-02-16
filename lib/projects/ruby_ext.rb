class RubyExt < ClusterManagement::Project
  version 2
  project_options(
    require: [
      Services::Basic
    ],
    name: 'ruby_ext'
  )
end