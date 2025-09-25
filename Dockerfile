# Stage 2: Final PHP-Apache image
FROM php:8.2-apache AS stage-1

RUN docker-php-ext-install pdo_mysql mbstring bcmath zip gd intl

# Enable Apache rewrite
RUN a2enmod rewrite

# Set working directory to /var/www/html
WORKDIR /var/www/html

# Copy application from build stage
COPY --from=build /app /var/www/html

# Set correct permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 🔑 Tell Apache to serve from /public
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Expose port 80
EXPOSE 80
# Stage 1: Build dependencies with Composer
FROM composer:2 AS build

WORKDIR /app

# Copy composer files first
COPY composer.json composer.lock ./

# Install dependencies without dev packages
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Copy the rest of the application
COPY . .

# Stage 2: Production image with Apache + PHP
FROM php:8.2-apache

# Enable Apache rewrite module
RUN a2enmod rewrite

# Install required PHP extensions for Laravel
RUN docker-php-ext-install pdo pdo_mysql mbstring bcmath

# Set working directory
WORKDIR /var/www/html

# Copy application from build stage
COPY --from=build /app /var/www/html

# Set correct permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port
EXPOSE 80

# Run Apache
CMD ["apache2-foreground"]
