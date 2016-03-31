FROM php:7.0.4-apache

MAINTAINER Pablo Morales <pablofmorales@gmail.com>

RUN apt-get -y update
RUN apt-get install -y mysql-client git zip wget
RUN docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql
COPY php.ini /usr/local/etc/php

RUN pecl install -o -f xdebug \
    && rm -rf /tmp/pear \
    && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20121212/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini

RUN a2enmod rewrite
#RUN apache2-foreground
RUN curl -O https://getcomposer.org/composer.phar
RUN mv composer.phar /usr/local/bin/composer
RUN chmod a+x /usr/local/bin/composer

RUN wget https://phar.phpunit.de/phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit
RUN chmod a+x /usr/local/bin/phpunit

#ADD . /var/www
#RUN composer install
# Update the default apache site with the config we created.
#RUN mkdir /www && mkdir /www/public
RUN echo "\n<FilesMatch \\.php$>\nSetHandler application/x-httpd-php\n</FilesMatch>" >> /etc/apache2/apache2.conf

EXPOSE 80

RUN service apache2 restart

