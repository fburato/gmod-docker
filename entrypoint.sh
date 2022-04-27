#!/bin/bash -e

initVolume () {
  local subdir=$1
  local remote=$VOLUME/gmod/$subdir
  local internal=$HOME/gmod/$subdir
  echo "> Initialising $subdir"
  if [ ! -w $VOLUME/gmod ]
  then 
    echo "! Volume $VOLUME/gmod is not writable, starting application with factory $subdir";
    return
  fi
  if [ ! -e $internal ]
  then 
    mkdir -p $internal
  fi
  # $VOLUME/gmod is writable, $HOME/gmod/$subdir exists
  if [ ! -e $remote ]
  then
    echo "> Volume $remote does not exist, creating and initialising with content from $internal"
    mkdir -p $remote
    cp -R $internal $(dirname $remote)
  fi
  echo "> Linking $remote to $internal"
  # $VOLUME/gmod/$subdir contains all the necessary content
  rm -rf $internal
  ln -s $remote $(dirname $internal)
}

echo "> Performing volume initialisation"

initVolume "garrysmod/cfg"
initVolume "garrysmod/addons"
initVolume "garrysmod/settings"
initVolume "garrysmod/gamemodes"
initVolume "garrysmod/data"
initVolume "garrysmod/cache"
initVolume "steam_cache"

echo "> Running command"

exec "$@"