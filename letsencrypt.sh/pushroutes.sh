#!/bin/bash

# OPENSHIFT_BUILD_NAMESPACE="test3"
OPENSHIFT_MASTER_INTERNAL="172.31.33.163"
DOMAINSMAP=/data/domainsmap.txt
TOKEN=c838ad96-47a8-4260-9d67-df2e644f4f2a

grep -v '^#' $DOMAINSMAP > /tmp/$$.txt

while read options; do
  STAMP=$(date)
  map=($options)
  echo "[${STAMP}] Pushing route ${map[0]}${map[1]} to $OPENSHIFT_BUILD_NAMESPACE/${map[2]}..."
  echo -- curl \
    -F "domain=${map[0]}" \
    -F "path=${map[1]}" \
    -F "route=${map[2]}" \
    -F "cert=@/data/certs/${map[0]}/cert.pem" \
    -F "privkey=@/data/certs/${map[0]}/privkey.pem" \
    -F "fullchain=@/data/certs/${map[0]}/fullchain.pem" \
    http://$OPENSHIFT_MASTER_INTERNAL:8080/$TOKEN/updatecerts/$OPENSHIFT_BUILD_NAMESPACE
done < /tmp/$$.txt
exit
