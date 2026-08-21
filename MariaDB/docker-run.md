# ROOT PASSWORD via `mariadb_password`
- buat file `mariadb_password` dan isi
```txt
passwordkamu
```
- selesai, tinggal run sesuaikan configurasi
```bash
docker run -d --name mariadb --network mariadb-network -p 3306:3306 -v $(pwd)/mariadb_password:/run/secrets/mariadb_password:ro -e MARIADB_ROOT_PASSWORD_FILE=/run/secrets/mariadb_password -v mariadb-data:/var/lib/mysql:z mariadb:12
```
# ROOT PASSWORD via `.env`
- buat file `.env` dan isi
```.env
MARIADB_ROOT_PASSWORD=passwordkamu
```
- selesai, tinggal run sesuaikan configurasi
```bash
docker run -d --name mariadb --network mariadb-network -p 3306:3306 --env-file .env -v mariadb-data:/var/lib/mysql:z mariadb:12
```

### NOTE : chmod 600 file_rahasia
