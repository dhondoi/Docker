
---
# CHEATSHEET DOCKER NGINX-NODE-REDIS
## DOCKER RUN
---
## DOCKERFILE
Build the images
### Navigate into the nginx directory to build the image by running the following command:
```bash
 docker build -t nginx .
```
### Navigate into the web directory and run the following command to build the first web image:
```bash
docker build -t web .
```
### Run the containers
Before you can run a multi-container application, you need to create a network for them all to communicate through. You can do so using the docker network create command:
```bash
docker network create sample-app
```
Start the Redis container by running the following command, which will attach it to the previously created network and create a network alias (useful for DNS lookups):
```bash
docker run -d  --name redis --network sample-app --network-alias redis redis
```
Start the first web container by running the following command:
```bash
docker run -d --name web1 -h web1 --network sample-app --network-alias web1 web
```
Start the second web container by running the following:
```bash
docker run -d --name web2 -h web2 --network sample-app --network-alias web2 web
```
Start the Nginx container by running the following command:
```bash
docker run -d --name nginx --network sample-app  -p 80:80 nginx
```
Note
Nginx is typically used as a reverse proxy for web applications, routing traffic to backend servers. In this case, it routes to the Node.js backend containers (web1 or web2).
Verify the containers are up by running the following command:
```bash
docker ps
```
---
## DOCKER COMPOSE
### A counter web application built using Node.js, Nginx proxy and Redis database

Project structure:
```
tree
.
├── LICENSE
├── README.md
├── compose.yml
├── nginx
│   ├── Dockerfile
│   └── nginx.conf
└── web
    ├── Dockerfile
    ├── package-lock.json
    ├── package.json
    └── server.js

3 directories, 9 files

```
[_compose.yml_](compose.yml)
```

services:
  redis:
    image: redis
    ports:
      - '6379:6379'
  web1:
    restart: on-failure
    build: ./web
    hostname: web1
    ports:
      - '81:5000'
  web2:
    restart: on-failure
    build: ./web
    hostname: web2
    ports:
      - '82:5000'
  nginx:
    build: ./nginx
    ports:
    - '80:80'
    depends_on:
    - web1
    - web2
```
The compose file defines an application with four services `redis`, `nginx`, `web1` and `web2`.
When deploying the application, Docker compose maps port 80 of the nginx service container to port 80 of the host as specified in the file.


> ℹ️ **_INFO_**  
> Redis runs on port 6379 by default. Make sure port 6379 on the host is not being used by another container, otherwise the port should be changed.

### Deploy with docker compose

```
$ docker compose up -d
[+] Running 24/24
 ⠿ redis Pulled                                                                                                                                                                                                                      ...
   ⠿ 565225d89260 Pull complete                                                                                                                                                                                                      
[+] Building 2.4s (22/25)
 => [nginx-nodejs-redis_nginx internal] load build definition from Dockerfile                                                                                                                                                         ...
[+] Running 5/5
 ⠿ Network nginx-nodejs-redis_default    Created                                                                                                                                                                                      
 ⠿ Container nginx-nodejs-redis-web2-1   Started                                                                                                                                                                                      
 ⠿ Container nginx-nodejs-redis-redis-1  Started                                                                                                                                                                                      
 ⠿ Container nginx-nodejs-redis-web1-1   Started                                                                                                                                                                                      
 ⠿ Container nginx-nodejs-redis-nginx-1  Started
```


### Expected result

Listing containers must show three containers running and the port mapping as below:


```
docker compose ps
```

### Testing the app

After the application starts, navigate to `http://localhost:80` in your web browser or run:

```
curl localhost:80
curl localhost:80
web1: Total number of visits is: 1
```

```
curl localhost:80
web1: Total number of visits is: 2
```
```
$ curl localhost:80
web2: Total number of visits is: 3
```



### Tear down the containers

```
$ docker compose down
```
---

