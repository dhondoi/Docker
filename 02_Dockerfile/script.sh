# Change to directory first

# FROM Instruction
docker build -t dhondoi/from 01_from

docker image ls

# RUN Instruction
docker build -t dhondoi/run 02_run

docker build -t dhondoi/run 02_run --progress=plain --no-cache

# CMD Instruction
docker build -t dhondoi/command 03_command

docker image inspect dhondoi/command

docker container create --name command dhondoi/command

docker container start command

docker container logs command

# LABEL Instruction
docker build -t dhondoi/label 04_label

docker image inspect dhondoi/label

# ADD Instruction
docker build -t dhondoi/add 05_add

docker container create --name add dhondoi/add

docker container start add

docker container logs add

# COPY Instruction
docker build -t dhondoi/copy 06_copy

docker container create --name copy dhondoi/copy

docker container start copy

docker container logs copy

# .dockerignore
docker build -t dhondoi/ignore 07_ignore

docker container create --name ignore dhondoi/ignore

docker container start ignore

docker container logs ignore

# EXPOSE Instruction
docker build -t dhondoi/expose 08_expose

docker image inspect dhondoi/expose

docker container create --name expose -p 8080:8080 dhondoi/expose

docker container start expose

docker container ls

docker container stop expose

# ENV Instruction
docker build -t dhondoi/env 09_env

docker image inspect dhondoi/env

docker container create --name env --env APP_PORT=9090 -p 9090:9090 dhondoi/env

docker container start env

docker container ls

docker container logs env

docker container stop env

# VOLUME Instruction
docker build -t dhondoi/volume 10_volume

docker image inspect dhondoi/volume

docker container create --name volume -p 8080:8080 dhondoi/volume

docker container start volume

docker container logs volume

docker container inspect volume

#15a53c9a60b9aaddb3c294cde03e6f283f319acf0db3e40c5d4b4a992a6451f1

docker volume ls

# WORKDIR Instruction
docker build -t dhondoi/workdir 11_workdir

docker container create --name workdir -p 8080:8080 dhondoi/workdir

docker container start workdir

docker container exec -i -t workdir /bin/sh

# USER Instruction
docker build -t dhondoi/user 12_user

docker container create --name user -p 8080:8080 dhondoi/user

docker container start user

docker container exec -i -t user /bin/sh

# ARG Instruction
docker build -t dhondoi/arg 13_arg --build-arg app=pzn

docker container create --name arg -p 8080:8080 dhondoi/arg

docker container start arg

docker container exec -i -t arg /bin/sh

# HEALTHCHECK Instruction
docker build -t dhondoi/health 14_health

docker container create --name health -p 8080:8080 dhondoi/health

docker container start health

docker container ls

docker container inspect health

# ENTRYPOINT Instruction
docker build -t dhondoi/entrypoint 15_entrypoint

docker image inspect dhondoi/entrypoint

docker container create --name entrypoint -p 8080:8080 dhondoi/entrypoint

docker container start entrypoint

# Multi Stage Build
docker build -t dhondoi/multi 16_multi

docker image ls

docker container create --name multi -p 8080:8080 dhondoi/multi

docker container start multi

# Docker Push
docker tag dhondoi/multi registry.digitalocean.com/programmerzamannow/multi

docker --config /Users/dhondoi/.docker-digital-ocean/ push registry.digitalocean.com/programmerzamannow/multi

docker --config /Users/dhondoi/.docker-digital-ocean/ pull registry.digitalocean.com/programmerzamannow/multi