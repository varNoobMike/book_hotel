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

# Install required PHP extensions for Laravel
RUN docker-php-ext-install pdo pdo_mysql mbstring bcmath

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
