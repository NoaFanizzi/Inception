*This project has been created as part of the 42 curriculum by nofanizz.*

# Inception

## Description
Inception is a 42 system administration project. The goal is to deploy a small web infrastructure using **Docker Compose**, with each service isolated in its own container built from Debian Bullseye:

- **nginx** — reverse proxy, only entry point (HTTPS port 443, TLSv1.2/1.3)
- **wordpress** — PHP-FPM application, configured via WP-CLI
- **mariadb** — database for WordPress


Internet → nginx :443 → wordpress :9000 → mariadb :3306


### Design choices

**VM vs Docker** — A VM runs a full OS for each service. Docker shares the host kernel and just isolates processes, so it's much lighter. Here, containers run inside a VM as required by the subject.

**Secrets vs Environment Variables** — Env vars can show up in docker inspect or logs. Secrets are just files mounted in /run/secrets/ inside the container, so passwords never end up in the image or environment. Passwords use secrets, everything else uses .env.

**Docker Network vs Host Network** — With host network, containers share the host's ports directly. A bridge network keeps containers isolated — they talk to each other by name, and only the ports you explicitly publish are reachable. Only port 443 is exposed here.

**Volumes vs Bind Mounts** — Named volumes are managed by Docker, bind mounts are just a folder on the host. This project uses named volumes that point to /home/nofanizz/data/ so data persists and the location is known.

## Instructions

**1. Fill in the secrets**

echo "your_db_user_password"  > secrets/db_password.txt

echo "your_db_root_password"  > secrets/db_root_password.txt

echo "your_wp_admin_password" > secrets/credentials.txt


**2. Add the domain to /etc/hosts**

echo "127.0.0.1 nofanizz.42.fr" | sudo tee -a /etc/hosts

**3. Build and run**

make        # build and start
make down   # stop (keep data)
make clean  # stop and remove volumes
make fclean # full reset
make re     # rebuild from scratch


Site: https://nofanizz.42.fr (self-signed cert, accept the browser warning)
Admin: https://nofanizz.42.fr/wp-admin

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/compose-file/)
- [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/)
- [Nginx docs](https://nginx.org/en/docs/)
- [MariaDB docs](https://mariadb.com/kb/en/documentation/)
- [WP-CLI](https://wp-cli.org/)

**AI usage** — AI was used during the whole process in many different tasks. It helped me to break into some very difficult concept to get, even when reading the documentation. In the same way, it gave me concrete example to get the best practises and improve what I had done. And finally, it helped me a bit in order to be more precise inside my readme.
