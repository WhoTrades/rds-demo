FROM php:7.4-cli

# Prerequisites
RUN apt-get update \
&& apt-get install -y git wget libzmq3-dev libzip-dev cron \
&& cd ~ \
&& git clone git://github.com/mkoppanen/php-zmq.git \
&& cd php-zmq \
&& phpize && ./configure \
&& make \
&& make install \
&& cd .. \
&& rm -rf php-zmq \
&& docker-php-ext-enable zmq \
&& wget https://getcomposer.org/download/1.10.17/composer.phar -O composer.phar

# Websockets
RUN mkdir -p /var/www/websocket
COPY composer* /var/www/websocket/

RUN cd /var/www/websocket \
&& php ~/composer.phar install

COPY ws.php /var/www/websocket/ws.php
RUN touch /var/log/ws.log

ENTRYPOINT ["php", "/var/www/websocket/ws.php"]
CMD ["5554", " >> /var/log/ws.log", "2>&1"]