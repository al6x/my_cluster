class Ruby < ClusterManagement::Service
  def install
    apply_once :install do
      require Services::SystemTools => :install
      
      logger.info "installing Ruby to #{box}"
      
      installation_dir = '/usr/local/ruby'
      ruby_name = "ruby-1.9.2-p136"
      
      logger.info '  building'
      box.tmp do |tmp|
        tmp.bash "wget ftp://ftp.ruby-lang.org//pub/ruby/1.9/#{ruby_name}.tar.gz"
        tmp.bash "tar -xvzf #{ruby_name}.tar.gz"
                    
        src_dir = tmp[ruby_name]
        src_dir.bash "./configure --prefix=#{installation_dir}"
        src_dir.bash 'make && make install'
      end
      
      logger.info '  configuring'
      box.home('.gemrc').write! "gem: --no-ri --no-rdoc\n"

      logger.info '  updating environment'
      bindir = "#{installation_dir}/bin"
      unless box.env_file.content =~ /PATH.*#{bindir}/
        box.env_file.append %(\nexport PATH="$PATH:#{bindir}"\n)
        box.reload_env
      end
      
      box.bash 'ruby -v', /ruby 1.9.2/
    end
    self
  end
end