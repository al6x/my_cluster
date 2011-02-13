class Thin < ClusterManagement::Service
  def install
    apply_once :install do
      require Services::Basic => :install
      
      logger.info "installing Thin to #{box}"
      
      box.bash 'gem install thin'
      
      box.bash 'thin -v', /thin/
    end
  end
end