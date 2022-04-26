#!/bin/bash -e
initVolume () {
  local subdir=$1;
  echo "> Initialising $subdir";
  if [ -e $VOLUME/gmod/$subdir ];
  then
    echo "> $subdir in $VOLUME/gmod detected, linking $subdir";
    if [ -e $HOME/gmod/$subdir ]
    then
      mkdir -p $(dirname $HOME/gmod/$subdir.old);
      mv $HOME/gmod/$subdir $HOME/gmod/$subdir.old;
    fi
    mkdir -p $(dirname $HOME/gmod/$subdir)
    ln -s $VOLUME/gmod/$subdir $HOME/gmod/$subdir;
  elif [ ! -w $VOLUME/gmod ];
  then 
    echo "! Volume $VOLUME/gmod is not writable, starting application with factory $subdir";
  elif [ -e $HOME/gmod/$subdir ]
  then
    echo "> Volume $VOLUME/gmod is writable, populating it with factory $subdir and linking $subdir";
    mkdir -p $(dirname $VOLUME/gmod/$subdir)
    cp -R $HOME/gmod/$subdir $VOLUME/gmod/$subdir;
    mkdir -p $(dirname $HOME/gmod/$subdir.old)
    mv $HOME/gmod/$subdir $HOME/gmod/$subdir.old;
    ln -s $VOLUME/gmod/$subdir $HOME/gmod/$subdir;
  else
    echo "> Volume $VOLUME/gmod is writable, linking $subdir"
    if [[ "$(dirname $VOLUME/gmod/$subdir)" == "$VOLUME/gmod" ]]
    then
      mkdir -p $VOLUME/gmod/$subdir
    else 
      mkdir -p $(dirname $VOLUME/gmod/$subdir)
    fi
    if [ ! -e $VOLUME/gmod/$subdir ]
    then 
      mkdir -p $VOLUME/gmod/$subdir
    fi
    mkdir -p $(dirname $HOME/gmod/$subdir)
    ln -s $VOLUME/gmod/$subdir $HOME/gmod/$subdir
  fi;
}

echo "> Performing volume initialisation"

initVolume "garrysmod/cfg"
initVolume "garrysmod/addons"
initVolume "garrysmod/settings"
initVolume "garrysmod/gamemodes"
initVolume "garrysmod/data"
initVolume "steam_cache"

echo "> Running command"

exec "$@"