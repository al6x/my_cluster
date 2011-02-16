class Basic < ClusterManagement::Service
  def install
    apply_once :install do
      require(
        Services::Os => :install,        
        Services::Ruby => :install,
        Services::Git => :install,
        Services::Security => :install,
        Services::ManualManagement => :install,
        Services::FakeGem => :install,
        Services::CustomRuby => :install,
      )
    end
    self
  end
end