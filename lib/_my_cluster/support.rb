runtime_dir = "#{__FILE__}/../../..".to_dir.to_s
cluster.configure runtime_dir

# 
# Boxes
# 
# def boxes
#   $boxes ||= {}
# end
# 
# config.servers!.to_h.each do |host, roles|            
#   box = config.ssh? ? Box.new(host.to_s, config.ssh.to_h) : Box.new(host.to_s)  
#   box.open
#   
#   roles.each do |role|
#     (boxes[role.to_sym] ||= []) << box
#   end  
#   (boxes[:all] ||= []) << box
# end
# 
# raise "db server not defined!" unless boxes[:db]
# raise "can't support more than one db server!" if boxes[:db] and (boxes[:db].size > 1)
# boxes[:db] = boxes[:db].first
# 
# raise "fs server not defined!" unless boxes[:fs]
# raise "can't support more than one fs server!" if boxes[:fs] and (boxes[:fs].size > 1)
# boxes[:fs] = boxes[:fs].first