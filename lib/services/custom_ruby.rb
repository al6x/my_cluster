class CustomRuby < ClusterManagement::Service
  def install
    apply_once :install do
      require Services::Ruby => :install, Services::FakeGem => :install
      
      logger.info "installing CustomRuby to #{box}"
      
      logger.info "  fake_gem env"
      unless box.env_file.content =~ /FAKE_GEM_PATH/
        text = <<-BASH
      
# custom ruby
export FAKE_GEM_PATH="#{config.apps_path!}"
export RUBYOPT="-Ku -rrubygems -r#{config.apps_path!}/fake_gem/lib/fake_gem.rb"        
        BASH
      
        box.env_file.append text
        box.reload_env
      end
      
      logger.info "  rspec"
      box.bash 'gem install rspec'

      box.bash 'ruby -v', /ruby/
    end
  end
end