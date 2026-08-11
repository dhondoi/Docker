
---
# PERSISTING DATA POSTGRESQL
### CREATION PHASE
1. start container
```bash
docker run --name=db -e POSTGRES_PASSWORD=secret -d -v postgres_data:/var/lib/postgresql postgres:18
```
2. connect to database
```bash
docker exec -ti db psql -U postgres
```
3. create table
```
CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    description VARCHAR(100)
);
INSERT INTO tasks (description) VALUES ('Finish work'), ('Have fun');
```
4. verify table
```bash
SELECT * FROM tasks;
```
5. quit shell
```bash
\q
```
### TRY DELETE CONTAINER
```bash
docker rm -f db
```
### START NEW CONTAINER
```bash
docker run --name=new-db -d -v postgres_data:/var/lib/postgresql postgres:18
```
### VERIFY DB
```bash
docker exec -ti new-db psql -U postgres -c "SELECT * FROM tasks"
```
### DONE. NEXT STEP IS FOR REMOVE VOLUME
```bash
# remove container first
docker rm -f new-db
# remove used volume
docker volume rm postgres_data
# or remove all volume which has unused (no container using it)
docker volume prune
```
---
# BACKUP
```bash
MSYS_NO_PATHCONV=1 docker container run --rm --name ubuntubackup --mount "type=bind,source=/c/backup-postgre,destination=/backup" --mount "type=volume,source=postgres_data,destination=/data" ubuntu:latest tar cvf /backup/backup-$(date +"%Y%m%d-%H%M%S").tar.gz /data
```
# RESTORE
```bash
MSYS_NO_PATHCONV=1 docker container run --rm --name ubuntubackup --mount "type=bind,source=/c/backup-postgre,destination=/backup" --mount "type=volume,source=postgres_data,destination=/data" ubuntu:latest bash -c "cd /data && tar xvf /backup/backup.tar.gz --strip 1"
```