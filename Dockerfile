FROM ubuntu:xenial

# install dependencies for i368 architecture
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y lib32stdc++6 wget


# install steam cmd
RUN mkdir -p /steam && \
    cd /steam && \
    wget http://media.steampowered.com/client/steamcmd_linux.tar.gz && \
    tar xzvf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz && \
    chmod u+x steamcmd.sh && \
    ./steamcmd.sh +login anonymous +quit

ENV PATH "/steam:$PATH"

# APP_ID 4020 = garry's mod
ENV APP_ID 4020

# install gmod
RUN mkdir -p /gmod && \
    steamcmd.sh +login anonymous +force_install_dir "/gmod" +app_update $APP_ID validate +quit

# install libtinfo5 and libncurses5 for x86 architecture
RUN apt-get install -y libtinfo5:i386 libncurses5:i386

WORKDIR /gmod
EXPOSE 27015/udp 27005 27030

ENV MAX_PLAYERS 12
ENV MAP gm_flatgrass
ENV GAMEMODE sandbox
ENV COLLECTION ""
ENV PASSWORD ""
ENV SERVERNAME ""

VOLUME /gmod/garrysmod/data
VOLUME /gmod/garrysmod/cache
VOLUME /gmod/garrysmod/cfg

CMD ./srcds_run -game garrysmod \
        +maxplayers $MAX_PLAYERS \
        +map $MAP \
        $(if [ "$COLLECTION" != "" ] ; then echo "+host_workshop_collection $COLLECTION" ; fi )\
        $(if [ "$PASSWORD" != "" ] ; then echo "+sv_password $PASSWORD" ; fi ) \
        $(if [ "$GAMEMODE" != "" ] ; then echo "+gamemode $GAMEMODE" ; fi ) \
        $(if [ "$SERVERNAME" != "" ] ; then echo "+hostname \"$SERVERNAME\"" ; fi )
