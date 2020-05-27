---
layout: post
title: Kubernetes - My Journey
authorId: dave_white
category: kubernetes
tags: kubernetes, azure, aks, identityserver, docker, containers
date: 2020-05-22 13:00
---
# The Journey

This is a series of articles chronicling my learning journey as I was asked to build an IdentityServer4-based authentication system for one of my clients. This story included details about my adoption of Kubernetes, Azure Kubernetes Service, and all the things that I had to do to stand-up this client's new IdentityServer4 authentication implementation.

As with most learning experiences, I've made mistakes, arrived at working applications, adjusted my implementations, and continued to grow. My hope is that this series will continue to grow and evolve and be a bit of a living series of documents. I'll actively change articles when I discover something new or a better way to describe things. I'll add new articles or maybe alternate paths through the series as new topics present themselves. And I'm certainly not an authority on all of these topics, so as I get feedback from friends and peers, I'll certainly be making adjustments.

I have two primary goals with this series. Documenting the learning journey is the first one, but the second and almost as important goal was to provide someone (you) with a complete set of steps to get a Kubernetes cluster up and running with an IdentityServer4 implementation running inside of it. Once someone has this platform up and running, they can continue to learn and grow in the same manner that I will but hopefully they're path getting to this point was a little smoother than mine was.

As always, comments and feedback are encouraged and very welcome.

Now, on to the articles!

## Series Table of Contents

  1. [Business problems](/kubernetes/kubernetes-my-journey-part-1)
  2. [Initial Assumptions, Technologies, Learning resources](/kubernetes/bernetes-my-journey-part-2)
  3. [Tools in Use](/kubernetes/kubernetes-my-journey-part-3)
  4. [Building an ASP.NET Core IdentityServer Implementation](/kubernetes/bernetes-my-journey-part-4)
  5. Getting Started with Kubernetes - Minikube
      - [Part A - Getting Started with Kubernetes - Minikube](/kubernetes/bernetes-my-journey-part-5a)
      - [Part B - Getting Started with Kubernetes - Minikube](/kubernetes/bernetes-my-journey-part-5b)
  6. [Pause to reflect](/kubernetes/kubernetes-my-journey-part-6)
  7. Movine to Azure Kubernetes Service
       - [Part A - Moving to Azure Kubernetes Service](/kubernetes/bernetes-my-journey-part-7a)
       - [Part B - Moving to Azure Kubernetes Service](/kubernetes/bernetes-my-journey-part-7b)
  8. [Making Your Kubernetes Cluster Publicly Accessible](/kubernetes/bernetes-my-journey-part-8)
  9. [Adding Cluster Logging (fluentd)](/kubernetes/kubernetes-my-journey-part-9)
  10. [Tuning resource usage](/kubernetes/kubernetes-my-journey-part-10)

## Approach to this series

I've decided to break this series into discrete posts to make this easier to write and consume. I'll have specific topics for a post that are aligned with the overall vision, and you'll be able to read the parts that are important to you.

This series is going to strive to demonstrate work that is completely done. Every bit of code in each post should work and be complete. I'll point out bits of knowledge and wisdom I've learned along the way, but the intention is to give you a working system that you can then alter/re-create and learn from that experience.

All the code, projects, manifests, etc. are (or will be) in [Github here](https://github.com/agileramblings/my-kubernetes-journey).

**Enjoy**

**Next up:**
[Business problems](/kubernetes/kubernetes-my-journey-part-1)
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
