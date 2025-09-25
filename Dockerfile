# Stage 1: Build dependencies with Composer
FROM composer:2 AS build

WORKDIR /app

# Copy composer files first
COPY composer.json composer.lock ./

# Install dependencies without dev packages
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Copy the rest of the project
COPY . .

# Stage 2: Production image with Apache + PHP
FROM php:8.2-apache

# Install required system packages and PHP extensions for Laravel
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libicu-dev \
    libonig-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring bcmath zip gd intl

# Enable Apache mod_rewrite for Laravel routing
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy files from build stage
COPY --from=build /app /var/www/html

# Fix permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port
EXPOSE 80

# Run Apache
CMD ["apache2-foreground"]
