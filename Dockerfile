# Gunakan base image PHP 8.2 dengan FPM dan Alpine Linux untuk ukuran yang lebih kecil
FROM php:8.2-fpm-alpine

# Set direktori kerja
WORKDIR /var/www/html

# Install package yang dibutuhkan sistem dan ekstensi PHP untuk Laravel
RUN apk --no-cache add \
    nginx \
    supervisor \
    curl \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    pdo_mysql \
    zip \
    bcmath \
    && rm -rf /var/cache/apk/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Salin file konfigurasi Nginx dan Supervisor
COPY docker/nginx/default.conf /etc/nginx/http.d/default.conf
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Salin semua file proyek ke dalam image
COPY . .

# Install dependensi Composer
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Atur hak akses folder
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Expose port 80 untuk Nginx
EXPOSE 80

# Jalankan Supervisor untuk mengelola Nginx dan PHP-FPM
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
