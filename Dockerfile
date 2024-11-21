 # Use official PHP image with FPM
FROM php:8.2-fpm

# Install system dependencies (necessary for Laravel)
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libssl-dev \
    pkg-config \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions required for Laravel (e.g., GD, MongoDB)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# Install MongoDB extension
RUN pecl install mongodb && docker-php-ext-enable mongodb

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy application files into the container
COPY . .

# Install Laravel dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Set permissions for Laravel storage and cache
RUN chown -R www-data:www-data /var/www && chmod -R 755 /var/www

# Expose the port that your application will run on (usually 8000 for PHP built-in server)
EXPOSE 8000

# Start PHP built-in server on the specified port
CMD php artisan serve --host=0.0.0.0 --port=8000



