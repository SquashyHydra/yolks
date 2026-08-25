#!/bin/bash

set -e

cd /home/container

# Fix permissions in case Pterodactyl mounted files
# are owned by a different UID/GID.
if [ "$(id -u)" = "0" ]; then
    chown -R container:container /home/container
    if [ -f "/home/container/env/dist/etc/azerothcore.conf.dist" ]; then
        cp /home/container/env/dist/etc/azerothcore.conf.dist /home/container/env/dist/etc/azerothcore.conf
        chown container:container /home/container/env/dist/etc/azerothcore.conf
    fi
    if [ -f "/home/container/env/dist/etc/worldserver.conf.dist" ]; then
        cp /home/container/env/dist/etc/worldserver.conf.dist /home/container/env/dist/etc/worldserver.conf
        chown container:container /home/container/env/dist/etc/worldserver.conf
    fi
    exec su -s /bin/bash container -c "$*"
fi

# If no command was supplied, open bash.
if [ $# -eq 0 ]; then
    exec /bin/bash
fi

# Execute the command supplied by Pterodactyl.
exec "$@"