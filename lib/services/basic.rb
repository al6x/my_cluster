class Basic < ClusterManagement::Service
  tag :basic

  def install
    services do
      os.install
      ruby.install
      git.install
      security.install
      manual_management.install
      fake_gem.install
      custom_ruby.install
    end

    self
  end
end