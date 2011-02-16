class Git < ClusterManagement::Service
  def install
    apply_once :install do
      require Services::SystemTools => :install
      
      logger.info "installing Git to #{box}"
      
      box.bash 'packager install git-core'
    
      box.bash 'git --version', /git version/
    end
    self
  end
end