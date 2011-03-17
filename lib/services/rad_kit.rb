class RadKit < ClusterManagement::Project
  tag 'app'
  
  project_options(
    requires: [
      :basic,
      :rad_core, :rad_ext, :rad_common_interface, :mongo_mapper_ext, :rad_saas
    ],
    name: 'rad_kit'
  )
end