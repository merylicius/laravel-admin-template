FROM php:8.2

# use bash with login shell (loads .bashrc)
SHELL ["/bin/bash", "-lc"]

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_mysql exif

RUN docker-php-ext-enable exif

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

RUN nvm install 18

RUN npm install -g yarn

COPY package.json /laravel-app/package.json

WORKDIR /laravel-app

RUN yarn install

#COPY composer.json /laravel-app/composer.json

#COPY composer.lock /laravel-app/composer.lock

COPY . /laravel-app

RUN composer install

RUN yarn run build