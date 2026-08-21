- **Build dari Dockerfile**
```bash
docker build -t app-laravel-franken .
```
- **Docker Run image hasil build**
```bash
docker run -d --name laravel-app --network my-network -p 81:80 --env-file .env -v $(pwd)/Caddyfile:/etc/frankenphp/Caddyfile app-laravel-franken
```
