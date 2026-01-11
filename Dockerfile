# Dockerfile for Wasmer.io deployment
FROM php:8.3-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nodejs \
    npm

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy all files
COPY . .

# Install dependencies and build
RUN composer install --optimize-autoloader --no-dev --no-scripts \
    && npm ci \
    && npm run build \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Set permissions
RUN chmod -R 755 storage bootstrap/cache

EXPOSE 8000

CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]