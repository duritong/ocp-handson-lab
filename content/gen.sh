#!/bin/bash -e

cd $(readlink -f $(dirname $0))
source ./vars

cat index.md | sed "s/APPS_DOMAIN/${APPS_DOMAIN}/g" | discount-mkd2html -css simple.min.css | sed 's@title><@title>OpenShift HandsOn<@' > index.html
