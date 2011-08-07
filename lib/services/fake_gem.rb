class FakeGem < ClusterManagement::Service
  tag :basic
  version 2
  
  def install
    services.ruby.install
    
    apply_once :install do |box|
      logger.info "installing :#{service_name} to #{box}"
      
      box["#{config.projects_path}/fake_gem"].destroy
      fg_git = "git://github.com/alexeypetrushin/fake_gem.git"
      box[config.projects_path].bash "git clone #{fg_git}"

      box["#{config.projects_path}/fake_gem/lib/fake_gem.rb"].must.exist
    end
    self
  end  
end