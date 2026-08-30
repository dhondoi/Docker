# CHEATSHEET DOCKER LARAVEL FRANKENPHP V 8.2
## DOCKERFILE
- Buat file `Dockerfile` lalu isi
```Dockerfile
FROM dunglas/frankenphp:1.12.7-php8.2-alpine

# Set working directory
WORKDIR /app

# Install ekstensi PHP untuk Laravel menggunakan helper bawaan FrankenPHP
RUN install-php-extensions \
    pdo_mysql \
    gd \
    intl \
    zip \
    pcntl \
    opcache

# Copy Composer dari official image
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Copy file dependency terlebih dahulu agar memanfaatkan Docker Layer Cache
COPY composer.json composer.lock ./

# Install dependensi tanpa dev & autoloader script
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

# Copy seluruh file proyek ke dalam container
COPY . /app

# Optimasi autoloader Composer & atur izin akses folder Laravel
RUN composer dump-autoload --optimize \
    && chown -R www-data:www-data /app/storage /app/bootstrap/cache \
    && chmod -R 775 /app/storage /app/bootstrap/cache

# Environment variables & Expose Port
ENV SERVER_NAME=":80"
EXPOSE 80
```
## CADDYFILE
- Buat file `Caddyfile` lalu isi
```Caddyfile
{
	servers {
		trusted_proxies static private_ranges
		client_ip_headers CF-Connecting-IP
	}
}

:80 {
	# Root folder Laravel
	root * /app/public

	# Batas ukuran upload
	request_body {
		max_size 10MB
	}

	# Optimasi Kompresi
	encode gzip zstd

	# Security Headers
	header {
		X-Frame-Options "SAMEORIGIN"
		X-Content-Type-Options "nosniff"
		X-XSS-Protection "1; mode=block"
		Strict-Transport-Security "max-age=31536000; includeSubDomains"
		Referrer-Policy "no-referrer-when-downgrade"
		Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'"
		-X-Powered-By
		-Server
	}

	# Restriksi HTTP Method
	@invalid_method not method GET POST HEAD PUT PATCH DELETE OPTIONS
	respond @invalid_method 405

	# Hardening: Pemblokiran PHP di subfolder storage secara rekursif
	@php_in_storage path_regexp storage_php ^/storage/.*\.php$
	respond @php_in_storage 403

	# Hardening: Pemblokiran file tersembunyi (.env, .git)
	@dotfiles {
		path /.*
		not path /.well-known/*
	}
	respond @dotfiles 403

	# Caching Aset Statis
	@static path *.jpg *.jpeg *.png *.gif *.ico *.css *.js *.eot *.ttf *.woff *.woff2 *.svg
	header @static Cache-Control "public, max-age=31536000, no-transform"

	# Melayani file fisik jika ada (CSS, JS, Gambar di storage/public)
	file_server

	# Engine FrankenPHP
	php_server
}
```
## DOCKERIGNORE
- Buat file `.dockerignore` lalu isi
```.dockerignore
# Git & Version Control
.git
.gitignore
.gitattributes

# Environment & File Sensitif
.env
.env.*
*.pem
*.key

# Dependensi Lokal
/vendor
/node_modules

# Storage, Log, & Cache Lokal
/storage/logs/*
/storage/framework/cache/data/*
/storage/framework/sessions/*
/storage/framework/views/*
!/storage/logs/.gitignore
!/storage/framework/cache/data/.gitignore
!/storage/framework/sessions/.gitignore
!/storage/framework/views/.gitignore

# File Docker & Orchestration
Dockerfile*
docker-compose*
.dockerignore

# IDE & System Trash
.idea
.vscode
*.swp
.DS_Store
Thumbs.db

# Testing & Log Build
/tests
phpunit.xml
npm-debug.log
yarn-error.log
README.md
```
## BUILD IMAGE DARI DOCKERFILE
```bash
docker build -t <nama_image>[:<tag>] .
```
## RUN
- `--env-file` Mode
```bash
docker run -d --name <nama_container> --network <nama_network> -p 81:80 --env-file .env -v $PWD/Caddyfile:/etc/frankenphp/Caddyfile <nama_image>[:<tag>]
```
- atau `.env` Mounting Mode
```bash
docker run -d --name <nama_container> --network <nama_network> -p 81:80 -v $PWD/.env:/app/.env -v $PWD/Caddyfile:/etc/frankenphp/Caddyfile <nama_image>[:<tag>]
```
- Tambahan
1. Jika error tambahkan `MSYS_NO_PATHCONV=1` sebelum `docker run`
2. exec
```bash
docker exec -it <nama_container> /bin/ash
```
3. masukkan secara langsung atau satu-persatu
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
