#!/bin/bash
podman run -tid \
    -p 27015:27015/udp -p 27005:27005 -p 27030:27030 -v gmod:/data \
    --name gmod \
    gmod \
    /home/gmod/gmod/srcds_run -game garrysmod +maxplayers 12 +host_workshop_collection 934767722 +gamemode prop_hunt +map cs_assault +hostname "Frank's Realm"
    