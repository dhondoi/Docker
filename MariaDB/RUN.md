# ROOT PASSWORD via `mariadb_password`
- buat file `mariadb_password` dan isi
```txt
passwordkamu
```
- selesai, tinggal run sesuaikan configurasi
```bash
docker run -d --name mariadb --network mariadb-network -p 3306:3306 -v $(pwd)/mariadb_password:/run/secrets/mariadb_password:ro -e MARIADB_ROOT_PASSWORD_FILE=/run/secrets/mariadb_password -v mariadb-data:/var/lib/mysql:Z mariadb:12
```
# ROOT PASSWORD via `.env`
- buat file `.env` dan isi
```.env
MYSQL_ROOT_PASSWORD=passwordkamu
```
- 
```bash
docker run -d --name mariadb --network mariadb-network -p 3306:3306 -e MARIADB_ROOT_PASSWORD={$MYSQL_ROOT_PASSWORD:-passwordkamu} -v mariadb-data:/var/lib/mysql:Z mariadb:12
```

### NOTE : chmod 600 file_rahasia
