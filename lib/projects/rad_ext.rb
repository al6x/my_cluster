class RadExt < ClusterManagement::Project
  project_options(
    require: [
      Services::Basic,
      Services::Thin,
      
      Projects::RadCore
    ],
    name: 'rad_ext'
  )
  
  def install_apply_once
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
  
  def install_verify
    box.bash 'rad -v', /Rad/
  end
end