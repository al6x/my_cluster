class Os < ClusterManagement::Service
  def install
    apply_once :install do
      logger.info "installing Os to #{box}"
      
      box.bash 'cat /etc/lsb-release', /DISTRIB_RELEASE=10.04/
    end
  end
end