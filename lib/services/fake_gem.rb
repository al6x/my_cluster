class FakeGem < ClusterManagement::Service
  def install
    apply_once :install do
      require Services::Ruby => :install
      
      logger.info "installing FakeGem to #{box}"
      
      box["#{config.apps_path!}/fake_gem"].destroy
      fg_git = "git://github.com/alexeypetrushin/fake_gem.git"
      box[config.apps_path!].bash "git clone #{fg_git}"

      box["#{config.apps_path!}/fake_gem/lib/fake_gem.rb"].must.exist
    end
  end
end