class ClassLoader < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install
      },
      name: 'class_loader'
    }
  end
end