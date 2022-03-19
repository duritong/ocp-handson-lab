# OpenShift Hands on Lab

This tutorial gives you a basic overview on OpenShift and guides you through the various features.

The idea is to go through the tutorial from the beginning to the end.

## Requirements

All you need to do this tutorial is a modern Webbrowser that is able to connect to the Lab environment.

## Connecting

As a first step we are trying to make sure you are able to connect to the console, that serves as a graphical user-interface for OpenShift.

We recommend you to keep this tutorial open in a browser tab, while opening a new tab with the console at the following URL [https://console-openshift-console.APPS_DOMAIN](https://console-openshift-console.APPS_DOMAIN).

When connecting, you will have to authenticate using the username you got handed out at the beginning of the labs.

Use this username and password to authenticate with the `IDP_NAME` identity provider. When being offerered to "Log in with" choose the `IDP_NAME` option and afterwards your username and password.

After login you are prompted by a short guide through the most important parts of the UI - we recommend you to quickly step through it.

## Getting familiar

Let's inspect the different views by trying to find answers for the following questions:

* What projects / namespaces are around?
* What is running in these namespaces?

To make things a bit more interesting, we have given you read access to the namespace, that hosts this tutorial.

* Can you tell us how many instances are running of the "handson-tutorial" app?
* Can you tell us how much CPU / memory it uses?
* Can you tell us who accesses the "handson-tutorial" app?

There is also a centralized UI for log inspection, which allows you give an aggregated view over the logs from that pod. Can you find it?

## Use the cli

All the operations within the webinterface are API calls to the standard Kubernetes API. OpenShift extends this API with a set of aditional APIs that provide OpenShift specific features. Such as Routes, Builds, etc.

You can talk to the API using the kubernetes native client `kubectl` or the OpenShift specific branded version of it, called `oc`.

To give you an easy way to access the cli, OpenShift ships with a built-in web-based Terminal, that allows you to directly execute commands against the API using your account.

You can start such a Terminal with on the `>_` Symbol in the top menu bar on the right hand side. When starting your terminal the first time, you have to choose a base namespace / project with write access to it, that will host the terminal application for you. We recommend to create an extra project for it called: `userXY-terminal`. Where XY is the number of your user. Over the whole tutorial we will reference with userXY to this, pay attention when entering / copying commands.

Now let's get familiar with the cli and once the terminal got launched, type:

     oc whoami

### Getting help

The oc cli features a help output, as well as more detailed help for each command:

     oc help
     oc projects -h
     oc projects

### Create a new project on the cli

Create a project called `userXY-cli` - Projects or also called namespaces (the Kubernetes representation) are a way to organize, administrate and compartinalize your resource within kubernetes.

You can get help by

     oc new-project -h

To create your new project you can do:

     oc new-project userXY-cli

We are immediately switched to our project:

     oc project

We can inspect our project by either describing it or getting a yaml (or json) formatted output of our created project.

     oc describe project userXY-cli
     oc get project userXY-webui -o yaml
     oc get project userXY-webui -o json

### Inspecting and editing other resources

Everything within Openshift (Kubernetes) is represented as a resource, which we can view and depending on our privileges edit.

You can get for example all pods of your current project, by typing:

     oc get pods

You can also get all pods in a different namespace:

     oc get pods -n handson-tutorial

It is also possible to describe resources to get a more readable format:

     oc project handson-tutorial
     oc describe buildconfig handson-tutorial

You can also edit them:

     oc edit resrourceXY resourceName

For example let's edit the buildconfig

     oc edit buildconfig handson-tutorial

This was only an example and you do not have write permissions to that resource anyway.

Do exit the editor by typing: *ESC* and *:* and *q*


### How are my resources doing?

You can always get an overview of your current resources by typing:

     oc status

This will become handy, once we start deploying more things.

## Deployment

Now let's deploy our own application. We recommend you to use the cli in the webterminal for the next steps.

First we need a project to deploy our application into:

     oc new-project userXY-app

We have prepared a little demo application that is easy to deploy:

     oc new-app -n userXY-app registry.access.redhat.com/ubi8/ruby-30:latest~https://github.com/duritong/ocp-handson-lab/ --context-dir=app/

This will create a new application as well as starts a build of the application. You can follow the build using:

     oc logs -f buildconfig/ocp-handson-lab

Once finished you can verify your new app, either in the topology view or through the following commands:

     oc get deployment
     oc get pods
     oc status

BUT what is your application doing? It serves some content, to make this content accessible, we can create a `Route`:

    oc create route edge --service=ocp-handson-lab --insecure-policy=Redirect

Once create you can get the hostname either via cli:

    oc describe route ocp-handson-lab

Or in the topology view in the webinterface where you now should have a link on your running application.

The application provides several URLs:

* / - the main entry point
* /lobster - inspect
* /health - just returning the healthiness of the application
* /metrics - some metrics

Inspect these URLs.

Can you also connect to a shell into the Pod of the deployed application? What is going on in there?

    oc rsh <pod name>

What else can you tell us about the deployed application by inspecting its resources?

## Self-Healing and scaling

An important feature of Kubernetes is that it tries really hard to keep your application running. Let's look into that a bit:

We can easily query all the pods from our application deployment:

    oc project userY-app
    oc get pods -l deployment=ocp-handson-lab

This filters all the pods with the label `deployment=ocp-handson-lab`.

We can also use this to delete the pods:

    oc delete pod -l deployment=ocp-handson-lab

Watch what is happening in the `Topology` view or re-query the current running pods:

    oc get pods -l deployment=ocp-handson-lab

Re-check the Pod Name when you visit the application.

Now we can also launch much more pods for our application, making it more re-silient to failure of individual instances, as well as to absorb more load:

    oc scale deployment/ocp-handson-lab --replicas=10

What happens to the pods? What happens in the topology view when you delete these pods?

### More fun

We can also do these things with a different mechanism that makes much more fun.

Let's play at [https://kubeinvaders.APPS_DOMAIN](https://kubeinvaders.APPS_DOMAIN)

## Configuring the Application

The application we deployed can return a different string than the current os-release file content. For that you can place a file in the container at `/config/content.txt` - This will be returned as part of the default webpage.

In kubernetes ConfigMaps are handy for that, this allows you to configure additional data through the Kubernetes API that is then injected into the container over different means.

First let's create a ConfigMap:

    cat >configmap.yaml<<EOF
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: file-content
    data:
      content.txt: Random Content
    EOF
    
    oc apply -n userXY-app -f configmap.yaml

Set Random Content to whatever you like to get.

No we need to edit the deployment to include configmap as a volume:

    oc edit -n userXY-app deployment ocp-handson-lab

Add the following sections:

    # after terminationMessagePolicy: File
            volumeMounts:
            - name: config
              mountPath: "/config"
              readOnly: true
    
    # after terminationGracePeriodSeconds
          volumes:
          - name: config
            configMap:
              name: file-content

Afterwards the trigger will automaticall restart the deployed application.

When changing the config map you need to restart the pod.

## Deployment Pipeline

To get an overview on how to delier applications on OpenShift using built-in pipeline capabilities, we recommend to follow the official [Pipelines Tutorial](https://github.com/openshift/pipelines-tutorial#deploy-sample-application)

# We are at the end!
