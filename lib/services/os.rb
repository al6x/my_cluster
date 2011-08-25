class Os < ClusterManagement::Service
  tag :basic

  def install
    apply_once :install do |box|
      logger.info "installing :#{service_name} to #{box}"

      box.bash 'cat /etc/lsb-release', /DISTRIB_RELEASE=10/
    end
    self
  end
end