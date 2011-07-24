class CodeHighlighter < ClusterManagement::Service
  tag :app
  
  def install
    services.ruby.install
    
    apply_once :install do |box|            
      logger.info "installing :#{service_name} to #{box}"
      
      box.bash 'packager install python-setuptools'
      box.bash 'easy_install Pygments'
      box.bash 'gem install albino'
      
      box.bash %{ruby -e "require('albino'); puts(Albino.colorize(%(puts 'Hello World'), :ruby))"}, /span/i
    end
    self
  end
end