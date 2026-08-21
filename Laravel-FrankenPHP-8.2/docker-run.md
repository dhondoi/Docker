- **Docker Run**
```bash
docker run -d --name laravel-app --network my-network -p 81:80 -e SERVER_NAME=":80" -v $(pwd)/Caddyfile:/etc/frankenphp/Caddyfile -v $(pwd):/app dunglas/frankenphp:1.12.7-php8.2-alpine
```
- 
