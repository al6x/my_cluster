class Vfs < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install
      },
      name: 'vfs'
    }
  end
end