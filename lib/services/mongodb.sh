# MongoDB
function mongodb(){
  method=$1;
  if [ "$method" = "start" ]; then
    shift; mongod --dbpath %{data_dir} --fork --logpath /var/log/mongodb.log --logappend $*
	elif [ "$method" = "stop" ]; then    
    pid=`pidof mongod`
    shift
    kill -2 $pid $*
  elif [ "$method" = "repair" ]; then
    shift; mongod --dbpath %{data_dir} --repair $*
	elif [ "$method" = "dump" ]; then
    shift; mongodump $*
	elif [ "$method" = "restore" ]; then
    shift; mongorestore $*
	elif [ "$method" = "shell" ]; then
    shift; mongo $*
  else
    mongo $*
  fi
}