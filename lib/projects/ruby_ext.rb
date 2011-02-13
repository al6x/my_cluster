class RubyExt < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install
      },
      name: 'ruby_ext'
    }
  end
end