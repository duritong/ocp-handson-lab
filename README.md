# OCP Hands On Lab

A simple LAB setup that guides you through OpenShift

## Requirements

* OCP 4
  * openshift-logging deployed
  * user workload monitoring deployed
  * web terminal operator deployed
* An abritrary amount of users
  * Users should be part of group `handson-users`
* Have a default project template deployed so there are some quotas in place

## Prepare

    oc apply -f prepare/
    helm repo add kubeinvaders https://lucky-sideburn.github.io/helm-charts/
    oc adm policy add-scc-to-user -n handson-kubeinvaders privileged -z kubeinvaders
    oc adm policy add-scc-to-user -n handson-kubeinvaders anyuid -z kubeinvaders
    helm upgrade kubeinvaders -i --set-string target_namespace="user20-app" -n handson-kubeinvaders kubeinvaders/kubeinvaders --set route_host=kubeinvaders.$(oc get -n openshift-ingress-operator ingresscontroller default -o json | jq -r .status.domain) --set ingress.enabled=false --set image.tag=v1.9

    oc create route edge -n handson-kubeinvaders --hostname=kubeinvaders.$(oc get -n openshift-ingress-operator ingresscontroller default -o json | jq -r .status.domain) --service=kubeinvaders --insecure-policy=Redirect

## Deploying the guide

    WEBHOOK=`pwgen 40 1`
    MAIN_DOMAIN=xy.com
    oc new-app -n handson-tutorial content/nginx.json -p NAME=handson-tutorial -p SOURCE_REPOSITORY_URL=https://github.com/duritong/ocp-handson-lab -p CONTEXT_DIR=content -p APPLICATION_DOMAIN=handson.$MAIN_DOMAIN GITHUB_WEBHOOK_SECRET=${WEBHOOK}
    echo Webhook ${WEBHOOK}
    echo URL: http://handson.$MAIN_DOMAIN


