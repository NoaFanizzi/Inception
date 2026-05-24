# Developer Documentation — Inception

## Overview

Three services, each built from a custom Dockerfile:

- `nginx` — reverse proxy, TLS termination (port 443)
- `wordpress` — PHP-FPM 8.2 application
- `mariadb` — database

All communicate over a Docker bridge network (`inception`).

## Prerequisites

- Docker Engine >= 24 with the Compose plugin
- `make`
- `sudo` access (used by `fclean` to delete data dirs)

## Repository layout

```
Inception/
├── Makefile
├── secrets/            # plain-text password files
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        ├── wordpress/
        └── mariadb/
```

## Environment variables (`srcs/.env`)

- `DOMAIN_NAME` — site domain (`login.42.fr`)
- `MYSQL_DATABASE` / `MYSQL_USER` / `MYSQL_HOST` — database config
- `WP_TITLE` / `WP_ADMIN_USER` / `WP_ADMIN_EMAIL` — WordPress install
- `WP_USER` / `WP_USER_EMAIL` — secondary author account

Passwords come from Docker secrets (`secrets/`), not `.env`.

## Makefile targets

- `make` — create data dirs, build images, start containers
- `make down` — stop containers (data preserved)
- `make clean` — stop containers and remove volumes
- `make fclean` — full reset (images, volumes, host data dirs)
- `make re` — `fclean` + `all`

## Docker Compose commands

From `srcs/`:
```
docker compose up -d --build
docker compose logs -f
docker compose down
docker compose down -v
docker compose up -d --build nginx
```
## Data persistence

Volumes are bind-mounted to the host:

- `/home/nofanizz/data/wordpress` → `/var/www/html`
- `/home/nofanizz/data/mariadb` → `/var/lib/mysql`

Directories are created by `make`. To wipe everything: `make fclean`.

## Debugging


# MariaDB shell
docker exec -it mariadb mysql -u wpuser -p wordpress

# WP-CLI
docker exec -it wordpress wp --allow-root user list
