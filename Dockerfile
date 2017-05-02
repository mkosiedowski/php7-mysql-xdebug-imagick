FROM php:7.1.4-fpm

RUN apt-get update --fix-missing \
    && curl -sL https://deb.nodesource.com/setup | bash - \
    && apt-get install -y git libssl-dev zlib1g-dev libicu-dev g++ libjpeg62-turbo-dev libpng12-dev libfreetype6-dev cron \
    && pecl install apcu-beta \
    && pecl install apcu_bc-beta \
    && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini \
    && echo extension=apc.so >> /usr/local/etc/php/conf.d/apcu.ini
RUN docker-php-ext-install zip mbstring intl mysqli pdo_mysql pcntl bcmath \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
RUN pecl install xdebug 

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/bin/composer

