# CHEATSHEET DOCKER LARAVEL FRANKENPHP V 8.2
## BEST PRACTICE
- docker run
```bash
docker run -d --name laravel-app -e SERVER_NAME=":80" -v $(pwd)/Caddyfile:/etc/frankenphp/Caddyfile -v $(pwd):/app -p 81:80 dunglas/frankenphp:1.12.7-php8.2-alpine
```
## RUN
- project yang sudah di uji coba di komputer kita langsung copas ke ke server menggunakan filezilla
```bash
MSYS_NO_PATHCONV=1 docker run -d --name <nama-container> -e SERVER_NAME=":80" -v $(pwd)/Caddyfile:/etc/caddy/Caddyfile -v $(pwd):/app -p <port>:80 dunglas/frankenphp:1.12.7-php8.2-alpine
```
---
