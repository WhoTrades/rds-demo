FROM php:7.4-cli

# Prerequisites
RUN apt-get update \
&& apt-get install -y git wget libzip-dev libpq-dev cron \
&& cd ~ \
&& wget https://getcomposer.org/download/1.10.17/composer.phar -O composer.phar \
&& docker-php-ext-install bcmath \
&& docker-php-ext-install zip \
&& docker-php-ext-install pdo \
&& docker-php-ext-install pdo_pgsql \
&& docker-php-ext-install pcntl

# Build agent
RUN git clone https://github.com/WhoTrades/rds-build-agent.git /var/www/rds-build-agent/ \
&& cd /var/www/rds-build-agent \
&& php ~/composer.phar install \
&& cp /var/www/rds-build-agent/config.local.php-dist /var/www/rds-build-agent/config.local.php

# Deploy user
RUN useradd -ms /bin/bash deploy
COPY deploy /home/deploy/.ssh/deploy
COPY deploy.pub /home/deploy/.ssh/deploy.pub

# Cron
RUN touch /var/log/cron.log \
#mkfifo --mode 0755 /var/log/cron.log \
&& echo "* * * * * root cd /var/www/rds-build-agent && /usr/local/bin/php yii.php deploy/index test_worker >> /var/log/cron.log 2>&1" > /etc/cron.d/build-agent \
&& echo "* * * * * root cd /var/www/rds-build-agent && /usr/local/bin/php yii.php use/index test_worker >> /var/log/cron.log 2>&1" >> /etc/cron.d/build-agent \
&& echo "* * * * * root cd /var/www/rds-build-agent && /usr/local/bin/php yii.php killer/index test_worker >> /var/log/cron.log 2>&1" >> /etc/cron.d/build-agent \
&& echo "* * * * * root cd /var/www/rds-build-agent && /usr/local/bin/php yii.php garbage-collector/index test_worker >> /var/log/cron.log 2>&1" >> /etc/cron.d/build-agent \
&& echo "* * * * * root cd /var/www/rds-build-agent && /usr/local/bin/php yii.php migration/index test_worker >> /var/log/cron.log 2>&1" >> /etc/cron.d/build-agent

ENTRYPOINT cron && tail -f /var/log/cron.log