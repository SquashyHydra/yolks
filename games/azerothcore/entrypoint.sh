#!/bin/bash

set -e

cd /home/container

# If the configuration files don't exist, copy them from the default ones.
if [ -f "/home/container/env/dist/etc/azerothcore.conf.dist" ]; then
    cp /home/container/env/dist/etc/azerothcore.conf.dist /home/container/env/dist/etc/azerothcore.conf
    chown container:container /home/container/env/dist/etc/azerothcore.conf
fi
if [ -f "/home/container/env/dist/etc/worldserver.conf.dist" ]; then
    cp /home/container/env/dist/etc/worldserver.conf.dist /home/container/env/dist/etc/worldserver.conf
    chown container:container /home/container/env/dist/etc/worldserver.conf
fi

# Fix permissions in case Pterodactyl mounted files
# are owned by a different UID/GID.
if [ "$(id -u)" = "0" ]; then
    chown -R container:container /home/container
fi

# If no command was supplied, open bash.
if [ -z "$STARTUP" ]; then
    exec /bin/bash
fi

# Execute the command supplied by Pterodactyl.
exec $STARTUP