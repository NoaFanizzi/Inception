#!/bin/bash
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/credentials)

mkdir -p /var/www/html
cd /var/www/html

if [ ! -f wp-config.php ]; then
    wp core download --allow-root

    wp config create --allow-root \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$DB_PASSWORD \
        --dbhost=$MYSQL_HOST

    until wp db check --allow-root 2>/dev/null; do
        echo "Waiting for MariaDB..."
        sleep 2
    done

    wp core install --allow-root \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    wp user create --allow-root \
        $WP_USER $WP_USER_EMAIL \
        --role=author \
        --user_pass="visitor123"
fi

exec php-fpm8.2 -F
