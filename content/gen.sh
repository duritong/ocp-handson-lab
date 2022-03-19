#!/bin/bash -e

cd $(readlink -f $(dirname $0))
source ./vars

cat index.md | sed -e "s/APPS_DOMAIN/${APPS_DOMAIN}/g" -e "s/IDP_NAME/${IDP_NAME}/g" | discount-mkd2html -css simple.min.css | sed 's@title><@title>OpenShift HandsOn<@' > index.html
