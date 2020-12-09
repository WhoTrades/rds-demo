FROM php:7.4-fpm

# Prerequisites
RUN apt-get update \
&& apt-get install -y git wget cron openssh-server \
&& cd ~ \
&& wget https://getcomposer.org/download/1.10.17/composer.phar -O composer.phar

# Completely insecure
RUN useradd -ms /bin/bash deploy
COPY deploy.pub /home/deploy/.ssh/deploy.pub
RUN cat /home/deploy/.ssh/deploy.pub >> /home/deploy/.ssh/authorized_keys

# App dir
RUN mkdir -p /var/pkg \
&& chown -R deploy:deploy /var/pkg \
#&& mkdir /var/pkg/demo-application \
#&& chown -R deploy:deploy /var/pkg/demo-application \
#&& chmod -R 0755 /var/pkg/demo-application \
&& mkdir /var/www/app \
&& ln -fns /var/pkg/demo-application /var/www/app/release
#&& chown -R deploy:deploy /var/pkg/demo-application

# Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["php-fpm"]