FROM php:8-fpm-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Create a new group called "php" with the specified group ID
RUN addgroup -g ${GID} --system php

# Create a new user called "laravel" with the specified user ID, belonging to the "laravel" group
RUN adduser -G php --system -D -s /bin/sh -u ${UID} php

RUN sed -i "s/user = www-data/user = php/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = php/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

RUN docker-php-ext-install pdo pdo_mysql

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

USER php

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
