FROM php:7.1.4-fpm

RUN apt-get update --fix-missing \
    && curl -sL https://deb.nodesource.com/setup | bash - \
    && apt-get install -y git libssl-dev zlib1g-dev libicu-dev g++ \
    && pecl install apcu-beta \
    && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini
RUN docker-php-ext-install zip mbstring intl mysqli pdo_mysql pcntl

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/bin/composer

RUN apt-get install pkg-config libmagickwand-dev wget -y \
    && cd /tmp \
    && wget https://pecl.php.net/get/imagick-3.4.3.tgz \
    && tar xvzf imagick-3.4.3.tgz \
    && cd imagick-3.4.3 \
    && phpize \
    && ./configure \
    && make install \
    && rm -rf /tmp/imagick-3.4.3 \
    && echo extension=imagick.so >> /usr/local/etc/php/conf.d/imagick.ini


RUN apt-get update --fix-missing \
    && apt-get install -y cron \
    && pecl install xdebug \
    && docker-php-ext-install bcmath
