FROM sonroyaalmerol/steamcmd-arm64:root AS build_stage

LABEL maintainer="ponfertato@ya.ru"
LABEL description="A Dockerised version of the Garry's Mod dedicated server for ARM64 (using box86)"

RUN dpkg --add-architecture amd64 \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    net-tools \
    lib32gcc-s1:amd64 \
    lib32stdc++6 \
    lib32z1 \
    libcurl3-gnutls:i386 \
    libcurl4-gnutls-dev:i386 \
    libcurl4:i386 \
    libgcc1 \
    libncurses5:i386 \
    libsdl1.2debian \
    libtinfo5 \
    && wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && dpkg -i libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && rm libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && rm -rf /var/lib/apt/lists/*

ENV HOMEDIR="/home/steam" \
    STEAMAPPID="4020" \
    STEAMAPPDIR="/home/steam/garrysmod-server"

COPY etc/entry.sh ${HOMEDIR}/entry.sh

WORKDIR ${STEAMAPPDIR}

RUN chmod +x "${HOMEDIR}/entry.sh" \
    && chown -R "${USER}":"${USER}" "${HOMEDIR}/entry.sh" ${STEAMAPPDIR}

FROM build_stage AS bookworm-root

ENV GM_ARGS="" \
    GM_CLIENTPORT="27005" \
    GM_GAMEMODE="sandbox" \
    GM_IP="" \
    GM_MAP="gm_construct" \
    GM_MAXPLAYERS="12" \
    GM_PORT="27015" \
    GM_SERVERCFG="" \
    GM_SOURCETVPORT="27020" \
    GM_STEAMTOKEN="CHANGEME" \
    GM_TICKRATE="" \
    GM_WORKSHOP=""

EXPOSE ${GM_CLIENTPORT}/udp \
    ${GM_PORT}/tcp \
    ${GM_PORT}/udp \
    ${GM_SOURCETVPORT}/udp

USER ${USER}

WORKDIR ${HOMEDIR}

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD netstat -l | grep "${GM_PORT}.*LISTEN"

CMD ["bash", "entry.sh"]