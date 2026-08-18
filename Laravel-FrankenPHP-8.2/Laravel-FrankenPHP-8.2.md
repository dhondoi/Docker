# CHEATSHEET DOCKER LARAVEL FRANKENPHP V 8.2
## RUN
```bash
MSYS_NO_PATHCONV=1 docker run -d --name laravel-franken-static -p 80:80 -p 443:443 -p 443:443/udp -v $PWD:/app/public dunglas/frankenphp:1.12.7-php8.2-alpine
```
---
