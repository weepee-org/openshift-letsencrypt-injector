#!/bin/bash -x

# these need to be in the env of the pod
#OPENSHIFT_MASTER_INTERNAL="172.31.33.163"
WEEPEE_TOKEN=$(</data/token.txt)

# le callback path
lepath="/.well-known/acme-challenge"

DOMAINSMAP=/data/domainsmap.txt
grep -v '^#' $DOMAINSMAP > /tmp/$$.txt

while read options; do
  STAMP=$(date)
  map=($options)
  echo "[${STAMP}] Pushing route ${map[0]}${map[1]} to $OPENSHIFT_BUILD_NAMESPACE/${map[2]}..."
  curl -s \
    -F "domain=${map[0]}" \
    -F "path=${map[1]}" \
    -F "route=${map[2]}" \
    -F "service=${map[3]}" \
    -F "port=${map[4]}" \
    -F "cert=@/data/certs/${map[0]}/cert.pem" \
    -F "privkey=@/data/certs/${map[0]}/privkey.pem" \
    -F "fullchain=@/data/certs/${map[0]}/fullchain.pem" \
    http://$OPENSHIFT_MASTER_INTERNAL:3000/$WEEPEE_TOKEN/updatecerts/$OPENSHIFT_BUILD_NAMESPACE
    echo
    if [ ${map[1]} = "/" ]; then
      curl -s \
        -F "domain=${map[0]}" \
        -F "path=${lepath}" \
        -F "route=${map[2]}-le" \
        -F "service=letsencrypt" \
        -F "port=${map[4]}" \
        -F "cert=@/data/certs/${map[0]}/cert.pem" \
        -F "privkey=@/data/certs/${map[0]}/privkey.pem" \
        -F "fullchain=@/data/certs/${map[0]}/fullchain.pem" \
        http://$OPENSHIFT_MASTER_INTERNAL:3000/$WEEPEE_TOKEN/updatecerts/$OPENSHIFT_BUILD_NAMESPACE
    fi
done < /tmp/$$.txt
exit
