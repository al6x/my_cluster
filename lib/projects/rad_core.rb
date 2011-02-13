class RadCore < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install,
        Services::Thin => :install,
        
        Projects::RubyExt => :install,
        Projects::Micon => :install,
        Projects::Vfs => :install,
        Projects::ClassLoader => :install
      },
      name: 'rad_core'
    }
  end
end