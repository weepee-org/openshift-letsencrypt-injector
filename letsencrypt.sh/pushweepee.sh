#!/bin/bash

OPENSHIFT_BUILD_NAMESPACE="test3"
OPENSHIFT_MASTER_INTERNAL="172.31.33.163"

curl \
  -F "userid=1" \
  -F "filecomment=This is an image file" \
  -F "image=@/home/user1/Desktop/test.jpg" \
  http://$OPENSHIFT_MASTER_INTERNAL:8080/$OPENSHIFT_BUILD_NAMESPACE/route1
