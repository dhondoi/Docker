FROM dunglas/frankenphp:1.12.7-php8.2-alpine

# Set working directory
WORKDIR /app

# Install system dependencies and PHP extensions needed for Laravel
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        gd \
        intl \
        zip \
        pcntl \
        opcache

# Install Composer from official image
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . /app

# Set correct permissions for Laravel
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# Environment variables for FrankenPHP
ENV SERVER_NAME=":80"

# Expose port 80 for HTTP traffic
EXPOSE 80
