function mysql(){
  method=$1;
  if [ "$method" = "start" ]; then
    shift; mysql.server start $*
	elif [ "$method" = "stop" ]; then    
    shift; mysql.server stop $*
  elif [ "$method" = "shell" ]; then    
    shift; /usr/local/bin/mysql $*
  else
    mysql.server $*
  fi
}