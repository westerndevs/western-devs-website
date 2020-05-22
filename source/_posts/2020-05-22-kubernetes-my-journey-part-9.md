---
layout: post
title: Kubernetes - My Journey - Part 9
category: kubernetes
tags: kubernetes, azure, aks, identityserver, docker, containers
authorId: dave_white
date: 2020-05-22 02:00
---
[Series Table of Contents](/kubernetes/kubernetes-my-journey)

**Previously:**
[Making Your Kubernetes Cluster Publicly Accessible](/kubernetes/kubernetes-my-journey-part-8)

# Adding kubernetes logging (fluentd)

In this article, we are going to add some logging infrastructure to our **k8s** cluster to address the problems I had when an application doesn't log directly to the log ingestion platform I was using. (Seq).

This article is mostly Pulumi application code with a bit of an origin story, but to be honest, I haven't fully refined my understanding of **fluentd** for the article to be much more. I will add to and refine this article as I refine my **fluentd** implementation. This article will get your whole-cluster logging working though.

## fluentd

As I mentioned before, [fluentd](https://www.fluentd.org/) is one of several **k8s** log ingestion solutions that is out there right now. It has a lot of community support, so it was really easy to get started with it.

### Service Account and Roles

In order to get **fluentd** running in the cluster, there are a bunch of resources that need to be in place. Because **fluentd** _needs_ access to _all_ of the pods in the cluster to get at their logs, it needs a fairly empowered service account but we also want to make sure that service account only has the minimum amount of permissions as required to do it's job.

```typescript
// Fluentd Service Account and Role creation
const fluentdServiceAccount = new k8s.core.v1.ServiceAccount("fluentd-serviceaccount", {
    metadata: {name: "fluentd-serviceaccount", namespace: "kube-system"}
}, {provider: k8sProvider});

const fluentdClusterRole = new k8s.rbac.v1beta1.ClusterRole("fluentd-clusterrole",{
    metadata: {
        name: "fluentd-clusterrole",
        namespace: "kube-system"
    },
    rules: [{apiGroups: [""], resources: ["pods", "namespaces"], verbs: ["get", "list", "watch"]}]
}, {provider: k8sProvider});

const fluentdClusterRoleBinding = new k8s.rbac.v1beta1.ClusterRoleBinding("fluentd-clusterrolebinding", {
    metadata:{
        name: "fluentd-clusterrolebinding",
        namespace: "kube-system"
    },
    roleRef: {kind: "ClusterRole", name:"fluentd-clusterrole",apiGroup:"rbac.authorization.k8s.io" },
    subjects: [{kind: "ServiceAccount", name:"fluentd-serviceaccount", namespace: "kube-system"}]
}, {provider: k8sProvider})
```

### fluentd Pods

We now have a properly configured service account to use with our **fluentd** pods. Remember, **fluentd** is just another application running in the cluster performing its duties. And applications run in pods/containers.

In this section, we are going to see code that creates our first [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) set of resources in the cluster. A DaemonSet is similar to a Deployment with the primary difference being that a DaemonSet is used when you want to make sure there is one pod, that is described in the DaemonSet spec, on each node in the cluster. As nodes are added, the DaemonSet will ensure that the pods in its spec are automatically added.

**fluentd** is an application that is running on the node basically scraping log files. All of the log files are stored in the node file system, so in order to get all of the logs, we have to have a **fluentd** instance per now. DaemonSets are how we do that in **k8s**.

```typescript
const gldsLabels = { "k8s-app": "fluentd-logging", version: "v1"};
const fluentdGraylogDaemonSet = new k8s.apps.v1.DaemonSet("fluentd-graylog-daemonset", {
    metadata: { name: "fluentd-graylog-daemonset",
    namespace: "kube-system",
    labels: gldsLabels },
    spec: {
        selector: {
            matchLabels: gldsLabels
        },
        updateStrategy: {type: "RollingUpdate" },
        template: {
            metadata: { labels: gldsLabels },
            spec: {
                serviceAccount: "fluentd-serviceaccount",
                serviceAccountName: "fluentd-serviceaccount",
                containers: [
                    {
                        name: "fluentd",
                        image: "fluent/fluentd-kubernetes-daemonset:v1-debian-graylog",
                        imagePullPolicy: "IfNotPresent",
                        env: [
                            {name: "FLUENT_GRAYLOG_HOST", value: "seq-svc.default.svc.cluster.local"},
                            {name: "FLUENT_GRAYLOG_PORT", value: "12201"}
                        ],
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
                        volumeMounts :[
                            {name: "varlog", mountPath: "/var/log"},
                            {name: "varlibdockercontainers", mountPath: "/var/lib/docker/containers", readOnly: true}
                        ],
                    }
                ],
                terminationGracePeriodSeconds: 30,
                volumes: [
                    {name: "config-volume", configMap: { name: "fluentd-conf"}},
                    {name: "varlog", hostPath: {path: "/var/log"}},
                    {name: "varlibdockercontainers", hostPath: {path: "/var/lib/docker/containers"}}
                ]
            }

        }
    }
}, {provider: k8sProvider});
```

There is a bunch of configurations in here that are standard, but there are two things that are unique to this Pulumi application.

The first unique item is the **flavour** of fluentd that we are using. There are [numerous container images](https://github.com/fluent/fluentd-kubernetes-daemonset/tree/master/docker-image/v1.3) that are available from fluentd's repository and I was really fortunate to find the graylog-flavoured image. This image creates containers that natively talk using the graylog logging format.

`fluent/fluentd-kubernetes-daemonset:v1-debian-graylog`

The second unique item is a derivative of the first. Because we are using graylog, we need to give the **fluentd** pod some environmental configuration telling it where to send the logs to. In this case, we will be sending them to `sqelf` which will in turn send them directly into `Seq`. We can finally see this pair of containers in action in the Seq-dep pod.

```typescript
env: [
    {name: "FLUENT_GRAYLOG_HOST", value: "seq-svc.default.svc.cluster.local"},
    {name: "FLUENT_GRAYLOG_PORT", value: "12201"}
],
```

You should notice that we've used the FQDN of the seq-svc because the **fluentd** application is not in the same namespace in the **k8s** cluster as Seq/sqelf.

### Next Steps for fluentd

That is most of what I've done so far with **fluentd**. I've got it working, and the local Seq instance is ingesting a lot of log entries. This is ok because this is all in the same cluster, so network traffic isn't a concern I am currently worried about. It is something I'm more aware of because the Seq logs are **full** of log entries and it makes it a bit harder to find what I'm looking for.

**fluentd** has an approach to describe the **pipeline** that all log entries flow through. This is the kubernetes.conf file and you can replace the default configuration with one in a ConfigMap. This yaml resource file is an example:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluentd-conf
  namespace: kube-system
data:
  kubernetes.conf: "<match kubernetes.**>\r\n  @type null\r\n</match>\r\n<match fluent.**>\r\n
    \ @type null\r\n</match>\r\n<match **>\r\n  @type stdout\r\n</match>\r\n"
```

And the **fluentd** pod is configured to use this ConfigMap here in the **volumes** section of the Pulumi declaration:

```typescript
{name: "config-volume", configMap: { name: "fluentd-conf"}},
```

My next learning steps are refining this pipeline so that I can better manage how much data is flowing to `sqelf` and `Seq`. 

Another thing I need to get a handle on is doing ConfigMap declarations in Pulumi. Currently, a YAML ConfigMap examples is a PITA to convert to a Pulumi declaration. That will be another chapter, eventually, in this series. I've also asked Pulumi to start providing better examples of ConfigMaps in their documentation. A recipe book for many common YAML ConfigMaps would be great.

**Next up:**
[Tuning resource usage](/kubernetes/kubernetes-my-journey-part-10)

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