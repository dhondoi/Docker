
---
# CHEATSHEET DOCKER MARIADB
## BEST PRACTICE
### docker run
- alangkah baiknya mod dulu file rahasia
```bash
chmod 600 mariadb_password
```
- buat network dulu
```bash
docker network create app-network
```
```bash
docker run -d --name mariadb --network app-network -p 3306:3306 -v $(pwd)/mariadb_password:/run/secrets/mariadb_password:ro -e MARIADB_ROOT_PASSWORD_FILE=/run/secrets/mariadb_password -v mariadb-data:/var/lib/mysql:z mariadb:12
```
- klo make `.env`
```bash
docker run -d --name mariadb --network app-network -p 3306:3306 -e MARIADB_ROOT_PASSWORD={$MYSQL_ROOT_PASSWORD:-12345} -v mariadb-data:/var/lib/mysql:z mariadb:12
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
      - mariadb-data:/var/lib/mysql:z
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
## Creating database dumps
- **Cara 1: simpan dalam container**
```bash
 docker exec mariadb sh -c 'mkdir -p backup && mariadb-dump --databases namadb -u root -p"$MARIADB_ROOT_PASSWORD" > backup/db.sql'
```
- **Cara 2 : di luar container (server)**
```bash
docker exec nama_container sh -c 'mariadb-dump -u root -p"$MARIADB_ROOT_PASSWORD" --databases nama_database --single-transaction --quick' | gzip > backup/mariadb_$(date +%Y%m%d_%H%M%S).sql.gz
```
- **Cara 3 : cold volume**
```bash
# 1. Hentikan container
docker stop mariadb_container

# 2. Archiving data dari named volume (misal: mariadb_data) ke host
docker run --rm \
  -v mariadb_data:/from:ro \
  -v /path/to/backups:/to \
  alpine tar -czf /to/volume_backup_$(date +%Y%m%d).tar.gz -C /from .

# 3. Jalankan kembali container
docker start mariadb_container
```
- **Cara 4 : cronjob**
  - buat `backup-mariadb.sh`
```sh
#!/bin/bash

# Buat direktori jika belum ada
mkdir -p $HOME/MariaDB/data-warga/backup

docker stop mariadb

# Jalankan dump dan kompresi
docker run -d --name mariadb-backup --env-file $HOME/MariaDB/.env -v mariadb-data:/var/lib/mysql:z >
echo "Menunggu MariaDB siap..."
until docker exec mariadb-backup mariadb-admin ping -h localhost --silent; do
    sleep 2
done
echo "MariaDB siap digunakan!"
docker exec mariadb-backup sh -c 'mariadb-dump -u root -p"$MARIADB_ROOT_PASSWORD" --databases data_>
docker rm -f mariadb-backup

docker start mariadb

# Hapus backup yang lebih tua dari X hari
find $HOME/MariaDB/data-warga/backup -type f -name "*.sql.gz" -mtime +7 -delete
```
  - masukkan cronjob
```bash
# buka crontab
crontab -e
# isi
0 0 1 * * $HOME/MariaDB/data-warga/backup-mariadb.sh > $HOME/MariaDB/data-warga/backup-mariadb.log 2>&1
```
  - ubah agar bisa dieksekusi
```bash
chmod +x backup-mariadb.sh
```
  - cek apakah log
```bash
grep CRON /var/log/syslog | tail -n 20
```
## Restoring from dumps
```bash
docker exec mariadb sh -c 'mariadb -u root -p"$MARIADB_ROOT_PASSWORD" < backup/db.sql'
```
```bash
gunzip < /path/ke/file_backup.sql.gz | docker exec -i my_mariadb sh -c 'mariadb -u root -p"$MARIADB_ROOT_PASSWORD" <nama_db>'
```
---
