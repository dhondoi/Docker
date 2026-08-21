1. **Build dari Dockerfile**
```bash
docker build -t app-laravel-franken .
```
2. **Docker Run image hasil build**
```bash
docker run -d --name laravel-app --network my-network -p 81:80 --env-file .env -v $(pwd)/Caddyfile:/etc/frankenphp/Caddyfile app-laravel-franken
```
- atau `.env` mounting mode
```bash
docker run -d --name laravel-app --network my-network -p 81:80 -v $(pwd)/.env:/app/.env -v $(pwd)/Caddyfile:/etc/frankenphp/Caddyfile app-laravel-franken
```
3. **Tamabahan**
```bash
php artisan key:generate
php artisan optimize:clear
php artisan config:cache
php artisan event:cache
php artisan route:cache
php artisan view:cache
php artisan optimize
php artisan migrate --seed
```
