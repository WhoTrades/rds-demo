#!/usr/bin/env bash
set -m
docker-php-entrypoint "$@" &
cron

fg %1