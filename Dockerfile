# ==========================================================
# Custom WordPress Image (PHP 8.3 FPM on Alpine)
# ==========================================================
FROM wordpress:php8.3-fpm-alpine

WORKDIR /var/www/html

RUN apk add --no-cache bash git nano less \
    && docker-php-ext-install opcache

COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/custom.ini

RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000
CMD ["php-fpm"]
