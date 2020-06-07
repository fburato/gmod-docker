#!/bin/bash -e
echo "Checking for gmod updates"

/home/gmod/steam/steamcmd.sh +login anonymous +force_install_dir "/home/gmod/gmod" +app_update $APP_ID validate +quit

echo "Running command"

exec "$@"