# Use official PHP 8.1 FPM image
FROM php:8.1-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    zip \
    libonig-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install pdo pdo_mysql zip mbstring exif pcntl gd

# Install Composer globally
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy application files except what's in .dockerignore
COPY . .

# Install PHP dependencies (production)
RUN composer install --no-dev --optimize-autoloader

# Set permissions for Laravel folders
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose PHP-FPM port
EXPOSE 9000

# Run PHP-FPM server
CMD ["php-fpm"]
