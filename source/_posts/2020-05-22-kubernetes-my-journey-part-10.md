---
layout: post
title: Kubernetes - My Journey - Part 10
category: kubernetes
tags: kubernetes, azure, aks, identityserver, docker, containers
authorId: dave_white
date: 2020-05-22 01:00
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
</style>
<link  href="https://cdnjs.cloudflare.com/ajax/libs/viewerjs/1.5.0/viewer.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/viewerjs/1.5.0/viewer.min.js"></script>

[Series Table of Contents](/kubernetes/kubernetes-my-journey)

**Previously:**
[Adding kubernetes logging (fluentd)](/kubernetes/kubernetes-my-journey-part-9)

# Tuning resource usage

We now have a full-functional cluster, producing metrics, logging, running applications, the whole ball of wax! We are now in the place where we can start to tune the performance characteristics of our cluster.

I have just started down this path myself, and as such, I don't have a lot of experience with the current cluster as it is running. It is just being rolled out into production now and so over the next days, weeks, and months, we will be learning how to monitor the performance of the cluster and making adjustments to the CPU and Memory requests that we can define in our pods.

I will be adding to this article as I learn but I also wanted a place to publicly share some links that I find and like.

## Basic Resource Requests

Going back one chapter to the **fluentd** pulumi declarations, we can see that in the **DaemonSet** resource, we are describing requests and limits for our pod resources.

```typescript
resources: {
    requests: {
        cpu: "200m",
        memory: "0.5Gi"
    },
    limits: {
        cpu: "1000m",
        memory: "1Gi"
    }
},
```

You can use these requests and limits in any pod **spec** and you can make adjustments as you learn. Just a reminder, pods are intended to be ephemeral and any changes will cause pods to go be deleted and new replacements are created. You can make changes in your pulumi application, do a quick `pulumi up` and see the difference in node resource consumption nearly immediately.

### Monitoring Resource Usage

It's important to remember that pods use node resources, so if you are going to monitor resources, they would be at the cluster/node level and not any particular application or namespace.

Using Octant, we can navigate to a node to get a sense of how it is doing.

<img id="image" src="/images/dwhite/cluster-node-resources.png" alt="Cluster Node Resources" height="250px">

On the same node details page, we can find a section called **Conditions** where **k8s** is telling you how it feels about the current resources available vs. allocated. I don't have any ideas or guidance yet on what these ratios should be yet.

<img id="image" src="/images/dwhite/cluster-node-conditions.png" alt="Cluster Node Conditions" height="150px">

I've actually found that I really like the Kubernetes Dashboard WebUI is a great place to also look at resource utilizations and configurations.

<img id="image" src="/images/dwhite/cluster-node-resources-webui.png" alt="WebUI Cluster Node Resources" height="250px">

Clicking into a single node gives details about Conditions on that node.

<img id="image" src="/images/dwhite/cluster-node-conditions-webui.png" alt="WebUI Cluster Node Conditions" height="250px">

## Summary

As mentioned, this is certainly a work in progress. As we monitor the cluster and how it behaves, we'll make adjustments. I'm certain we'll also make adjustments as to how we monitor. I expect at least one [prometheus](https://prometheus.io/) article in the near future, so I'll just leave the **Next Up** link space at the bottom of the article as TBD. :D

## Links to Articles

- [Kubernetes Managing Resources](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Making Sense of Kubernetes Cluster Metrics](https://www.replex.io/blog/kubernetes-in-production-the-ultimate-guide-to-monitoring-resource-metrics)

**Next up:**

TBD

<div style="width:100%;height:0;padding-bottom:42%;position:relative;"><iframe src="https://giphy.com/embed/xUPGcdeU3wvdNPa1Py" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div>

<script>
// View an image
const gallery = new Viewer(document.getElementById('mainPostContent', {
    "navbar": false,
    "toolbar": false
}));
</script>