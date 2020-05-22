---
layout: post
title: Kubernetes - My Journey - Part 1
category: kubernetes
tags: kubernetes, azure, aks, identityserver, docker, containers
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

# The Business Problem

My client has been in business since 1993. As you can imagine, software has been an integral part of their ability to deliver services to their customers. About 10 years ago, they had a re-platforming initiative that was the start of their current monolithic, critical LOB system. It is an ASP.NET MVC 5.x application that has evolved over time and is certainly reaching the limits of what its architecture can provide. It isn't "cloud-native" and it basically continues to be enhanced/evolved based on assumptions that were made 10 years ago.

For this project, the important part to understand is that it used forms authentication and has a user store internally that manages all of the user accounts and authorization rules. It currently only uses cookies to store authenticated user details on the client and doesn't support any modern sort of token-based activities that are needed for modern applications.

It is also important to understand that the platform is growing as users and customers demand more modern and specific user experiences. New web applications (React), mobile devices (native), IoT devices, and system-to-system integrations are all being added to the platform and all these new applications need to participate in the authentication scheme. In some cases, new applications have been created but because the current LOB system doesn't support modern authentication techniques, they cloned the existing user store and used the data to implement the appropriate authentication techniques for their specific use case. This has led to a bunch of applications re-implementing their own authentication, with everyone sharing the user store (or a copy of it) of the core LOB system.

So, the current system has demonstrated a few key problems that the new system needs to address.

### Security is hard and incredibly important

One of the plagues of modern business is bad actors attacking various systems trying to gain access and cause lots of troubles. This is an ever-present problem for most corporations. Security needs to be a first-class citizen in all projects. Using modern authentication platforms that are proven and community-reviewed is seen as a requirement.

Speaking of security, in this series, you will find a lot of usernames, passwords, and internal details about the systems that is being built. I would ask that you **please take a great deal of care when building your systems!** I'm not worried about presenting these details as I'm tearing all of this down all the time and it won't be left running on my Azure accounts. I will change passwords, usernames, and all kinds of other details to make it harder for anyone to break into a running system. I strongly encourage you to do the same.

### Decentralized identity management sucks

The platform is currently a monolithic LOB system that provides **all** functional aspects for the various business groups. The platform is also growing a collection of loosely related applications that basically represent specific implementations that are tailored for each individual area of the business. All the systems are re-implementing authentication while using, in most cases, a copy of the LOB user store. This basically means that we have multiple user stores that all must be managed independently. There are SSIS workflows trying to keep the right data in sync while not clobbering specific customizations to the user store data.

This is all complicated, complex, and error prone. We generally don't have a lot of troubles with authentication, but it is expensive and time-consuming to setup and maintain and as new applications are added, it adds more things to manage and has more things that can go wrong.

### New applications require modern Identity technologies

In 2020, business that used to be well-served by a monolithic web application, are finding that this is no longer the case. Native applications, new web applications based on new technologies (SPA), IoT devices and System-to-System integrations all require more modern authentication technologies and these applications are being added to platform ecosystems at an increasing pace.

### Reduce the costs of running applications

One of the overall initiatives for this client is to become more cloud-native and reduce the running costs of applications. There is already an initiative to move all the platform servers to Azure, but we didn't want any new applications continuing the pattern of "lift and shift" used for the existing apps. There is a strong desire to leverage containers (docker) and orchestrators (Kubernetes) at an increasing rate for all the applications in order to reduce overall run costs.

### Being able to scale up is important

As with all businesses, we expect growth. My client is heavily reliant on devices for their current business needs and will be adding customers, native apps, and IoT devices at an ever-increasing rate. This means that having the ability to scale vertically or horizontally needs to be present from the start. Growth was anticipated (pre-COVID19) to be > 30% year over year for the next 3-5 years so there were going to be lots of people and devices needing to use the system in the future.

## Summary (TL;DR;)

Security is hard! De-centralized (read: many) authentication systems are expensive. Old Application are ... well... old! Modern applications need support! Moving to the cloud is happening! And businesses grow!!

I hope that this gives some context that helps you understand some of the decisions that I'll be sharing in the next section!

**Next up:**
[Initial Assumptions, Technologies, Learning resources](/kubernetes/kubernetes-my-journey-part-2)