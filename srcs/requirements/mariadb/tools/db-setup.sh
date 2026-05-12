#!/bin/bash
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe &
MYSQL_PID=$!

until mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent 2>/dev/null; do
    sleep 1
done

mysql --socket=/run/mysqld/mysqld.sock -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysql --socket=/run/mysqld/mysqld.sock -u root -p"${DB_ROOT_PASSWORD}" -e "SHUTDOWN;"
wait $MYSQL_PID

exec mysqld_safe