#!/bin/sh
echo "Starting cloudflare-ddns..."

echo "$CRON_EXPRESSION sh /etc/cron.d/update.sh > /proc/1/fd/1 2>/proc/1/fd/2" > /etc/cron.d/ddns

chmod 0644 /etc/cron.d/ddns
crontab /etc/cron.d/ddns

crond -f
