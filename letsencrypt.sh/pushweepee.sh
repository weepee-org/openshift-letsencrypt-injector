#!/bin/bash

# OPENSHIFT_BUILD_NAMESPACE="test3"
OPENSHIFT_MASTER_INTERNAL="172.31.33.163"
DOMAINSMAP=/data/domainsmap.txt

grep -v '^#' $DOMAINSMAP > /tmp/$$.txt

while read options; do
  STAMP=$(date)
  map=($options)
  echo "[${STAMP}] Pushing route ${map[1]}${map[2]} to $OPENSHIFT_BUILD_NAMESPACE/${map[3]}..."
  echo -- curl \
    -F "domain=${map[1]}" \
    -F "path=${map[2]}" \
    -F "route=${map[3]}" \
    -F "cert=@/data/certs/${map[1]}/cert.pem" \
    -F "privkey=@/data/certs/${map[1]}/privkey.pem" \
    -F "fullchain=@/data/certs/${map[1]}/fullchain.pem" \
    http://$OPENSHIFT_MASTER_INTERNAL:8080/${map[0]}/updatecerts/$OPENSHIFT_BUILD_NAMESPACE
done < /tmp/$$.txt
exit
