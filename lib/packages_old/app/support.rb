def app_task options
  name = options.delete(:name)
  git = options.delete(:git) || "git://github.com/alexeypetrushin/#{name}.git"
  apply_once_block, verify_block = options.delete(:apply_once), options.delete(:verify)
  
  box_task options do
    apps = box[config.apps_path!]
    app = apps[name]
    
    apply_once do
      app.destroy
      logger.info "  clonning git"
      apps.bash "git clone #{git}"
      
      logger.info "  installing gems"      
      out = app.bash('rake gem:install')
      if out =~ /Error/
        puts out
        raise 'Error during gem installation'
      end
      
      logger.info "  running specs"
      app.bash 'rake', /0 failures/
      
      instance_eval(&apply_once_block) if apply_once_block
    end
    verify do 
      app.dir.exist? and (verify_block ? instance_eval(&verify_block) : true)
    end
  end
end