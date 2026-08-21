- ROOT PASSWORD via `mariadb_password`
```bash
docker run -d --name mariadb --network maria-network -p 3306:3306 -v $(pwd)/mariadb_password:/run/secrets/mariadb_password:ro -e MARIADB_ROOT_PASSWORD_FILE=/run/secrets/mariadb_password -v mariadb-data:/var/lib/mysql:Z mariadb:12
```
- ROOT PASSWORD via `.env`
```bash

```
