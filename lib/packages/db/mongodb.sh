# MongoDB
function mongodb(){
  method=$1;
  if [ "$method" = "start" ]; then
    shift; mongod --dbpath #{data_dir} $*
	elif [ "$method" = "stop" ]; then    
    pid=`pidof mongod`
    shift
    kill -2 $pid $*
  elif [ "$method" = "repair" ]; then
    shift; mongod --dbpath #{data_dir} --repair $*
	elif [ "$method" = "shell" ]; then
    shift; mongo $*
  else
    mongo $*
  fi
}