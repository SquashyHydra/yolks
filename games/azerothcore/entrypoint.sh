#!/bin/bash

set -e

cd /home/container

# If a MySQL initialization script exists, run it.
if [ -f "/home/container/mysql_init.sh" ]; then
    echo "Preparing MySQL data directory..."
    mkdir -p /var/lib/mysql
    chown -R mysql:mysql /var/lib/mysql
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
    # check if folder /home/container/data/mysql exists
    if [ -d "/home/container/data/mysql" ]; then
        for f in /path/to/AzerothCore/data/sql/base/db_auth/*.sql; do mysql -u root acore_auth < "$f"; done
        for f in /path/to/AzerothCore/data/sql/base/db_characters/*.sql; do mysql -u root acore_characters < "$f"; done
        for f in /path/to/AzerothCore/data/sql/base/db_world/*.sql; do mysql -u root acore_world < "$f"; done
        mv /home/container/mysql_init.sh /home/container/data/mysql/mysql_init.sh
    else
        rm -f /home/container/mysql_init.sh
    fi
    echo "Stopping MySQL..."
    mysqladmin -u root shutdown
    wait "$MYSQL_PID"
    echo "MySQL stopped."
fi

exec su -s /bin/bash container -c '
    cd /home/container

    # If the configuration files do not exist, copy them.
    if [ -f "/home/container/env/dist/etc/authserver.conf.dist" ] &&
       [ ! -f "/home/container/env/dist/etc/authserver.conf" ]; then
        cp /home/container/env/dist/etc/authserver.conf.dist \
           /home/container/env/dist/etc/authserver.conf
    fi

    if [ -f "/home/container/env/dist/etc/worldserver.conf.dist" ] &&
       [ ! -f "/home/container/env/dist/etc/worldserver.conf" ]; then
        cp /home/container/env/dist/etc/worldserver.conf.dist \
           /home/container/env/dist/etc/worldserver.conf
    fi

    if [ -f "/home/container/acore.sh" ]; then
        chmod +x /home/container/acore.sh
    fi

    if [ -z "$STARTUP" ]; then
        exec /bin/bash
    fi

    exec $STARTUP
'