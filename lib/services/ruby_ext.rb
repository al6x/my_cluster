class RubyExt < ClusterManagement::Project
  tag :app
  
  version 2
  project_options(
    requires: [:basic],
    name: 'ruby_ext'
  )
end