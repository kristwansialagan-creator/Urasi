#!/bin/bash

# Build script for Wasmer.io deployment

echo "Starting build process..."

# Install Composer dependencies
echo "Installing Composer dependencies..."
composer install --optimize-autoloader --no-dev --no-interaction

# Install Node.js dependencies
echo "Installing Node.js dependencies..."
npm ci --only=production

# Build frontend assets
echo "Building frontend assets..."
npm run build

# Laravel optimizations
echo "Optimizing Laravel..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Set permissions
echo "Setting permissions..."
chmod -R 755 storage bootstrap/cache

echo "Build completed successfully!"