# OpenShift Hands on Lab

This tutorial gives you a basic overview on OpenShift and guides you through the various features.

The idea is to go through the tutorial from the beginning to the end.

## Requirements

All you need to do this tutorial is a modern Webbrowser that is able to connect to the Lab environment.

## Connecting

As a first step we are trying to make sure you are able to connect to the console, that serves as a graphical user-interface for OpenShift.

We recommend you to keep this tutorial open in a browser tab, while opening a new tab with the console at the following URL [https://console-openshift-console.APPS_DOMAIN](https://console-openshift-console.APPS_DOMAIN).

When connecting, you will have to authenticate using the username you got handed out at the beginning of the labs.

Use this username and password to authenticate with the `IDP_NAME` identity provider. When being offerered to "Log in with" choose the `HtPasswd-demo` option and afterwards your username and password.

After login you are prompted by a short guide through the most important parts of the UI - we recommend you to quickly step through it.

## Getting familiar

Let's inspect the different views by trying to find answers for the following questions:

* What projects / namespaces are around?
* What is running in these namespaces?

* Can you tell us how many instances are running of the handson tutorial app?
* Can you tell us how much CPU / memory it uses?
* Can you tell us who accesses the handson tutorial app?

There is also a centralized UI for log inspection, which allows you give an aggregated view over the logs from that pod. Can you find it?

## Deployment
