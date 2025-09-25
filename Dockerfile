# Stage 1: Composer dependencies
FROM composer:2.7 AS vendor

WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Stage 2: Final PHP-Apache image
FROM php:8.2-apache

WORKDIR /var/www/html

# Install PHP extensions and tools
RUN apt-get update && apt-get install -y \
    unzip git libonig-dev libzip-dev zip curl \
    && docker-php-ext-install pdo_mysql mbstring zip \
    && a2enmod rewrite

# Copy project files
COPY . .

# Copy vendor from stage 1
COPY --from=vendor /app/vendor ./vendor

# Permissions
RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 80

CMD ["apache2-foreground"]
