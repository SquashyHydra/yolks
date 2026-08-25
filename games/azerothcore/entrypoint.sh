#!/bin/bash

set -e

cd /home/container

if [ -f "/home/container/env/dist/etc/authserver.conf.dist" ] && [ ! -f "/home/container/env/dist/etc/authserver.conf" ]; then
    cp /home/container/env/dist/etc/authserver.conf.dist /home/container/env/dist/etc/authserver.conf
fi
if [ -f "/home/container/env/dist/etc/worldserver.conf.dist" ] && [ ! -f "/home/container/env/dist/etc/worldserver.conf" ]; then
    cp /home/container/env/dist/etc/worldserver.conf.dist /home/container/env/dist/etc/worldserver.conf
fi

# Fix permissions in case Pterodactyl mounted files
# are owned by a different UID/GID.
#if [ "$(id -u)" = "0" ]; then
#    chown -R container:container /home/container
#fi

# If no command was supplied, open bash.
if [ -z "$STARTUP" ]; then
    exec /bin/bash
fi

# Execute the command supplied by Pterodactyl.
exec $STARTUP