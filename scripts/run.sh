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
./createdomains.sh
echo "[${STAMP}] Create/Update certificates..."
./letsencrypt.sh -c
./pushroutes.sh
sleep 1d