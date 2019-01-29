---
title: Ansible for project configuration
author: Jah
type: post
date: 2019-01-29T19:04:23+00:00
categories:
  - Tech

---

I'm a big fan of ansible as devops tools to configure machines. I use it for server, nas, router and personal computer but also to manage clusters.

Right now I'm working on a new project which uses ansible in a different ways: it will not configure machines but projects.
Using more and more external services for repository, CI/CD, etc... it was getting out of control to manage so many projects or to create new ones. Ansible has a lot of modules to manage API call but can also make direct call and parse responses so it can help.

The idea is to have projects in your inventory and to use groups the same ways as for machine.
The only change is every action will be delegate_to localhost because there is no machine to connect to. The second thing to consider is parallelism as it can be an issue depending on API restriction against flood of request: if you have too many projects, the serial option will do the trick.

At the end, the purpose is the same for machine: make configuration automatic and have it written as a code to avoid error or oversight. The second benefit of having all defined in an inventory is the ability to make operation like migration easier.

The list of things to configure for projects can be long, it just depends on API call available for yours services. I use it for:

* configure CI environment variables
* define cross services webhook
* setup cluster credentials
* create new project on CI platform
* templating recurrent file as Makefile, Dockerfile, etc...
* fetch latest releases of dependencies

