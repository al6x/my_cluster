folders = {
  '/apps/spaces/shared/fs' => '/spaces/shared',
  '/apps/service_mix/shared/fs' => '/service_mix/shared'
}

databases = [
  "accounts_production",
  "global_production"
]

backup_directory = '/Users/alex/Documents/saas4b_backup'
user = 'web'
host = 'saas4b.com'

namespace :backup do
  task :mongodb do
    backup_dir = config.backup_path!.to_dir
    backup_dir.create!
  
    box = ClusterManagement.box
    
    flush_and_lock = <<-JavaScript
db.getSisterDB(name);

    JavaScript
  end
end

task :backup do
    
  # Create Databases Dump
  Net::SSH.start(host, user) do |ssh|
    databases.each do |dbname|
      command = "/opt/mongodb/bin/mongodump --db #{dbname} --out /tmp/#{dbname}.mongo.dump"
      puts "Executing Remotelly: #{command}"      
      result = ssh.exec!(command)
      puts result      
    end
  end
  
  # Copying Database
  databases.each do |dbname|    
    dump_file = "/tmp/#{dbname}.mongo.dump"
    backup_tmp_file = "#{backup_directory}/#{dbname}.tmp"
    command = "rsync -e 'ssh' -al --delete --stats --progress #{user}@#{host}:#{dump_file}/ #{backup_tmp_file}"
    puts "Executing: #{command}"
    system command
    
    raise "Can't find downloaded dump file for #{dbname} Database (#{backup_tmp_file})!" unless File.exist? backup_tmp_file
    backup_file = "#{backup_directory}/#{dbname}.mongo.dump"
    FileUtils.rm_r backup_file if File.exist? backup_file
    File.rename backup_tmp_file, backup_file
  end
  
  # Remove tmp dump files
  Net::SSH.start(host, user) do |ssh|
    databases.each do |dbname|
      command = "rm -r /tmp/#{dbname}.mongo.dump"
      puts "Executing Remotelly: #{command}"      
      result = ssh.exec!(command)
      puts result      
    end
  end
  
  # Copying Data Files
  folders.each do |from, to|
    to_full_path = "#{backup_directory}#{to}"
    FileUtils.mkdir_p to_full_path unless File.exist? to_full_path
    command = "rsync -e 'ssh' -al --delete --stats --progress #{user}@#{host}:#{from} #{to_full_path}"
    puts "Executing: #{command}"
    system command
  end
  
  puts "Backup finished!"
end

