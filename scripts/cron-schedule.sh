#!/usr/bin/env bash

mkdir /etc/cron.d 2>/dev/null

cron="* * * * * vagrant $2/bundle exec wheneverize >> /dev/null 2>&1"

echo "$cron" > "/etc/cron.d/$1"
service cron restart
