FROM php:7.1.4-fpm-alpine

RUN apk update && apk add --no-cache --virtual .build-deps zlib-dev icu-dev g++ gcc perl autoconf ca-certificates openssl \
 && update-ca-certificates \
 && docker-php-ext-install zip intl mysqli pdo_mysql pcntl bcmath \
 && curl -sS https://getcomposer.org/installer | php \
 && mv composer.phar /usr/bin/composer \
 && apk add imagemagick-dev make libtool \
    && cd /tmp \
    && wget https://pecl.php.net/get/imagick-3.4.3.tgz \
    && tar xvzf imagick-3.4.3.tgz \
    && cd imagick-3.4.3 \
    && phpize \
    && ./configure \
    && make install \
    && rm -rf /tmp/imagick-3.4.3 \
    && echo extension=imagick.so >> /usr/local/etc/php/conf.d/imagick.ini \
 && pecl install xdebug \
 && apk del .build-deps g++ gcc autoconf make \
 && apk add icu-libs
