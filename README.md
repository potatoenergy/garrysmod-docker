**Garry's Mod Server**
=====================

Run a Garry's Mod server easily inside a Docker container

**Supported tags**
-----------------

* `latest` - the most recent production-ready image, based on `sonroyaalmerol/steamcmd-arm64:root`

**Documentation**
----------------

### Ports
The container uses the following ports:
* `:27015 TCP/UDP` as the game transmission, pings and RCON port
* `:27005 UDP` as the client port

### Environment variables

* `GM_CLIENTPORT`: This variable sets the client port for the server. In this case, it's set to `27005`.

* `GM_GAMEMODE`: This variable sets the gamemode for the server. In this case, it's set to `sandbox`.

* `GM_IP`: This variable sets the IP address for the server. In this case, it's set to an empty string (`""`), which means the server will use the IP address of the host machine.

* `GM_MAP`: This variable sets the map for the server. In this case, it's set to `gm_construct`.

* `GM_MAXPLAYERS`: This variable sets the maximum number of players allowed to join the server. In this case, it's set to `12`.

* `GM_PORT`: This variable sets the port for the server. In this case, it's set to `27015`.

* `GM_SERVERCFG`: This variable sets the server configuration file. In this case, it's set to an empty string (`""`), which means the server will use the default configuration file.

* `GM_SOURCETVPORT`: This variable sets the Source TV port for the server. In this case, it's set to `27020`.

* `GM_STEAMTOKEN`: This variable sets the Steam token for the server. In this case, it's set to `CHANGEME`, which means you need to replace it with your actual Steam token.

* `GM_TICKRATE`: This variable sets the tick rate for the server. In this case, it's set to an empty string (`""`), which means the server will use the default tick rate.

* `GM_WORKSHOP`: This variable sets the workshop collection for the server. In this case, it's set to an empty string (`""`), which means the server will not use a workshop collection.

### Directory structure
It's not the full directory tree, I just put the ones I thought most important

```cs
📦 /home/steam
|__📁garrysmod-server // The server root (garrysmod folder name using env)
|  |__📁garrysmod
|  |  |__📁addons // Put your addons here
|  |  |__📁cache // Cache for srcds (workshop addons) downloads
|  |  |__📁cfg
|  |  |  |__⚙️mount.cfg
|  |  |  |__⚙️server.cfg
|  |  |__📁data
|  |  |__📁gamemodes // Put your gamemodes here
|  |  |__📁lua
|  |  |__📁maps // Put your maps here
|  |  |__💾sv.db
|__📃srcds_run // Script to start the server
|__📃srcds_run-arm64 // Script to start the server on ARM64
```

### Examples

This will start a simple server in a container named `garrysmod-server`:
```sh
docker run -d --name garrysmod-server \
  -p 27005:27005/udp \
  -p 27015:27015 \
  -p 27015:27015/udp \
  -e GM_ARGS="" \
  -e GM_CLIENTPORT=27005 \
  -e GM_GAMEMODE=sandbox \
  -e GM_MAP=gm_construct \
  -e GM_MAXPLAYERS=12 \
  -e GM_PORT=27015 \
  -e GM_STEAMTOKEN="CHANGEME" \
  -v /home/ponfertato/Docker/garrysmod-server/addons:/home/steam/garrysmod-server/addons \
  -v /home/ponfertato/Docker/garrysmod-server/cfg:/home/steam/garrysmod-server/cfg \
  -v /home/ponfertato/Docker/garrysmod-server/cfg/mount.cfg:/home/steam/garrysmod-server/cfg/mount.cfg \
  -v /home/ponfertato/Docker/garrysmod-server/cfg/server.cfg:/home/steam/garrysmod-server/cfg/server.cfg \
  -v /home/ponfertato/Docker/garrysmod-server/data:/home/steam/garrysmod-server/data \
  -v /home/ponfertato/Docker/garrysmod-server/gamemodes:/home/steam/garrysmod-server/gamemodes \
  -v /home/ponfertato/Docker/garrysmod-server/lua:/home/steam/garrysmod-server/lua \
  -v /home/ponfertato/Docker/garrysmod-server/maps:/home/steam/garrysmod-server/maps \
  -v /home/ponfertato/Docker/garrysmod-server/sv.db:/home/steam/garrysmod-server/sv.db \
  ponfertato/garrysmod:latest
```

...or Docker Compose:
```sh
version: '3'

services:
  garrysmod-server:
    container_name: garrysmod-server
    restart: unless-stopped
    image: ponfertato/garrysmod:latest
    tty: true
    stdin_open: true
    ports:
      - "27005:27005/udp"
      - "27015:27015"
      - "27015:27015/udp"
    environment:
      - GM_ARGS=""
      - GM_CLIENTPORT=27005
      - GM_GAMEMODE=sandbox
      - GM_MAP=gm_construct
      - GM_MAXPLAYERS=12
      - GM_PORT=27015
      - GM_STEAMTOKEN="CHANGEME"
    volumes:
      - ./garrysmod-server/addons:/home/steam/garrysmod-server/addons
      - ./garrysmod-server/cfg:/home/steam/garrysmod-server/cfg
      - ./garrysmod-server/cfg/mount.cfg:/home/steam/garrysmod-server/cfg/mount.cfg
      - ./garrysmod-server/cfg/server.cfg:/home/steam/garrysmod-server/cfg/server.cfg
      - ./garrysmod-server/data:/home/steam/garrysmod-server/data
      - ./garrysmod-server/gamemodes:/home/steam/garrysmod-server/gamemodes
      - ./garrysmod-server/lua:/home/steam/garrysmod-server/lua
      - ./garrysmod-server/maps:/home/steam/garrysmod-server/maps
      - ./garrysmod-server/sv.db:/home/steam/garrysmod-server/sv.db
```

**Health Check**
----------------

This image contains a health check to continually ensure the server is online. That can be observed from the STATUS column of docker ps

```sh
CONTAINER ID        IMAGE                    COMMAND                 CREATED             STATUS                    PORTS                                                                                     NAMES
e9c073a4b262        ponfertato/garrysmod    "/home/steam/entry.sh"   21 minutes ago      Up 21 minutes (healthy)   0.0.0.0:27005->27005/udp, 0.0.0.0:27015->27015/tcp, 0.0.0.0:27015->27015/udp   distracted_cerf
```

**License**
----------

This image is under the [MIT license](licence).
