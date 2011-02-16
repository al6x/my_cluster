module ClusterManagement
  class Project < Service
    def install
      apply_once :install do
        require project_options[:require], :install
      
        logger.info "installing #{self.class} to #{box}"
      
        projects = box[config.projects_path!]
        project = projects[project_options[:name]]
      
        logger.info "  clonning git"
        project.destroy
        git = project_options[:git] || "git://github.com/alexeypetrushin/#{project_options[:name]}.git"
        projects.bash "git clone #{git}"
        
        unless project_options[:skip_gems]
          logger.info "  installing gems"      
          out = project.bash('rake gem:install')
          if out =~ /Error/
            puts out
            raise 'Error during gem installation'
          end
        end

        unless project_options[:skip_spec]
          logger.info "  running specs"
          project.bash 'rake', /0 failures/
        end
        
        respond_to :install_apply_once

        # verifying
        project.dir.must.exist
        respond_to :install_verify
      end
      self
    end
        
    def update
      require project_options[:require], :install
      require project_options[:require], :update
    
      logger.info "updating #{self.class} on #{box}"
      
      project = box[config.projects_path!].dir project_options[:name]
      raise "project #{project_options[:name]} not exist ('#{project}' not exist)!" unless project.exist?
      project.bash "git reset HEAD --hard && git pull"
      self
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