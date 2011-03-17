class RadCore < ClusterManagement::Project
  tag 'app'
  
  project_options(
    requires: [
      :basic, :thin,
      :ruby_ext, :micon, :vfs, :class_loader
    ],
    name: 'rad_core'
  )
end