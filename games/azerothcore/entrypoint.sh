#!/bin/bash

set -e

cd /home/container

# If the configuration files do not exist, copy them from the distribution files.
if [ -f "/home/container/env/dist/etc/authserver.conf.dist" ] && [ ! -f "/home/container/env/dist/etc/authserver.conf" ]; then
    cp /home/container/env/dist/etc/authserver.conf.dist /home/container/env/dist/etc/authserver.conf
fi
if [ -f "/home/container/env/dist/etc/worldserver.conf.dist" ] && [ ! -f "/home/container/env/dist/etc/worldserver.conf" ]; then
    cp /home/container/env/dist/etc/worldserver.conf.dist /home/container/env/dist/etc/worldserver.conf
fi

# If a MySQL initialization script exists, run it.
if [ -f "/home/container/mysql_init.sh" ]; then
    echo "Starting MySQL..."
    mysqld --user=mysql --console &
    MYSQL_PID=$!
    echo "Waiting for MySQL to become ready..."
    until mysqladmin ping --silent; do
        sleep 1
    done
    echo "MySQL is ready."

    chmod +x /home/container/mysql_init.sh
    /bin/bash /home/container/mysql_init.sh
    rm -f /home/container/mysql_init.sh

    echo "Stopping MySQL..."
    mysqladmin -u root shutdown
    wait "$MYSQL_PID"
    echo "MySQL stopped."
fi

# If no command was supplied, open bash.
if [ -z "$STARTUP" ]; then
    exec /bin/bash
fi

# Execute the command supplied by Pterodactyl.
exec $STARTUP