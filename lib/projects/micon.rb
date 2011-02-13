class Micon < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install
      },
      name: 'micon'
    }
  end
end