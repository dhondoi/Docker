## RUN
### Tanpa SSL
```bash
MSYS_NO_PATHCONV=1 docker run -d --name <nama-container> -e SERVER_NAME=":80" -p <port>:80 dunglas/frankenphp:1.12.7-php8.2-alpine
```
### Menggunakan Caddyfile
- buat file `Caddyfile`
- masukkan ke docker
```bash
MSYS_NO_PATHCONV=1 docker run -d --name <nama-container> -e SERVER_NAME=":80" -v $(pwd)/Caddyfile:/etc/caddy/Caddyfile -p <port>:80 dunglas/frankenphp:1.12.7-php8.2-alpine
```
