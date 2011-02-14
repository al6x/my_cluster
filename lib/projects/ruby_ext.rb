class RubyExt < ClusterManagement::Project
  version 2
  project_options(
    require: {
      Services::Basic => :install
    },
    name: 'ruby_ext'
  )
end