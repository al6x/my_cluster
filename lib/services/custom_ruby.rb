class CustomRuby < ClusterManagement::Service
  tag :basic
  
  def install
    services do
      ruby.install
      fake_gem.install
    end
    
    apply_once :install do |box|
      logger.info "installing :#{service_name} to #{box}"
      
      logger.info "  fake_gem env"
      unless box.env_file.content =~ /FAKE_GEM_PATH/
        text = <<-BASH
      
# custom ruby
export FAKE_GEM_PATHS="#{config.projects_path}"
export RUBYOPT="-rrubygems -r#{config.projects_path}/fake_gem/lib/fake_gem.rb"        
        BASH
      
        box.env_file.append text
        box.reload_env
      end
      
      logger.info "  rspec"
      box.bash 'gem install rspec'

      box.bash 'ruby -v', /ruby/
    end
    self
  end
end