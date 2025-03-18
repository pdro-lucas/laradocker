FROM nginx:stable-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

RUN sed -i "s/user nginx/user root/g" /etc/nginx/nginx.conf

COPY ./nginx/default.conf /etc/nginx/conf.d/

RUN mkdir -p /var/www/html
