#!/bin/bash -e

cd $(readlink -f $(dirname $0))
source ./vars

cat index.md | sed "s/APPS_DOMAIN/${APPS_DOMAIN}/g" | markdown > index.html
