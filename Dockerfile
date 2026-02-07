FROM php:8.2-fpm

ARG user=app
ARG uid=1000

# System dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# App directory
WORKDIR /var/www

# COPY THE APPLICATION (ESTO FALTABA)
COPY . .

# Permissions (Laravel lo necesita)
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Run as www-data (simple y estable)
USER www-data

# Start PHP-FPM
CMD ["php-fpm"]
