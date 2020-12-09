FROM php:7.4-fpm

# Prerequisites
RUN apt-get update \
&& apt-get install -y libzmq3-dev git wget libzip-dev libpq-dev cron \
&& cd ~ \
&& wget https://getcomposer.org/download/1.10.17/composer.phar -O composer.phar \
&& git clone git://github.com/mkoppanen/php-zmq.git \
&& cd php-zmq \
&& phpize && ./configure \
&& make \
&& make install \
&& cd .. \
&& rm -rf php-zmq \
&& docker-php-ext-enable zmq \
&& docker-php-ext-install bcmath \
&& docker-php-ext-install zip \
&& docker-php-ext-install pdo \
&& docker-php-ext-install pdo_pgsql \
&& docker-php-ext-install pcntl

# RDS
RUN mkdir -p /var/www/rds \
&& git clone https://github.com/WhoTrades/rds.git /var/www/rds \
&& cd /var/www/rds \
&& php ~/composer.phar install \
&& chmod -R 777 /var/www/rds/web/assets \
&& mkdir /tmp/rds/ \
&& mkdir /tmp/rds/mutex \
&& mkdir /tmp/rds/HTML \
&& mkdir /tmp/rds/debug/ \
&& mkdir /tmp/rds/debug/mail/ \
&& chmod -R 777 /tmp/rds/

# ZMQ patch
COPY ./ZMQSocket_fix.patch /var/www/rds
RUN cd /var/www/rds/src \
&& git apply ../ZMQSocket_fix.patch

# Cron
RUN touch /var/log/cron.log \
&& echo "* * * * * root cd /var/www/rds && /usr/local/bin/php yii.php deploy/index test_worker >> /var/log/cron.log 2>&1" > /etc/cron.d/rds \
&& echo "1 * * * * root cd /var/www/rds && /usr/local/bin/php yii.php remove-packages/index test_worker >> /var/log/cron.log 2>&1" >> /etc/cron.d/rds

# Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["php-fpm"]