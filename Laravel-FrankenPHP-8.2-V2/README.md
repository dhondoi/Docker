## DOCKERFILE

```Dockefile
FROM dunglas/frankenphp:latest-php8.2-alpine AS runner

WORKDIR /app

# Install ekstensi PHP minimum yang dibutuhkan Laravel 8
RUN install-php-extensions \
    pdo_mysql \
    bcmath \
    gd \
    intl \
    zip \
    opcache \
    redis

# Copy Composer dari official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Salin manifes dependensi untuk memanfaatkan caching layer Docker
COPY composer.json composer.lock ./

# Install dependensi khusus produksi tanpa skrip dev
RUN composer install \
    --no-dev \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --no-autoloader \
    --prefer-dist

# Salin seluruh kode aplikasi dengan kepemilikan root (read-only untuk proses web)
COPY --chown=root:root . /app

# Salin sisa kode aplikasi dan buat autoloader teroptimasi
RUN composer dump-autoload --optimize --no-dev --classmap-authoritative

# Gunakan template php.ini bawaan produksi
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Tambahkan pengerasan keamanan (security hardening) PHP
RUN echo "expose_php = Off" >> "$PHP_INI_DIR/conf.d/security.ini" && \
    echo "display_errors = Off" >> "$PHP_INI_DIR/conf.d/security.ini" && \
    echo "display_startup_errors = Off" >> "$PHP_INI_DIR/conf.d/security.ini" && \
    echo "session.cookie_httponly = On" >> "$PHP_INI_DIR/conf.d/security.ini" && \
    echo "session.cookie_secure = On" >> "$PHP_INI_DIR/conf.d/security.ini" && \
    echo "disable_functions = exec,passthru,shell_exec,system,proc_open,popen,curl_multi_exec,parse_ini_file,show_source" >> "$PHP_INI_DIR/conf.d/security.ini"

# Konfigurasi Environment Produksi
ENV SERVER_NAME=":8080" \
    PHP_INI_SCAN_DIR="/usr/local/etc/php/conf.d"

# Buat direktori kerja penyimpanan dan batasi hak akses tulis hanya pada folder ini
RUN mkdir -p /app/storage/logs \
    /app/storage/framework/sessions \
    /app/storage/framework/views \
    /app/storage/framework/cache \
    /app/bootstrap/cache \
    && chown -R www-data:www-data /app/storage /app/bootstrap/cache \
    && chmod -R 775 /app/storage /app/bootstrap/cache

# Jalankan container menggunakan user non-root
USER www-data

# Port non-privilege di atas 1024
EXPOSE 8080

CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]
```

## DOCKERIGNORE

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

#Caddyfile
Caddyfile
```

## BUILD IMAGE

```cmd
docker build  -t <nama_image>[:<tag>] .
```

- atau

```cmd
docker build --platform linux/arm64 -t <nama_image>[:<tag>] . 
```

## DISTRIBUSI DOCKER IMAGE

```cmd
# Save langsung di-kompres ke format .tar.gz
docker save <nama_image>[:<tag>] | gzip > <nama_image>.tar.gz

# Transfer File ke Server

# Load Image Baru:
# (Docker akan merebut tag nama_repository:tag ke image baru ini, sedangkan image lama akan menjadi <none>:<none>)
docker load -i <nama_image>.tar.gz

#Hentikan & Hapus Container Lama yang Masih Berjalan:
docker container rm -f <nama_container>

# Jalankan Container Baru dari Image Terbaru (RUN section)

# Pembersihan Cache Laravel (Pasca-Deployment)
# Setelah container baru berjalan, bersihkan cache internal bawaan Laravel agar kode baru langsung terasa:
docker exec -it nama_container php artisan migrate --force
docker exec -it nama_container php artisan config:clear
docker exec -it nama_container php artisan route:clear
docker exec -it nama_container php artisan view:clear

# Pembersihan File & Image Sampah (Cleanup)
# Karena Anda tidak pernah mengganti tag, sisa-sisa image lama akan menumpuk menjadi dangling image (<none>:<none>). Jalankan ini untuk menghemat disk server:
# Hapus image lama yang kehilangan tag
docker image prune -f
# Hapus file tar.gz agar tidak memenuh-nenuhi disk
rm <nama_image>.tar.gz
```

## CADDYFILE

```Caddyfile
{
    # Matikan telemetry Caddy
	admin off
	# Konfigurasi Global FrankenPHP
	frankenphp
	order php_server before file_server
	servers {
		trusted_proxies static private_ranges
		client_ip_headers CF-Connecting-IP
	}
}

:8080 {
	# Root folder Laravel
	root * /app/public

	# Batas ukuran upload
	request_body {
		max_size 10MB
	}

	# Optimasi Kompresi
	encode gzip zstd

    @blocked path_regexp blocked \.(env|git|htaccess|yml|yaml|json|lock|md|log)$
	respond @blocked 403

	# Security Headers
	header {
		# Mencegah site di-frame oleh situs lain (Anti-Clickjacking)
		X-Frame-Options "DENY"
		# Mencegah browser menebak-nebak tipe MIME (Anti-MIME Sniffing)
		X-Content-Type-Options "nosniff"
		# Proteksi XSS pada browser lama
		X-XSS-Protection "1; mode=block"
		Strict-Transport-Security "max-age=31536000; includeSubDomains"
		# Mengontrol informasi referrer yang dikirim
		Referrer-Policy "strict-origin-when-cross-origin"
        # Membatasi akses fitur perangkat keras browser
		Permissions-Policy "camera=(), microphone=(), geolocation=()"
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

	# Menjalankan worker PHP dan hanya mengeksekusi index.php
	php_server {
		# Fitur Worker Mode FrankenPHP untuk Laravel (Sangat Cepat)
		# worker /app/public/index.php
	}

    # Melayani file fisik jika ada (CSS, JS, Gambar di storage/public)
	file_server
}
```

## DOCKER RUN

```cmd
docker run -d --name <nama_container> --network <nama_network> -p 8080:8080 --restart unless-stopped --read-only --tmpfs /tmp:rw,noexec,nosuid,size=64m --tmpfs /var/tmp:rw,noexec,nosuid --mount type=tmpfs,destination=/app/storage/framework/views,tmpfs-mode=777 --mount type=tmpfs,destination=/app/storage/framework/cache,tmpfs-mode=777 --mount type=tmpfs,destination=/app/storage/framework/sessions,tmpfs-mode=777 --mount type=tmpfs,destination=/app/bootstrap/cache,tmpfs-mode=777 -v <nama_volume>:/app/storage/logs -v $PWD/.env:/app/.env -v $PWD/Caddyfile:/etc/caddy/Caddyfile <nama_image>[:<tag>]
```

## DOCKER COMPOSE
```yaml
# version: '3.8'

services:
  app:
    # build:
      # context: .
      # dockerfile: Dockerfile
    image: <nama_image>[:<tag>]
    container_name: <nama_container>
    restart: unless-stopped
    ports:
      - "8080:8080"

    # Hubungkan service ini ke network eksternal
    networks:
      - <nama_network>

    # Mengunci sistem berkas menjadi Read-Only (Pengerasan Keamanan)
    read_only: true

    # Alokasi direktori sementara di RAM (tmpfs) untuk OS
    tmpfs:
      - /tmp:rw,exec,nosuid,size=64m
      - /var/tmp:rw,exec,nosuid
      - /app/storage/framework/views:rw,exec,mode=777
      - /app/storage/framework/cache:rw,exec,mode=777
      - /app/storage/framework/sessions:rw,exec,mode=777
      - /app/bootstrap/cache:rw,exec,mode=777

    volumes:
      # Persistent Volume untuk simpan berkas log Laravel
      - <nama_volume>:/app/storage/logs

      # Mount file .env secara eksternal (Read-Write)
      - ./.env:/app/.env:rw
      
      # Mount Caddyfile kustom secara eksternal (Read-Write)
      - ./Caddyfile:/etc/caddy/Caddyfile:rw

    # Menyuntikkan variabel lingkungan dari berkas .env lokal
    # env_file:
      # - .env

# Deklarasikan network eksternal yang sudah ada
networks:
  <nama_network>:
    external: true

# Deklarasi Named Volume untuk Log
volumes:
  <nama_volume>:
    driver: local
```

- jalankan compose

```cmd
docker compose up -d
```

## TAMBAHAN

- akses dalam container

```cmd
docker exec -it <nama_container> /bin/ash
```

- optimize
```cmd
masukkan secara langsung atau satu-persatu
php artisan key:generate
php artisan optimize:clear
php artisan config:cache
php artisan event:cache
php artisan route:cache
php artisan view:cache
php artisan optimize
php artisan migrate --seed
```
