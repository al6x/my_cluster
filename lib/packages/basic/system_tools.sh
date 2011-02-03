# apt-get
function packager(){
  method=$1;
  if [ "$method" = "list" ]; then
    shift; dpkg -l $*
  elif [ "$method" = "search" ]; then
    shift; aptitude search $*
  else
    apt-get $*
  fi
}

# htop
alias profiler="htop"