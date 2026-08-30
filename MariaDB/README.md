# CHEASHEET DOCKER MARIADB
## ENV
- `MARIADB_ROOT_PASSWORD` Sets the password for the MariaDB root superuser account. Required unless MARIADB_ROOT_PASSWORD_FILE is used.
- `MARIADB_ROOT_PASSWORD_FILE` Path to a file containing the root password. Use this instead of MARIADB_ROOT_PASSWORD for Docker secrets.
- `MARIADB_OPTIONS` Additional command-line options to pass to mariadbd (space-separated). For example: `--max-connections=50` :
  1. `docker run --name some-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-pw -e MARIADB_OPTIONS="--max-connections=50 --thread-cache-size=16" -d mariadb:<tag>`
  2. `docker run --name some-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-pw -d mariadb:<tag> mariadbd --max-connections=50`
- `MARIADB_DATA_DIR` Path to the MariaDB data directory. Defaults to `/var/lib/mysql`. Do not override this value.
- Custom MariaDB config :
  1. `docker run --name some-mariadb -v /my/custom:/etc/mysql/conf.d:ro -e MARIADB_ROOT_PASSWORD=my-secret-pw -d mariadb:<tag>`
  2. `docker run --name some-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-pw -d mariadb:<tag> mariadbd --port 3808`
## RUN
1. Buat Direktori project (`MariaDB/<nama_project>`), masuk direktori.
2. Buat Docker Network
```bash
docker network create <nama_network>
```
3. Jika menggunakan `password file` :
- Buat file (`nano <nama_file_pw>`) dan ubah permission 600 (`chmod 600 <nama_file_pw>`) isi file dengan password kamu
```txt
<isi_password>
```
- jalankan. `Note : untuk -p 3306:3306 tidak wajib`
```bash
docker run -d --name <nama_container> --network <nama_network> -p 3306:3306 -v <nama_file_pw>:/run/secrets/mariadb_password:ro -e MARIADB_ROOT_PASSWORD_FILE=/run/secrets/mariadb_password -v <nama_volume>:/var/lib/mysql:z --restart unless-stopped mariadb:12
```
4. Jika menggunakan `.env` :
- Buat file (`nano .env`) dan ubah permission 600 (`chmod 600 .env`) isi file dengan password kamu
```.env
MARIADB_ROOT_PASSWORD=<isi_password>
```
- jalankan. `Note : untuk -p 3306:3306 tidak wajib`
```bash
docker run -d --name <nama_container> --network <nama_network> -p 3306:3306 --env-file .env -v <nama_volume>:/var/lib/mysql:z --restart unless-stopped mariadb:12
```
## COMPOSE
1. Jika menggunakan `password file` :
- Buat file (`nano <nama_file_pw>`) dan ubah permission 600 (`chmod 600 <nama_file_pw>`) isi file dengan password kamu
```txt
<isi_password>
```
- Buat file `docker-compose.yaml` dan isi :
```yaml
services:
  <nama_service>:
    image: mariadb:12
    container_name: <nama_container>
    restart: unless-stopped
    volumes:
      - <nama_volume>:/var/lib/mysql:z
    networks:
      - <nama_network>
    #ports:
    #  -  "3306:3306"
    secrets:
      - <nama_secret>
    environment:
      MARIADB_ROOT_PASSWORD_FILE: /run/secrets/mariadb_password

networks:
  <nama_network>:
    #external: true

volumes:
  <nama_volume>:

secrets:
  <nama_secret>:
    file: <nama_file_pw>
```
2. Jika menggunakan `.env` :
- Buat file (`nano .env`) dan ubah permission 600 (`chmod 600 .env`) isi file dengan password kamu
```.env
MARIADB_ROOT_PASSWORD=<isi_password>
```
- Buat file `docker-compose.yaml` dan isi :
```yaml
services:
  <nama_service>:
    image: mariadb:12
    container_name: <nama_container>
    restart: unless-stopped
    volumes:
      - <nama_volume>:/var/lib/mysql:z
    networks:
      - <nama_network>
    #ports:
    #  -  "3306:3306"
    environment:
      MARIADB_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD:-12345}

volumes:
  <nama_volume>:

networks:
  <nama_network>:
    #external: true
```
## BACKUP
1. **Cara 1: simpan dalam container**
```bash
 docker exec <nama_container> sh -c 'mkdir -p backup && mariadb-dump --databases <nama_db> -u root -p"$MARIADB_ROOT_PASSWORD" --single-transaction --quick > backup/<nama_backup>_$(date +%Y%m%d_%H%M%S).sql'
```
2. **Cara 2 : di luar container (server)**
```bash
docker exec <nama_container> sh -c 'mariadb-dump -u root -p"$MARIADB_ROOT_PASSWORD" --databases nama_database --single-transaction --quick' | gzip > <path>/mariadb_$(date +%Y%m%d_%H%M%S).sql.gz
```
3. **Cara 3 : cold volume**
```bash
# 1. Hentikan container
docker stop <nama_container>

# 2. Archiving data dari named volume (misal: mariadb_data) ke host
docker run --rm -v <nama_volume>:/from:ro -v </path/to/backups>:/to mariadb:12 tar -czf /to/volume_backup_$(date +%Y%m%d).tar.gz -C /from .

# 3. Jalankan kembali container
docker start <nama_container>
```
4. **Cara 4 : cronjob**
- buat `<nama_file>.sh` isi
```sh
#!/bin/bash

# Buat direktori jika belum ada
mkdir -p <path_backup>

docker stop <nama_container>

# Jalankan dump dan kompresi
docker run -d --name <nama_container_backup> --env-file <path_.env> -v <nama_volume>:/var/lib/mysql:z mariadb:12
echo "Menunggu MariaDB siap..."
until docker exec <nama_container_backup> mariadb-admin ping -h localhost --silent; do
    sleep 2
done
echo "MariaDB siap digunakan!"
docker exec <nama_container_backup> sh -c 'mariadb-dump -u root -p"$MARIADB_ROOT_PASSWORD" --databases <nama_database> --single-transaction --quick' | gzip > <path>/mariadb_$(date +%Y%m%d_%H%M%S).sql.gz
docker rm -f <nama_container_backup>

docker start <nama_container>

# Hapus backup yang lebih tua dari X hari
find <path_backup> -type f -name "*.sql.gz" -mtime +7 -delete
```
- masukkan cronjob
```bash
# buat log file
touch <nama_file>.log
# cek crontab
crontab -l
# buka crontab
crontab -e
# isi (0 0 1 * * sebulan sekali)
0 0 1 * * <path>/<nama_file>.sh > <path>/<nama_file>.log 2>&1
```
- ubah agar bisa dieksekusi
```bash
chmod +x backup-mariadb.sh
```
- cek apakah log
```bash
grep CRON /var/log/syslog | tail -n 20
# atau
watch -n 1 "cat <path>/<nama_file>.log"
```
## Restoring from dumps
```bash
docker exec mariadb sh -c 'mariadb -u root -p"$MARIADB_ROOT_PASSWORD" < backup/db.sql'
```
```bash
gunzip < /path/ke/file_backup.sql.gz | docker exec -i my_mariadb sh -c 'mariadb -u root -p"$MARIADB_ROOT_PASSWORD" <nama_db>'
```
- Note : bisa juga menerapkan kaya isi `<nama_file>.sh` pada section backup cronjob. bagian stop, jalankan container lain, start.
---
