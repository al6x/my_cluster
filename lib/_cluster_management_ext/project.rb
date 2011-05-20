class ClusterManagement::Project < ClusterManagement::Service
  def install
    apply_once :install do |box|
      (project_options[:requires] || []).each do |service_name| 
        services[service_name].respond_to(:install)
      end
    
      logger.info "installing :#{service_name} to #{box}"
    
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
      
      respond_to :install_apply_once, box

      # verifying
      project.dir.must.exist
      respond_to :install_verify, box
    end
    self
  end
      
  def update     
    install
    (project_options[:requires] || []).each do |service_name| 
      services[service_name].respond_to(:install).respond_to(:update)
    end
  
    boxes do |box|
      logger.info "updating :#{service_name} on #{box}"
    
      project = box[config.projects_path!].dir project_options[:name]
      raise "project #{project_options[:name]} not exist ('#{project}' not exist)!" unless project.exist?
      project.bash "git reset HEAD --hard && git pull"
    end
    
    self
  end    
  cache_method :update
  
  
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