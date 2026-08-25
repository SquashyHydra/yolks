#!/bin/bash

set -e

cd /home/container

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