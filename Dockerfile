FROM ubuntu:xenial

ARG UID=1000
# install dependencies for i368 architecture
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y lib32stdc++6 wget libtinfo5:i386 libncurses5:i386 && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -u ${UID} -m gmod

ENV GMOD_HOME="/home/gmod"

# install steam cmd
RUN su gmod -c "mkdir -p ${GMOD_HOME}/steam && \
    cd ${GMOD_HOME}/steam && \
    wget http://media.steampowered.com/client/steamcmd_linux.tar.gz && \
    tar xzvf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz && \
    chmod u+x steamcmd.sh && \
    ./steamcmd.sh +login anonymous +quit && \
    mkdir -p ${GMOD_HOME}/gmod"

# APP_ID 4020 = garry's mod
ENV APP_ID 4020

USER ${UID}

# install gmod
RUN ${GMOD_HOME}/steam/steamcmd.sh +login anonymous +force_install_dir "${GMOD_HOME}/gmod" +app_update $APP_ID validate +quit

COPY entrypoint.sh ${GMOD_HOME}/entrypoint.sh
WORKDIR ${GMOD_HOME}}
EXPOSE 27015/udp 27005 27030

ENTRYPOINT [ "/home/gmod/entrypoint.sh" ]
