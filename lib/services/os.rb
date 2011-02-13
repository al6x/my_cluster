class Os < ClusterManagement::Service
  def install
    apply_once do
      [config.apps_path!, config.data_path!].each do |dir| 
        box[dir].create
      end
    
      box.bash 'cat /etc/lsb-release', /DISTRIB_RELEASE=10.04/
    end
  end
end