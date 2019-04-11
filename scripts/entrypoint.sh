#!/bin/sh

set -e

mkdir -p /deploy

if [ ! -f /deploy/touched ]; then
    python /app/scripts/entrypoint.py
    touch /deploy/touched
fi

exec /usr/sbin/apache2ctl -D FOREGROUND
