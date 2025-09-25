# Stage 1: Build dependencies with Composer
FROM composer:2 AS build

WORKDIR /app
COPY . .
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Stage 2: Production image with Apache + PHP
FROM php:8.2-apache

# Install required PHP extensions for Laravel
RUN apt-get update && apt-get install -y libonig-dev unzip git \
    && docker-php-ext-install pdo pdo_mysql mbstring bcmath

# Set working directory
WORKDIR /var/www/html

# Tell Apache to use Laravel's public folder as DocumentRoot
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copy built app from composer stage
COPY --from=build /app /var/www/html

# Fix permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
CMD ["apache2-foreground"]
