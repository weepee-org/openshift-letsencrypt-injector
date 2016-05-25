FROM alpine:3.3
MAINTAINER Joeri van Dooren <ure@mororless.be>

# Run scripts
ADD scripts/run.sh /scripts/run.sh
ADD letsencrypt.sh/letsencrypt.sh /letsencrypt/letsencrypt.sh
ADD letsencrypt.sh/pushroutes.sh /letsencrypt/pushroutes.sh
ADD letsencrypt.sh/createdomains.sh /letsencrypt/createdomains.sh
ADD letsencrypt.sh/config /letsencrypt/config
ADD letsencrypt.sh/domainsmap.txt /letsencrypt/domainsmap.txt

RUN apk --update add curl bash openssl apache2 && rm -f /var/cache/apk/* && \
mkdir -p /app/.well-known/acme-challenge && chmod -R a+rwx /app && \
mkdir /run/apache2/ && \
chmod a+rwx /run/apache2/ && \
mkdir /data && chmod -R a+rwx /data && chmod -R a+rx /scripts/*.sh && chmod -R a+rx /letsencrypt/*.sh

# Apache config
ADD apache2/httpd.conf /etc/apache2/httpd.conf

# Exposed Port
EXPOSE 8080

WORKDIR /letsencrypt

ENTRYPOINT ["/scripts/run.sh"]

# Set labels used in OpenShift to describe the builder images
LABEL io.k8s.description="Alpine linux based Letsencrypt container" \
      io.k8s.display-name="alpine apache" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="letsencrypt" \
      io.openshift.non-scalable="true"
