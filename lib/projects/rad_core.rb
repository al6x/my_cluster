class RadCore < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic,
      Services::Thin,
      
      Projects::RubyExt,
      Projects::Micon,
      Projects::Vfs,
      Projects::ClassLoader
    ],
    name: 'rad_core'
  )
end