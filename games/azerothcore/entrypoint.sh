#!/bin/bash

set -e

cd /home/container

echo "===== Runtime identity ====="
id
echo "============================"

# If a MySQL initialization script exists, run it.
if [ -f "/home/container/mysql_init.sh" ]; then

    MYSQL_DATADIR=$(< /home/container/database_dir.txt)
    MYSQL_SOCKET=$(< /home/container/database_socket.txt)
    MYSQL_PIDFILE=$(< /home/container/database_pid.txt)
    MYSQL_LOGFILE=$(< /home/container/database_log.txt)
    MYSQL_CNF="/home/container/.my.cnf"
    MYSQL_INIT_FILE="$MYSQL_DATADIR/mysql_bootstrap.sql"

    MYSQL_ADMIN_USER=$(< /home/container/database_user.txt)
    MYSQL_ADMIN_PASSWORD=$(< /home/container/database_password.txt)

    mysql_dir=$(dirname "$MYSQL_SOCKET")

    echo "===== MySQL directory ====="
    mkdir -p "$MYSQL_DATADIR"
    mkdir -p "$mysql_dir"
    ls -ld "$MYSQL_DATADIR"
    stat "$MYSQL_DATADIR"
    echo "==========================="

    echo "Preparing MySQL..."

    chmod 777 "$MYSQL_DATADIR"
    chmod 777 "$mysql_dir"

    if [ -z "$MYSQL_ADMIN_USER" ]; then
        echo "ERROR: MySQL database username is empty."
        exit 1
    fi

    if [ -z "$MYSQL_ADMIN_PASSWORD" ]; then
        echo "ERROR: MySQL database password is empty."
        exit 1
    fi

    # Determine whether this is the first MySQL initialization.
    if [ ! -d "$MYSQL_DATADIR/mysql" ]; then

        echo "Initializing MySQL data directory..."

        mysqld \
            --initialize-insecure \
            --datadir="$MYSQL_DATADIR" \
            --socket="$MYSQL_SOCKET" \
            --pid-file="$MYSQL_PIDFILE" \
            --log-error="$MYSQL_LOGFILE" \
            --console

        echo "Creating MySQL bootstrap configuration..."

        cat > "$MYSQL_INIT_FILE" <<EOF
CREATE USER IF NOT EXISTS '$MYSQL_ADMIN_USER'@'localhost'
    IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD';

CREATE USER IF NOT EXISTS '$MYSQL_ADMIN_USER'@'%'
    IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD';

GRANT ALL PRIVILEGES ON *.*
    TO '$MYSQL_ADMIN_USER'@'localhost'
    WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON *.*
    TO '$MYSQL_ADMIN_USER'@'%'
    WITH GRANT OPTION;

FLUSH PRIVILEGES;
EOF

        chmod 600 "$MYSQL_INIT_FILE"

        FIRST_START="true"

    else
        FIRST_START="false"
    fi

    # Create the MySQL client credentials file.
    cat > "$MYSQL_CNF" <<EOF
[client]
user=$MYSQL_ADMIN_USER
password=$MYSQL_ADMIN_PASSWORD
socket=$MYSQL_SOCKET
EOF

    chmod 600 "$MYSQL_CNF"

    echo "Starting MySQL..."

    if [ "$FIRST_START" = "true" ]; then

        mysqld \
            --datadir="$MYSQL_DATADIR" \
            --socket="$MYSQL_SOCKET" \
            --pid-file="$MYSQL_PIDFILE" \
            --log-error="$MYSQL_LOGFILE" \
            --init-file="$MYSQL_INIT_FILE" \
            --console &

    else

        mysqld \
            --datadir="$MYSQL_DATADIR" \
            --socket="$MYSQL_SOCKET" \
            --pid-file="$MYSQL_PIDFILE" \
            --log-error="$MYSQL_LOGFILE" \
            --console &

    fi

    MYSQL_PID=$!

    echo "Waiting for MySQL to become ready..."

    until mysqladmin ping --silent 2>/dev/null; do

        if ! kill -0 "$MYSQL_PID" 2>/dev/null; then
            echo "ERROR: MySQL exited unexpectedly."
            wait "$MYSQL_PID"
            exit 1
        fi

        sleep 1
    done

    echo "MySQL is ready."

    # The bootstrap file has now done its job.
    if [ "$FIRST_START" = "true" ]; then
        rm -f "$MYSQL_INIT_FILE"
    fi

    chmod +x /home/container/mysql_init.sh

    echo "Running MySQL initialization script..."

    /bin/bash /home/container/mysql_init.sh

    # Import AzerothCore SQL.
    #
    # Change /path/to/AzerothCore if your SQL files are somewhere else.
    if [ -d "/home/container/data/sql" ]; then

        echo "Importing auth database..."

        for f in /home/container/data/sql/base/db_auth/*.sql; do
            [ -f "$f" ] || continue
            mysql acore_auth < "$f"
        done

        echo "Importing characters database..."

        for f in /home/container/data/sql/base/db_characters/*.sql; do
            [ -f "$f" ] || continue
            mysql acore_characters < "$f"
        done

        echo "Importing world database..."

        for f in /home/container/data/sql/base/db_world/*.sql; do
            [ -f "$f" ] || continue
            mysql acore_world < "$f"
        done

        rm -f /home/container/*.txt
        mv \
            /home/container/mysql_init.sh \
            /home/container/data/sql/mysql_init.sh

    else
        rm -f /home/container/*.txt
        rm -f /home/container/mysql_init.sh
    fi

    echo "Stopping MySQL..."

    mysqladmin shutdown

    wait "$MYSQL_PID"

    echo "MySQL stopped."

fi

PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")

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

if [ -z "$PARSED" ]; then
    exec /bin/bash
fi

exec $PARSED