#!/bin/bash -e

cd $(readlink -f $(dirname $0))
source ./vars

cat index.md | sed "s/APPS_DOMAIN/${APPS_DOMAIN}/g" | discount-mkd2html -header "OpenShift HandsOn" -css simple.min.css > index.html
