# User Documentation — Inception

## Overview

This stack runs a WordPress website served over HTTPS via Nginx, backed by a MariaDB database. All services run as Docker containers.

---

## Starting and stopping the stack

**Start (build images and launch containers):**
```bash
make
```

**Stop (keep data):**
```bash
make down
```

**Stop and remove volumes (destroys all data):**
```bash
make clean
```

**Full reset (removes images, containers, volumes, and persisted data):**
```bash
make fclean
```

**Rebuild from scratch:**
```bash
make re
```

---

## Accessing the website

The site is only accessible over HTTPS. Open a browser and go to:

```
https://nofanizz.42.fr
```

> Make sure your `/etc/hosts` file maps `nofanizz.42.fr` to `127.0.0.1` if running locally:
> ```
> 127.0.0.1   nofanizz.42.fr
> ```

The TLS certificate is self-signed — your browser will show a warning. Accept the exception to proceed.

---

## Accessing the WordPress admin panel

```
https://nofanizz.42.fr/wp-admin
```

- Username: `myadmin`
- Password: see `secrets/credentials.txt`

---

## User accounts

- Admin: `myadmin` / `admin@42.fr`
- Author: `visitor` / `visitor@42.fr`

---

## Managing credentials

Passwords are stored as plain-text files in `secrets/`:

- `credentials.txt` — WordPress admin password
- `db_password.txt` — MariaDB app user password
- `db_root_password.txt` — MariaDB root password

To change a password, edit the file then run `make re`.

---

## Basic checks

**Check that all containers are running:**
```bash
docker ps
```
Expected containers: `nginx`, `wordpress`, `mariadb`.

**Check container logs:**
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

**Test HTTPS connectivity:**
```bash
curl -k https://nofanizz.42.fr
```

**Check MariaDB is accepting connections:**
```bash
docker exec -it mariadb mysqladmin ping -u root -p
```
