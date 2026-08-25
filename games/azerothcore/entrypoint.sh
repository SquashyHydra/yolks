#!/bin/bash

set -e

cd /home/container

if [ -f "/home/container/env/dist/etc/authserver.conf.dist" ]; then
    cp /home/container/env/dist/etc/authserver.conf.dist /home/container/env/dist/etc/authserver.conf
else
    echo "No authserver.conf.dist file found, this was not expected."
fi
if [ -f "/home/container/env/dist/etc/worldserver.conf.dist" ]; then
    cp /home/container/env/dist/etc/worldserver.conf.dist /home/container/env/dist/etc/worldserver.conf
else
    echo "No worldserver.conf.dist file found, this was not expected."
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