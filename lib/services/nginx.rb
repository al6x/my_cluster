class Nginx < ClusterManagement::Service
  def install
    apply_once :install do
      require Services::Basic => :install
      
      logger.info "installing Nginx to #{box}"
    
      box.bash 'packager install nginx'
      "#{__FILE__.dirname}/nginx.sh".to_file.append_to_environment_of box

      box.bash 'which nginx', /nginx/
    end
  end
end