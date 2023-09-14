#docker file for laravel php 8.1
FROM php:8.1-apache

#Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    locales \
    libzip-dev \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libpq-dev \
    libonig-dev \
    libxml2 \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libpng-dev \
    libjpeg-dev \
    nodejs\
    npm

#Clear cache \
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

#Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd

#Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#Set working directory
WORKDIR /var/www/html

Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www/html

RUN composer install
RUN php artisan key:generate
RUN npm install
RUN npm run build
RUN a2enmod rewrite
open on port 8000
EXPOSE 80
