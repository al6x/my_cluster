class RadExt < ClusterManagement::Project
  tag 'app'
  
  project_options(
    requires: [
      :basic, :thin,
      :rad_core
    ],
    name: 'rad_ext'
  )
  
  def install_apply_once box
    text = <<-BASH
  
# rad
function rad(){
#{config.projects_path!}/rad_ext/bin/rad $*
}
    BASH
    unless box.env_file.content.include? text
      box.env_file.append text
      box.reload_env
    end    
  end
  
  def install_verify box
    box.bash 'rad -v', /Rad/
  end
end