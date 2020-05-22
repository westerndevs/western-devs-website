---
layout: post
title: Kubernetes - My Journey - Part 2
category: kubernetes
tags: kubernetes, azure, **AKS**, identityserver, docker, containers
authorId: dave_white
date: 2020-04-16 10:00
---
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
    blockquote {
        position: relative;
        font-family: 'Cascadia Code PL', serif;
        padding-left: 1em;
        border-left: 0.2em solid #005da0;
        font-size: 1.1em;
        line-height: 1em;
        font-weight: 100;
        &:before, &:after {
            content: '\201C';
            color: #005da0;
        }
        &:after {
            content: '\201D';
        }
    }
</style>

[Series Table of Contents](/kubernetes/kubernetes-my-journey)

**Previously:**
[Business problems](/kubernetes/kubernetes-my-journey-part-1)

# Initial Assumptions, Technologies, Learning Resources

There are some assumptions that were made before my involvement with this company that made some of this decision making easy. Those assumptions were driven by the business problems we discussed previously.

Some of these decisions were made by me throughout this project. It was important for me to understand the organization's business, goals, and culture when making these decisions so they weren't as easy to make. The good thing is that I've got a great group of leaders and developers in this organization that helped me and trusted me to make better decisions on their behalf.

## Pre-defined Assumptions

So, there are a bunch of things that we're decided before me arriving on the scene! These decisions drove all my initial decision making to just get the project started.

### We're going to the cloud

I'm not sure this needs a lot of elaboration. Everyone is going to the cloud. Owning and operating data centres is hard. Companies like Microsoft, Amazon, and Google have commoditized hardware setup, management, and maintenance so much so that it almost doesn't makes sense to own your own data centre. So, anything I did should strive to be cloud-native.

#### Azure

Azure was chosen as the vendor for all our cloud services prior to my involvement. This certainly plays to my strength as a Microsoft-based technologist and an avid Azure user for all my own projects.

#### ASP.NET Core (C#)

This company is a Microsoft shop. All the developers are C# developers who are familiar with Microsoft technologies, so it only makes sense that we are going to leverage the existing people and skills that are present in the organization. Using .NET Core and ASP.NET Core 3+ in all projects going forward was made a requirement (and is probably simple common sense) by the assumption of moving to the cloud.

I couldn't build something that only I could maintain or would require the company to go and try to find new developers or acquire new skills in their current developers. There is going to be a lot of learning being done by everyone here, but we don't need to add to the pile of new stuff to learn.

#### HTTPS

One of the things that seems obvious, but turns out isn't always obvious, is the fact that in today's world, we should be using HTTPS everywhere. It has become easier and easier to do this, and part of this project's mandate was to ensure that we accelerated the adoption of HTTPS throughout the deployed platform and make it _easier to own and maintain_. Simply doing an Identity implementation will drive this.

## Decisions I made

During the planning of this project, I had the flexibility to make a lot of decisions. I didn't make them in isolation, but I did get to make the final decisions.

### Containers and Orchestration

Going to the cloud can be as simple as lift-and-shift. Pick up your server, virtualize it if necessary, and place it in the cloud. In some cases, we can make this even simpler by provisioning a VM with all the pre-installed parts we need and simply deploying our application into that new VM. This is certainly "going to the cloud" but it isn't considered _cloud-native_.

#### Docker

I'm not an expert on what _cloud-native_ entirely means, but I've discerned that one thing you need to do is containers. So today, that means **Docker**. Being a Microsoft shop, going to Azure, using Visual Studio and the az cli as tools, Docker was a no-brainer for a container engine with all the great tool support in Visual Studio, Azure DevOps Server, and the other tools, so I just rolled with it.

#### Kubernetes

When using Azure and running containers in the cloud, you have several options. Two easy ones are Azure Container Instances (server-less container hosting) and **Azure Kubernetes Services (aka AKS)**. Since our environment was going to be far more complicated than running a bunch of single containers in the cloud, we needed an orchestration platform. There are two options for that today: Kubernetes and DockerCompose and we chose Kubernetes. The community support for Kubernetes is incredible, the momentum it has in the marketplace can't be denied, and it is natively supported by Azure via the **AKS** product, so it was another easy decision.

### Cloud-Hosted

I sort of covered this one off, but there is an option to stand up your own Kubernetes cluster manually in Azure simply using Virtual Machines. **AKS** effectively took this option off the table. In my experience so far, **AKS** is a polished product, easy to use, and the control plane components are included for free. You simply pay for all the other Azure products that will make up your cluster. These include VMs, Storage, Networking, and any other products you leverage in your implementation.

#### Azure Kubernetes Service (**AKS**)

**AKS** also makes some of our *ability to scale* requirements much easier to address. You can scale vertically by dynamically increasing the size of the VMs in the cluster and we can scale horizontally by dynamically adding (or removing) nodes from the cluster.

### Identity Implementation

While this project has many objectives, they key objective for all this work was to deliver a new Identity management implementation to the platform that would enable a secure, modern way for all users, applications, and devices to authenticate with each other.

One of the underlying cultural desires at this client that I should state is a strong desire to minimize subscriptions and dependencies on 3rd party vendors. This desire precluded us from selecting any of the current Identity providers that exist on the marketplace today. AuthO and Okta are two such companies and while I'm sure they have great products, we
decided to build our own Identity system.

#### IdentityServer4

Now, we didn't want to build all the identity system from scratch! That doesn't make sense. We'd have to become experts in OAuth, OpenID Connect, flows, encryption, tokens, and all those technologies that are implemented by great communities out there already. This OSS frameworks are also scrutinized and vetted by the community, so you know that a lot of people care that they are done right. Basically, we wanted to take the best implementation of a security framework in the Microsoft open-source community, host it in our infrastructure, and be able to customize it to our specific use-cases. This led us to IdentityServer4, which is the core technical component of our Identity implementation.

#### Skoruba IdentityServer4 Admin 

One of the things about identity implementations is that there is a lot of configuration and user data to manage. To be honest, client configuration and user data is one of the biggest PITA about doing Identity work. Once you get it, it isn't so bad but so much of a successful roll-out with an identity platform hinges on getting all this data right. And to do that, it helps to have a good administrative platform.

While I'd love to have had the time to write an application that gives a good user experience for the administration of this data, I didn't have that time. So, I went looking for something in the community that used IdentityServer4 as a foundational component and added the user experience I wanted. And after several pilots, I found and selected Skoruba IdentityServer4 Admin. This is an ASP.NET Core 3.x web application that provides the Security Token Service (STS), and Administrative Application, and an Administrative API, all in one easy to use package! I've been really happy that I found it.

### Data Persistence

The Skoruba templates allows for the selection of one from three different built-in persistence providers via Entity Framework Core. SqlServer, MySql and Postgres.

#### Postgres

Postgres was the database provider the I selected. This reduced our licensing costs, provides the appropriate level of performance and functionality, and with us being in Azure, we always have the option of moving to **Azure Database for PostgreSQL** which has single instance SKU and an HA/Hyperscale SKU if that eventually becomes a needed capability. There is also a ton of community support around the product, which means libraries, documentation, and examples are plentiful.

### Logging

I cannot under-state how important logging is when developing, maintaining, and owning a multi-container environment, spread across multiple servers (nodes) that are hosted in the cloud. This isn't the first and hopefully won't be the last blog post to emphasize this point. The community building cloud-based applications already blogs about this, you've almost certainly read about it somewhere before here, but it still may not have sunk in that, perhaps, this needs to be the first thing you figure out in your new container-based platform. I paid some attention at the beginning, but not enough.

#### Seq - Log Ingestion and Analytics

When I first arrived at my client, they were still relying on file-based logging, spread over all the servers in the farm. They had a lot of logging in the application, but it wasn't easily accessible, and it wasn't easy at all to find out what happened across a workflow, sometimes broken, that traversed a bunch of servers.

The other thing that wasn't possible was querying and basic analytics of the log data that was being generated. It was inconsistent, unstructured, and just barely helping them solve problems.

At a previous engagement, I had used Splunk and really came to love it! The tool was great. Powerful queries, visualization, dashboard, alerts, integrations! Splunk has it all. There was only one problem. Splunk is expensive. That isn't a problem if your needs justify the spend and you have the required expertise in owning and operating Splunk, but that wasn't the case here, so I needed to find something easier to bring into the ecosystem. This was when I found Seq!

Seq is a great entry-level tool (that keeps on getting better) for organizations that are just getting started on getting logs into a central product and using that log data to analyze problems and operational aspects of the platform. Seq is built by Datalust.co, who also makes Serilog the .NET library that we use for logging internally in the application. This combination has turned out to be a cost-effective, easy to learn, setup and maintain logging infrastructure for our apps, so it was quite easy for me to bring this into the Identity project and the **Kubernetes (k8s)** infrastructure.

#### Fluentd

In addition to the identity applications that are in the **k8s** cluster that will be logging to Seq, the infrastructure applications in the cluster _itself_ will generate an incredible amount of information about its operations and problems. This is a non-trivial log ingestion problem that has been made very approachable with a product called **fluentd**. Built to live inside of **k8s** clusters, fluentd is basically an event processing pipeline implementation that takes events from log files that are written all over the **k8s** cluster. It takes care of finding the files, processing them as they get additional entries, and sending those events "somewhere". In this case, I used an fluentd docker image that emits logs to **graylog** consumers, which thankfully, Seq is with an addon. So, with Serilog in the applications, fluentd in the cluster using a graylog variant and Seq running in the cluster to ingest and aggregate all the log information, we have a very compact, useful logging strategy to get us started.

I don't know how far this logging implementation will grow with the cluster into the future, but it is designed to have pieces replaced as we outgrow their capabilities.

### Learning Resources

This adventure required an incredible amount of learning on my part. The way that I learn best is by reading/learning enough to get started, and then building like crazy, discovering deficiencies in what I know, resolving the deficiency, and then finding the next thing I don't know.

This series of blog posts will hopefully capture some of that learning experience, but I wanted to make sure I shared the places that I started.

#### Pluralsight

There are a lot of courses on Pluralsight. I think I've enjoyed all them, with some courses being better than others for me at that point in my learning. For this project, I didn't need any help with C# or ASP.NET Core or any of that part. I needed to get familiar with Kubernetes and I needed to become familiar with authentication flows using OAuth2 and OpenID Connect.

The **k8s** courses were from Nigel Poulton were great places to get started with **k8s**. The ones that I watched are:

- [Getting Started with Kubernetes](https://app.pluralsight.com/library/courses/getting-started-kubernetes/table-of-contents)
- [Docker and Kubernetes: The Big Picture](https://app.pluralsight.com/library/courses/docker-kubernetes-big-picture/table-of-contents)

When getting more details on OAuth2 and OpenId Connect, Kevin Dockx and Micah Silverman had two nice courses to review.

- [Securing ASP.NET Core 2 with OAuth2 and OpenID Connect](https://app.pluralsight.com/library/courses/securing-aspdotnet-core2-oauth2-openid-connect/table-of-contents)
- [THAT Conference '19: OAuth 2.0 and OpenID Connect (In Plain English)](https://app.pluralsight.com/library/courses/that-conference-2019-session-07/table-of-contents)

> There is a new version of Kevin Dockx course available using ASP.NET Core 3 [here](https://app.pluralsight.com/library/courses/securing-aspnet-core-3-oauth2-openid-connect/table-of-contents)

#### Kubernetes.io

Based on what and how I was learning **k8s** from Nigel on Pluralsight, Kubernetes.io became an invaluable resource for me to learn about **k8s** and its ecosystem. Nigel's courses encourage you to work with manifests, building your **k8s** cluster in a declarative manner, and kubernetes.io supported that approach well. I would highly recommend working with manifests and understanding them and how they work when learning **k8s**. We'll discover later that I don't work directly with manifests when provisioning my cluster resources, but you have to know manifests because all the examples in the communities are in manifests!

#### Community blogs

This would have been much harder without the incredibly vibrant community of bloggers in the world who are sharing what they are doing, the problems, and how they are solving those problems. I'm hoping that my addition in writing this blog fills a gap and makes it a bit easier for you or someone else to put this all together, but this would have been incredibly difficult without this vibrant community.

**Next up:**
[Tools in Use](/kubernetes/kubernetes-my-journey-part-3)

##### Links

- [Azure](https://azure.microsoft.com/en-us/)
- [Azure Kubernetes Services](https://azure.microsoft.com/en-us/-services/kubernetes-service/)
- [Kubernetes](https://www.kubernetes.io)
- [IdentityServer4](https://identityserver4.readthedocs.io/en/latest/)
- [Skoruba IdentityServe4 Administration](https://github.com/skoruba/IdentityServer4.Admin)
- [Pulumi](https://www.pulumi.com/)
- [Seq Log Ingestion](https://datalust.co/seq)
- [Fluentd](https://docs.fluentd.org/)
- [Postgres](https://www.postgresql.org/)
- [pgAdmin4](https://www.postgresql.org/)
- [CertManager](https://github.com/jetstack/cert-manager)
- [Nginx](https://www.nginx.com/)
- [Traefix](https://containo.us/traefik/)