# DOCKERFILE
```Dockerfile
FROM composer:2.8 AS vendor
WORKDIR /app

COPY composer.json composer.lock ./

RUN composer install \
    --no-dev \
    --no-interaction \
    --prefer-dist \
    --optimize-autoloader \
    --no-scripts

# STAGE 2: Production Image
FROM dunglas/frankenphp:1.12.7-php8.4-alpine

RUN install-php-extensions \
    pdo_mysql \
    pcntl \
    zip \
    opcache \
    redis

WORKDIR /app

COPY --from=vendor /app/vendor ./vendor
COPY --chown=www-data:www-data . .

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN php artisan package:discover --ansi && \
    php artisan config:clear && \
    php artisan event:clear

RUN chown -R www-data:www-data /data /config /app/storage /app/bootstrap/cache

USER www-data

ENV SERVER_NAME=":8000"
EXPOSE 8000

# Set environment variable agar FrankenPHP tahu lokasi skrip worker
ENV FRANKENPHP_CONFIG="worker /app/public/frankenphp-worker-10-down.php"


# Jalankan server FrankenPHP secara langsung
CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]
```

# WORKER FILE
```php
<?php

use Illuminate\Contracts\Http\Kernel;
use Illuminate\Http\Request;

require __DIR__.'/../vendor/autoload.php';

$app = require_once __DIR__.'/../bootstrap/app.php';
$kernel = $app->make(Kernel::class);

// Pengecekan apakah berjalan di dalam lingkungan FrankenPHP
if (!function_exists('frankenphp_handle_request')) {
    echo "Skrip ini hanya bisa dijalankan di dalam server FrankenPHP.\n";
    exit(1);
}

$handler = static function () use ($kernel) {
    $request = Request::capture();
    $response = $kernel->handle($request);
    $response->send();
    $kernel->terminate($request, $response);
};

$maxRequests = (int) ($_SERVER['MAX_REQUESTS'] ?? 500);
for ($nbRequests = 0; $nbRequests < $maxRequests; $nbRequests++) {
    $keepRunning = \frankenphp_handle_request($handler);

    gc_collect_cycles();

    if (!$keepRunning) {
        break;
    }
}
```
