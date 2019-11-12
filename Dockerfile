FROM php:7.3.6-fpm

#Install libs
RUN apt-get update && apt-get install -y \
        libpq-dev \
        wget \
        unzip \
        alien \
        libaio1 \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libxml2-dev \
        libldap2-dev \
        libldb-dev


#Configure PGSql
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

#Configure LDAP
RUN  docker-php-ext-install -j$(nproc) pgsql pdo pdo_pgsql soap \
    && docker-php-ext-enable  soap

#Install lib GD
RUN docker-php-ext-install gd

#Rename php.ini
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

##Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

##Install Intl
RUN apt-get install -y zlib1g-dev libicu-dev g++ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

##Install Zip
RUN apt-get install -y \
        libzip-dev \
        zip \
  && docker-php-ext-configure zip --with-libzip \
  && docker-php-ext-install zip