---
layout: post
title: Kubernetes - My Journey - Part 3
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

**Previously:**
[Initial Assumptions, Technologies, Learning resources](/kubernetes/kubernetes-my-journey-part-2)

# Tools in Use

Tooling is an incredibly important aspect of a developer's daily life. IDEs, CLIs, Automations, Visualizations; the list goes on and on. Sifting through the set of tools that are available and finding out if they work for you can take a lot of time. As a former Microsoft MVP (Dev Tools), I'm always interested in tooling because I know the importance it can make in developer productivity and the overall productivity and quality for an organization! I'm hoping that by sharing my base set of tools, and what I use them for, you'll get a bit of tool-curation time savings back to spend on learning other things.

These are the tools I use **every day** on this project.

## Visual Studio

| | |
|------------------------------------|:--:|
|[Visual Studio](https://visualstudio.microsoft.com/vs/) has come a long, long way since the first time I ever used is as Microsoft Visual Studio 97 (5.x). Wow! This IDE has been my constant companion for the entirety of my development career, and I have to say that the current VS 2019 version of the tool is a pleasure to work with. Given the complex nature of building projects and supporting all of the ecosystems that we build projects for, VS 2019 does a fantastic job of supporting _my_ needs.|<img width="200px" src="https://s3.amazonaws.com/neowin/news/images/uploaded/2017/02/1486663278_visual-studio-97.jpg" alt="Visual Studio 97">|

With this project, I obviously appreciate all of the normal C# coding functions that are present, but the docker/docker-compose support is particularly important and the ability to debug applications running in docker containers is great.

I still have [ReSharper](https://www.jetbrains.com/resharper/) and I still have many extensions (Thanks [Mads](https://marketplace.visualstudio.com/publishers/MadsKristensen)!) running in Visual Studio, but this IDE is the workhorse of my day-to-day activities when I'm working in C#.

> I don't recommend that you download and try to use Microsoft Visual Studio 97!

## VS Code

[Visual Studio Code](https://code.visualstudio.com/) is a fantastic, light-weight text editor with an incredible extensibility feature that the community has taken full advantage of! Out of the box, it is very good at one thing. Editing text files. With all the extensions being written and placed on the marketplace, it has become some people's full-time IDE. The create thing about VS Code is that it runs on macOS, Linux, and Windows, so you take it wherever you go! And, it's free! It has mostly replaced all my other text editors, with the exception of **Notepad**. Still use that one from time to time.

I use VS Code for editing all my manifests, **Pulumi** Typescript applications, and markdown files for documentation. This blog post was written in Markdown using VS Code! With an integrated terminal window using PS Core, I can do pretty much all my **k8s** deployment and resource work without leaving VS Code.

## Pulumi

I've mentioned that while I find manifests a great way to learn **k8s**, I've adopted a different approach for deploying **k8s**. That approach is from a company called [Pulumi](https://www.pulumi.com/)! What they've basically done is built a platform and multiple SDKs in various languages that allow us to do **Infrastructure as Code** in a programming language of our choice!! It's a great way to define and manage your cloud resources. Once you have written your application that knows what you want to do, you simply tell the **pulumi cli** to `up` or `destroy` your infrastructure! `pulumi up` and it will create or update your infrastructure resources as needed, and `pulumi destroy` tears it all down and cleans everything up!

## Git

[Git](https://git-scm.com/) is the most popular and arguably the defacto source control system in the world today. All my manifests and pulumi typescript files are version controlled in git, as are all the Identity application projects that we'll be building later on.

## Azure DevOps Services (Server 2019)

[Azure DevOps (Server)](https://azure.microsoft.com/en-ca/services/devops/) is our DevOps management software. Source control (Git and TFVC), Work Item Management, Builds, and Deployments are all provided by this service. It provides us a tremendous amount of automation, and it gives us a place to make our knowledge about how to build and deploy our applications concrete! If you haven't tried Azure DevOps recently, you really should give it another go. It's been a tremendously valuable addition to the development process.

## Kubernetes Web UI (Dashboard)

[Kubernetes Web UI (Dashboard)](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/) is a great dashboard that is built into your **k8s** cluster that provides a User experience to help you visualize and manage your **k8s** cluster.

## Octant

[Octant](https://octant.dev/) is a dashboard for your **k8s** cluster, similar to the Kubernetes Dashboard, but it doesn't require you to port-forward to your local machine to get at the dashboard, it simply runs on your local development machine and uses the kubectl current context to access the cluster! This makes is quite easy to spin up. It provides port-forwarding capabilities in addition to many of the capabilities present in the Kubernetes Web UI. I find myself using them both quite often throughout the day.

## K9s

[K9s](https://k9scli.io/) is a console-based user experience for managing your **k8s** cluster! As with Octant, it uses kubectl and your current context to determine which **k8s** cluster it is managing. I quite like it! I also find it really interesting how I have three different tools for managing the **k8s** cluster and depending on what I'm doing or even my mode, I can pick from any of the three tools.

## Honorable Mention - Docker Desktop for Windows

[Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows) is the easiest way to get docker containers running on a windows desktop. You need a CPU that supports virtualization and you have to have Windows 10 Pro for the HyperV/WSL2 support. There are other options if you aren't running Windows 10 Pro and up, but I'll leave that as an exercise for you to figure out. But during initial development of the Skoruba project, it was immensely helpful to be able to build, deploy, and debug the application without having to deal with **k8s** or **minikube**. There are additional complexities involved with that that you will want to defer for a while.

**Next up:**
[Building an ASP.NET Core IdentityServer Implementation](/kubernetes/kubernetes-my-journey-part-4)

### Links

- [Visual Studio](https://visualstudio.microsoft.com/)
- [VS Code](https://code.visualstudio.com/)
- [Pulumi](https://www.pulumi.com/)
- [Git] (https://git-scm.com/) - [Github](https://www.github.com) - [Git Simulator - Github](http://git-school.github.io/visualizing-git/)
- [Azure DevOps (Server)](https://azure.microsoft.com/en-ca/services/devops/)
- [Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
- [Octant](https://octant.dev/) - [Github](https://github.com/vmware-tanzu/octant)
- [K9s](https://k9scli.io/) - [Github](https://github.com/derailed/k9s)
- [Useful Interactive Terminal And Graphical UI Tools For Kubernetes - Virtually Ghetto](https://www.virtuallyghetto.com/2020/04/useful-interactive-terminal-and-graphical-ui-tools-for-kubernetes.html)