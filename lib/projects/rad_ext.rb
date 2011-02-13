class RadExt < ClusterManagement::Project
  def project_options
    {
      require: {
        Services::Basic => :install,
        Services::Thin => :install,
        
        Projects::RadCore => :install
      },
      name: 'rad_ext'
    }
  end
  
  def install_apply_once
    text = <<-BASH
  
# rad
function rad(){
#{config.apps_path!}/rad_ext/bin/rad $*
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