# DOCKERFILE
```Dockerfile
FROM php:8.4-cli

WORKDIR /app

COPY --chown=www-data:www-data . /app

RUN install-php-extensions \
    pdo_mysql \
    pcntl \
    zip \
    opcache \
    redis

COPY --from=composer:2.8 /usr/bin/composer /usr/bin/composer

RUN composer install && \
    composer require laravel/octane && \
    php artisan octane:install --server=frankenphp

EXPOSE 8000

CMD php artisan octane:frankenphp
```
# DOCKERIGNORE
```.dockerignore
/.phpunit.cache
/node_modules
/public/build
/public/hot
/public/storage
/storage/*.key
/storage/pail
/vendor
.env
.env.backup
.env.production
.phpactor.json
.phpunit.result.cache
Homestead.json
Homestead.yaml
npm-debug.log
yarn-error.log
/auth.json
/.fleet
/.idea
/.nova
/.vscode
/.zed
```
# DOCKER COMPOSE
```docker-compose.yaml
name: test-franken

services:
  laravel_franken_service:
    container_name: laravel_franken_container
    image: laravel_franken_image
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - 8001:8000
    env_file:
      - $PWD/.env
```
