module ClusterManagement
  class Project < Service
    def install
      apply_once :install do
        require project_options[:require]
      
        logger.info "installing #{self.class} to #{box}"
      
        apps = box[config.apps_path!]
        app = apps[project_options[:name]]
      
        logger.info "  clonning git"
        app.destroy
        git = project_options[:git] || "git://github.com/alexeypetrushin/#{project_options[:name]}.git"
        apps.bash "git clone #{git}"
        
        unless project_options[:skip_gems]
          logger.info "  installing gems"      
          out = app.bash('rake gem:install')
          if out =~ /Error/
            puts out
            raise 'Error during gem installation'
          end
        end

        unless project_options[:skip_spec]
          logger.info "  running specs"
          app.bash 'rake', /0 failures/
        end
        
        respond_to :install_apply_once

        # verifying
        app.dir.must.exist
        respond_to :install_verify
      end
    end
    
    
    # 
    # project_options
    # 
    class << self
      inheritable_accessor :project_options, {}
      alias_method :get_project_options, :project_options
      def project_options options = nil
        if options
          get_project_options.merge! options
        else
          get_project_options
        end
      end
    end
    def project_options; self.class.project_options end
  end
end