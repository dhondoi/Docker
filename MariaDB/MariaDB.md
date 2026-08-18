
---
# CHEATSHEET DOCKER MARIADB
## RUN
```bash
docker run --name some-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-pw -d dhi.io/mariadb:<tag>
# port binding
docker run --name some-mariadb -p 3306:3306 -e MARIADB_ROOT_PASSWORD=my-secret-pw -d dhi.io/mariadb:<tag>
# exec it
docker exec -it some-mariadb mariadb -u root -p
```
---
## COMPOSE
```bash
services:
  db:
    image: dhi.io/mariadb:<tag>
    restart: always
    environment:
      MARIADB_ROOT_PASSWORD: my-secret-pw
    volumes:
      - mariadb-data:/var/lib/mysql
volumes:
  mariadb-data:
```
---
