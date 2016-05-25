#!/bin/sh

STAMP=$(date)
echo "[${STAMP}] Copy domains.txt to persistent storage..."
cp /letsencrypt/domains.txt /data
cp /letsencrypt/domainsmap.txt /data

STAMP=$(date)
echo "[${STAMP}] Starting daemon..."
# run apache httpd daemon
httpd -D FOREGROUND &
sleep 1s
cd /letsencrypt
./letsencrypt.sh -c
sleep 1d
