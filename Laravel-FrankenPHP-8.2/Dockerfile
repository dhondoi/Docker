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
