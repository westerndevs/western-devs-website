---
layout: post
title: Kubernetes - My Journey - Part 6
category: kubernetes
tags: kubernetes, azure, aks, identityserver, docker, containers
authorId: dave_white
date: 2020-05-22 06:00
---
[Series Table of Contents](/kubernetes/kubernetes-my-journey)

**Previously:**
[Getting Started with Kubernetes - Minikube - Part B](/kubernetes/kubernetes-my-journey-part-5b)

# Pause to reflect

There was a point in this development effort that things started to click in my head, and I wanted to put this chapter in here as a more concrete reflection point and not leave it to luck that you'll have yours as well. I also wanted to share my epiphany(s) so this spot makes as good a place as any.

There were a bunch of things that clicked for me after moving this from docker to **k8s**.

## Kubernetes is not hard

Kubernetes, all by itself, is very approachable with the tools and the self-guided training I started. With **minikube**, [kubernetes.io](https://www.kubernetes.io), and [Pluralsight](https://www.pluralsight.com), I was able to stand-up a cluster and just do simple things like put resources into the cluster! Sure there are some things that turned out to be a bit of a pain in the butt that we'll discuss later on, but Kubernetes itself isn't hard.

## Getting a running system in Kubernetes IS hard

So, as easy as kubernetes was, getting an actual working business solution running in kubernetes was much harder! This exercise has really adjusted my perspective about the scope of DevOps and it has adjusted my perspective of what "full-stack" could really mean. Let's step back for a second and look at what I had to create and stand-up in my **k8s** cluster for things to work.

- a database (Postgres)
  - needs Postgres-specific configuration
  - needs networking configuration
  - needs persistent volumes
  - needs secrets
- a database administration application (pgAdmin4)
  - needs pgAdmin-specific configuration
  - needs networking configuration
  - needs persistent volumes
  - needs secrets
- log ingestion (Seq)
  - needs Seq-specific configuration (minimal)
  - needs networking configuration
  - needs persistent volumes
- raw log consumption (fluentd/graylog/sqelf)
  - needs fluentd-specific configuration
  - needs rule pipelines designed
  - needs networking configuration
- the identityserver4 group (STS, Admin, AdminAPI)
  - build the applications (ASP.NET Core, Web Apps, etc)
  - OAuth2, OpenID Connect is all about configuration!
  - needs networking configuration
- Ingress Controller (nginx and/or traefik)
  - needs nginx-specific configuration
  - needs traefik-specific configuration
  - Azure-specific annotations
- DNS rules (CoreDNS)
  - forwarding and rewrite rule configuration
- certificate management (CertManager)

The interesting thing about all of these applications is that they are all **completely independent** pieces of software/products that you need to become proficient, if not an expert, in configuring, running, and maintaining. Kubernetes makes it pretty easy to put all of these things in the cluster. Making it all work, in a manner than you can own and operate in an enterprise production setting, is non-trivial and I'll just come out and say it, Hard!

I don't want it to be a doom and gloom story though. There is a light at the end of the tunnel. These are modern pieces of software that are really good to work with. But you still should plan to work with them if you are doing this yourself. If you are on a bigger team with lots of support, then make sure you delegate tasks to those with skills and or experience to get that part of it done. Then automate it, and share the knowledge you've learned.

## Getting it running in the cloud is not bad

The good thing about getting it working in the cloud is, your probably going to focus on one cloud. Could you get it working in multiple clouds? You bet! The **k8s** resources are all the same, it would just be the cloud provisioning application(s) that would be different. Getting to be really familiar with what services your cloud provider offers and how to use those services will be key. But, again, you will need to be very proficient if not an expert in your cloud providers services to own and operate your **k8s** cluster in the cloud.

The Azure services that we are using and need to understand are:

- Azure Kubernetes Service
- Public IP Address
- Load Balancer
- Azure Storage Accounts
  - azureFile
  - azureDisk
- Virtual Network
- Virutal Machine Scale Set
- Route Table
- Network Security Group

Thankfully, programmatically approaching my infrastructure with [Pulumi](https://www.pulumi.com) has made this much easier, especially with intellisense support, so don't worry about this too much. I'll show you what I did shortly.

## You do not need to master ALL runtime environments

One thing I discovered quickly is I don't need to keep my web applications running in:

1. Windows Native - IIS
1. Kestrel
1. Docker
1. **AKS**

Trying to do this will lead to a lot of work that just isn't going to be needed. It is potentially a valuable learning experience so I'm not saying _don't_ do it, but once you decide on your runtime environment(s), do what is best to make sure it is configured and runnable there.

In this case, I felt I did want to keep it running in Docker for the local developer debugging experience. But my primary runtime target was going to be **AKS** so I didn't spend any time keeping this running in Kestrel or IIS via Visual Studio from a configuration perspective, and Docker did not get the full-fidelity experience that eventually **AKS** did. I do keep the DockerCompose experience working so I can debug the IdentityServer4 applications on my local machine.

## Cluster Logging from the Start

When I started this, I already knew I wanted to do logging in my applications, but I really didn't think about logging across the cluster. I knew it happened and I did solve some problems by looking at the logs in various pods, I should have explored and found **fluentd** sooner in my journey. Logs are so important in this environment because we have many applications and kubernetes itself spread across multiple nodes and who knows how many pods.

## IaC and Automation are Awesome

I am really glad that I started down the path of **Infrastructure as Code** right from the very start of the **AKS** journey, and I'm going to get my **Pulumi** IaC applications running against minikube as well. Being able to capture what you've learned about your infrastructure as application code is a fantastic benefit, in addition to the actual automation that you can invoke with a couple key strokes, the push of a button, or a commit/push. If I was going to give myself some advice, I'd tell myself I should really make sure I pay attention to the next post in the series.

## Be Prepared to need a LOT of Permissions

At the beginning of your project, if you aren't in full control of the whole ecosystem, you should start the process of getting the required permissions. This whole series generally assumes you have full-control when we start working on the **AKS** components, but you'll also need access to DNS registrations, and you may need permissions to acquire and use some of the tooling.

## Summary

This was intended to be a brief stop. A chance to pause, catch your breath, and reflect on what you might of learned based on what I did learn. Don't be discouraged if all of this is hard or tricky or taking longer than you expected. This has been an incredible amount of learning if you started from scratch like me with **k8s** and you should be proud of where you've gotten too.

**Next up:**
[Moving to Azure Kubernetes Service - Part A](/kubernetes/kubernetes-my-journey-part-7a)

<style>
    h1, h2, h3, h4, h5, h6 {
       margin-top: 25px;
    }
    figure.highlight{
        background-color: #E8EEFE;
    }
    figure.highlight .gutter{
        color: #0033CD;
    }
    figure.highlight pre {
        font-family: 'Cascadia Code PL', monospace;
    }
    code {
        font-family: 'Cascadia Code PL', sans-serif;
        border-width: 0.1em;
        border-color: #E8EEFE;
        border-style: solid;
        border-radius: 0.3em;
        background-color: #E8EEFE;
        color: #0033CD;
        padding: 0em 0.4em;
        white-space: nowrap;
    }
</style>
<link  href="https://cdnjs.cloudflare.com/ajax/libs/viewerjs/1.5.0/viewer.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/viewerjs/1.5.0/viewer.min.js"></script>
<script>
// View an image
const gallery = new Viewer(document.getElementById('mainPostContent', {
    "navbar": false,
    "toolbar": false
}));
</script>