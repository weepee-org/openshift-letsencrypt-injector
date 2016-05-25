#!/bin/bash

DOMAINSMAP=/data/domainsmap.txt

grep -v '^#' $DOMAINSMAP > /tmp/$$.txt

while read options; do
  STAMP=$(date)
  map=($options)
  echo "[${STAMP}] Creating domains.txt..."
  echo ${map[1]} >> /tmp/dom$$.txt
  uniq /tmp/dom$$.txt > /data/domains.txt
done < /tmp/$$.txt
exit
