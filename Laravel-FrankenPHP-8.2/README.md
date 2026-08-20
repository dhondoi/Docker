# CHEATSHEET DOCKER LARAVEL FRANKENPHP V 8.2
## RUN
### STUDI KASUS : STATIC WEB
- project yang sudah di uji coba di komputer kita langsung copas ke ke server menggunakan filezilla
```bash
MSYS_NO_PATHCONV=1 docker run -d --name laravel-franken -p 81:80 -p 443:443 -p 443:443/udp -v $PWD:/app dunglas/frankenphp:1.12.7-php8.2-alpine
docker run -d --name <nama-container> -e SERVER_NAME=":80" -v $(pwd)/Caddyfile:/etc/caddy/Caddyfile -p <port>:80 dunglas/frankenphp:1.12.7-php8.2-alpine
```
---
