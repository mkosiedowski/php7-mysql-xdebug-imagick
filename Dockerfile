FROM php:7.1.5-fpm-alpine

RUN apk update && apk add --no-cache --virtual .build-deps zlib-dev icu-dev g++ gcc perl autoconf ca-certificates openssl libjpeg-turbo-dev libpng-dev freetype-dev \
 && update-ca-certificates \
 && docker-php-ext-install zip intl mysqli pdo_mysql pcntl bcmath \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
 && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)  \
 && docker-php-ext-install -j${NPROC} gd \
 && curl -sS https://getcomposer.org/installer | php \
 && mv composer.phar /usr/bin/composer \
 && apk add make pcre-dev \
 && pecl install xdebug \
 && pecl install apcu-beta \
 && pecl install apcu_bc-beta \
 && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini \
 && echo extension=apc.so >> /usr/local/etc/php/conf.d/apcu.ini \
 && apk del .build-deps g++ gcc autoconf make \
 && apk add icu-libs libjpeg-turbo libpng freetype bash
