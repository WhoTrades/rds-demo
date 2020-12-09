#!/usr/bin/env bash
set -m
docker-php-entrypoint "$@" &
/etc/init.d/ssh start

fg %1