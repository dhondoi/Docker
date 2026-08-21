
---
# CHEATSHEET DOCKER MARIADB
## BEST PRACTICE
### docker run
- buat network dulu
```bash
docker network create app-network
```
```bash
docker run -d --name mariadb --network app-network -p 3306:3306 -v $(pwd)/mariadb_password:/run/secrets/mariadb_password:ro -v mariadb-data:/var/lib/mysql:Z -e MARIADB_ROOT_PASSWORD_FILE=/run/secrets/mariadb_password mariadb:12
```
- klo make `.env`
```bash
docker run -d --name mariadb --network app-network -p 3306:3306 -e MARIADB_ROOT_PASSWORD={$MYSQL_ROOT_PASSWORD:-12345} -v mariadb-data:/var/lib/mysql:Z mariadb:12
```
### docker compose
```yaml
services:
  db-maria:
    image: mariadb:12
    container_name: mariadb
    restart: unless-stopped
    environment:
      MARIADB_ROOT_PASSWORD: {$MYSQL_ROOT_PASSWORD:-12345}
    #ports:
    #  -  "3306:3306"
    volumes:
      - mariadb-data:/var/lib/mysql:Z
    networks:
      - mariadb-network

volumes:
  mariadb-data:

networks:
  mariadb-network:
```
## RUN
```bash
docker run --name maria-db -e MARIADB_ROOT_PASSWORD=12345 -d mariadb:12
# port binding
docker run --name maria-db -p 3306:3306 -e MARIADB_ROOT_PASSWORD=12345 -d mariadb:12
# exec it
docker exec -it maria-db mariadb -u root -p
```
---
## COMPOSE
```yaml
services:
  db:
    image: mariadb:12
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
- `docker-compose.yaml`
```yaml
services:
  mariadb:
    image: mariadb:<tag>
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
docker run --name <container-name> \
  -e MARIADB_ROOT_PASSWORD_FILE=/run/secrets/mariadb_password \
  -v $(pwd)/<name-file>:/run/secrets/mariadb_password:ro \
  -p 3306:3306 \
  -d mariadb:<tag>
```
---
## Passing MariaDB server options
```bash
docker run --name some-mariadb \
  -e MARIADB_ROOT_PASSWORD=my-secret-pw \
  -e MARIADB_OPTIONS="--max-connections=50 --thread-cache-size=16" \
  -d mariadb:<tag>
```
- Alternatively, pass options directly on the command line after mariadbd:
```bash
docker run --name some-mariadb \
  -e MARIADB_ROOT_PASSWORD=my-secret-pw \
  -d mariadb:<tag> mariadbd --max-connections=50
```
---
## Using a custom MariaDB configuration file
```bash
docker run --name some-mariadb \
  -v /my/custom:/etc/mysql/conf.d:ro \
  -e MARIADB_ROOT_PASSWORD=my-secret-pw \
  -d mariadb:<tag>
```
- Configuration without a cnf file
```bash
docker run --name some-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-pw -d mariadb:<tag> mariadbd --port 3808
```
---
## Data persistence
```bash
docker run --name some-mariadb \
  -e MARIADB_ROOT_PASSWORD=my-secret-pw \
  -v mariadb-data:/var/lib/mysql \
  -d mariadb:<tag>
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
