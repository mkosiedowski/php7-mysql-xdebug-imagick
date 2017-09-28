FROM php:7.1.9-fpm-alpine

ENV CURL_VERSION 7.55.1
ENV NGHTTP2_VERSION 1.26.0

RUN apk update && apk add --no-cache --virtual .build-deps zlib-dev icu-dev g++ gcc perl autoconf ca-certificates openssl openssl-dev libjpeg-turbo-dev libpng-dev freetype-dev gmp-dev \
 && update-ca-certificates \
 && docker-php-ext-install zip intl mysqli pdo_mysql pcntl bcmath exif intl gmp \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
 && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)  \
 && docker-php-ext-install -j${NPROC} gd \
 && curl -sS https://getcomposer.org/installer | php \
 && mv composer.phar /usr/bin/composer \
 && apk add make pcre-dev \
 && pecl install xdebug \
 && pecl install apcu-beta \
 && pecl install apcu_bc-beta \
 && rm /usr/bin/iconv \
 && curl -SL http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz | tar -xz -C . \
 && cd libiconv-1.14 \
 && ./configure --prefix=/usr/local \
 && curl -SL https://raw.githubusercontent.com/mxe/mxe/7e231efd245996b886b501dad780761205ecf376/src/libiconv-1-fixes.patch | patch -p1 -u \
 && make \
 && make install \
 && cd .. \
 && rm -rf libiconv-1.14 \
 && wget https://github.com/nghttp2/nghttp2/releases/download/v$NGHTTP2_VERSION/nghttp2-$NGHTTP2_VERSION.tar.bz2 && \
    tar xf nghttp2-$NGHTTP2_VERSION.tar.bz2 && \
    rm nghttp2-$NGHTTP2_VERSION.tar.bz2 && \
    cd nghttp2-$NGHTTP2_VERSION && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    cd .. && \
    rm -r nghttp2-$NGHTTP2_VERSION \
 && wget https://curl.haxx.se/download/curl-$CURL_VERSION.tar.bz2 && \
    tar xf curl-$CURL_VERSION.tar.bz2 && \
    rm curl-$CURL_VERSION.tar.bz2 && \
    cd curl-$CURL_VERSION && \
    ./configure \
        --with-nghttp2=/usr \
        --prefix=/usr \
        --with-ssl \
        --enable-ipv6 \
        --enable-unix-sockets \
        --without-libidn \
        --disable-static \
        --disable-ldap \
        --with-pic && \
    make && \
    make install && \
    cd .. && \
    rm -r curl-$CURL_VERSION \
 && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini \
 && echo extension=apc.so >> /usr/local/etc/php/conf.d/apcu.ini \
 && apk del .build-deps g++ gcc autoconf make \
 && apk add icu-libs libjpeg-turbo libpng freetype bash gmp

ENV LD_PRELOAD /usr/local/lib/preloadable_libiconv.so
