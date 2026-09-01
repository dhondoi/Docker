# DOCKERFILE
```Dockerfile
FROM composer:2.6 AS vendor
WORKDIR /app

COPY composer.json composer.lock ./

RUN composer install \
    --no-dev \
    --no-interaction \
    --prefer-dist \
    --optimize-autoloader \
    --no-scripts

# STAGE 2: Production Image
FROM dunglas/frankenphp:1.12.7-php8.2-alpine

RUN install-php-extensions \
    pdo_mysql \
    pcntl \
    zip \
    opcache \
    redis

WORKDIR /app

COPY --from=vendor /app/vendor ./vendor
COPY --chown=www-data:www-data . .

RUN php artisan optimize:clear && php artisan package:discover --ansi

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN chown -R www-data:www-data /data /config /app/storage /app/bootstrap/cache

USER www-data

ENV SERVER_NAME=":8000"
EXPOSE 8000

# Set environment variable agar FrankenPHP tahu lokasi skrip worker
# ENV FRANKENPHP_CONFIG="worker /app/public/frankenphp-worker.php"


# Jalankan server FrankenPHP secara langsung
CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]
```
# DOCKERIGNORE
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
!/bootstrap/cache/.gitignore
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
# CADDYFILE
```Caddyfile
{
	frankenphp {
        worker /app/public/frankenphp-worker.php 4
    }

	servers {
		trusted_proxies static private_ranges
		client_ip_headers CF-Connecting-IP
	}
}

:8000 {
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
	php_server {
        index frankenphp-worker.php
    }
}
```
# WORKER
```php
<?php

// 1. Cek lingkungan FrankenPHP lebih awal
if (!function_exists('frankenphp_handle_request')) {
    echo "Skrip ini hanya bisa dijalankan di dalam server FrankenPHP.\n";
    exit(1);
}

define('LARAVEL_START', microtime(true));

use Illuminate\Contracts\Http\Kernel;
use Illuminate\Http\Request;

require __DIR__.'/../vendor/autoload.php';

$app = require_once __DIR__.'/../bootstrap/app.php';
$kernel = $app->make(Kernel::class);

// 2. Callback penanganan request
$handler = static function () use ($kernel) {
    $request = Request::capture();
    $response = $kernel->handle($request);
    
    $response->send();
    
    $kernel->terminate($request, $response);
};

// 3. Worker loop dengan pembersihan memori & state
$maxRequests = (int) ($_SERVER['MAX_REQUESTS'] ?? 500);

for ($nbRequests = 0; $nbRequests < $maxRequests; $nbRequests++) {
    $keepRunning = \frankenphp_handle_request($handler);

    // --- PEMBERSIHAN STATE UNTUK MENCEGAH DATA/MEMORY LEAK ---
    
    // A. Clear Auth State agar User A tidak ter-login sebagai User B
    if ($app->resolved('auth')) {
        $app->make('auth')->forgetGuards();
    }

    // B. Clear Scoped Instances (Service Provider state)
    $app->forgetScopedInstances();

    // C. Clear Query Log agar RAM tidak membengkak
    if ($app->resolved('db')) {
        $app->make('db')->flushQueryLog();
    }

    // D. Pemicu Garbage Collector PHP
    gc_collect_cycles();

    if (!$keepRunning) {
        break;
    }
}
```
