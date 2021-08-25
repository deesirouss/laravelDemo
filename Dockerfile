FROM php:7.4-fpm
 
# Arguments defined in docker-compose.yml
ENV USER=ubuntu
ENV UID 1000
 
# Install system dependencies
RUN apt-get update && apt-get install -y \
   git \
   curl \
   libpng-dev \
   libonig-dev \
   libxml2-dev \
   zip \
   unzip
 
# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
 
# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd
# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
 
# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $UID -d /home/$USER $USER
RUN mkdir -p /home/$USER/.composer && \
   chown -R $USER:$USER /home/$USER
 
COPY . /var/www
 
# Set working directory
WORKDIR /var/www/
 
RUN chmod -R 777 *
USER root
RUN composer update
RUN php artisan key:generate
ENV PATH="~/.composer/vendor/bin:./vendor/bin:${PATH}"

