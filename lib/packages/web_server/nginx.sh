# nginx
function nginx(){
  method=$1;
  if [ "$method" = "start" ]; then
    shift; /etc/init.d/nginx start $*;
	elif [ "$method" = "stop" ]; then
		shift; /etc/init.d/nginx stop $*;
  elif [ "$method" = "restart" ]; then	
    shift; /etc/init.d/nginx restart $*;
  else
    /etc/init.d/nginx $*;
  fi
}