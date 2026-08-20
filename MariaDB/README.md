
---
# CHEATSHEET DOCKER MARIADB
## RUN
```bash
docker run --name maria-db -e MARIADB_ROOT_PASSWORD=12345 -d dhi.io/mariadb:12
# port binding
docker run --name maria-db -p 3306:3306 -e MARIADB_ROOT_PASSWORD=12345 -d dhi.io/mariadb:12
# exec it
docker exec -it maria-db mariadb -u root -p
```
---
## COMPOSE
```yaml
services:
  db:
    image: dhi.io/mariadb:12
    restart: always
    environment:
      MARIADB_ROOT_PASSWORD: my-secret-pw
    volumes:
      - mariadb-data:/var/lib/mysql
volumes:
  mariadb-data:
```
---
## ENV
- `MARIADB_ROOT_PASSWORD` Sets the password for the MariaDB root superuser account. Required unless MARIADB_ROOT_PASSWORD_FILE is used.
- `MARIADB_ROOT_PASSWORD_FILE` Path to a file containing the root password. Use this instead of MARIADB_ROOT_PASSWORD for Docker secrets.
- `MARIADB_OPTIONS` Additional command-line options to pass to mariadbd (space-separated). For example: --max-connections=50.
- `MARIADB_DATA_DIR`	Path to the MariaDB data directory. Defaults to /var/lib/mysql. Do not override this value.
---
## Using Docker secrets
```yaml
services:
  mariadb:
    image: dhi.io/mariadb:<tag>
    secrets:
      - mariadb_password
    environment:
      MARIADB_ROOT_PASSWORD_FILE: /run/secrets/mariadb_password
secrets:
  mariadb_password:
    file: ./mariadb-password.txt
```
- Using Docker run with a mounted file:
```bash
docker run --name some-mariadb \
  -e MARIADB_ROOT_PASSWORD_FILE=/run/secrets/mariadb_password \
  -v /path/to/password-file:/run/secrets/mariadb_password:ro \
  -d dhi.io/mariadb:<tag>
```
---
## Passing MariaDB server options
```bash
docker run --name some-mariadb \
  -e MARIADB_ROOT_PASSWORD=my-secret-pw \
  -e MARIADB_OPTIONS="--max-connections=50 --thread-cache-size=16" \
  -d dhi.io/mariadb:<tag>
```
- Alternatively, pass options directly on the command line after mariadbd:
```bash
docker run --name some-mariadb \
  -e MARIADB_ROOT_PASSWORD=my-secret-pw \
  -d dhi.io/mariadb:<tag> mariadbd --max-connections=50
```
---
## Using a custom MariaDB configuration file
```bash
docker run --name some-mariadb \
  -v /my/custom:/etc/mysql/conf.d:ro \
  -e MARIADB_ROOT_PASSWORD=my-secret-pw \
  -d dhi.io/mariadb:<tag>
```
- Configuration without a cnf file
```bash
docker run --name some-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-pw -d dhi.io/mariadb:<tag> mariadbd --port 3808
```
---
## Data persistence
```bash
docker run --name some-mariadb \
  -e MARIADB_ROOT_PASSWORD=my-secret-pw \
  -v mariadb-data:/var/lib/mysql \
  -d dhi.io/mariadb:<tag>
```
- Creating database dumps
```bash
docker exec some-mariadb mariadb-dump -uroot -p"$MARIADB_ROOT_PASSWORD" --all-databases > backup.sql
```
- Restoring from dumps
```bash
docker exec -i some-mariadb mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" < backup.sql
```
---
