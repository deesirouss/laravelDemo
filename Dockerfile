FROM php:7.4-fpm
 
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

WORKDIR /var/www/ 

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
 
COPY . /var/www
 
RUN chmod -R 777 storage/ bootstrap/

EXPOSE 8000
