#!/bin/bash
docker run -tid \
    -p 27015:27015/udp -p 27005:27005 -p 27030:27030 \
    --name gmod \
    gmod \
    /home/gmod/gmod/srcds_run -game garrysmod +maxplayers 12 +host_workshop_collection 934767722 +gamemode sandbox +map gm_flatgrass +hostname "Frank's Realm"