---
layout: post
title: What Is DevOps?
tags:
  - devops
  - alm
categories:
  - alm
date: 2016-11-18 2:14:00
excerpt: My personal definition of what is DevOps.
authorId: dylan_smith
---

I'm sure there's hundreds of posts out there trying to define DevOps, this is my $0.02 on the topic.

If you subscribe to the lean software development way of thinking, you think about a pipeline of value that results in working software.  For example this might be: Analysis -> Dev -> Test -> Deploy -> Monitor

As with any pipeline, there is likely a bottleneck somewhere that restricts the flow of value.  Lean is all about identifying and attacking these bottlenecks.  10 years ago - before Agile - the bottleneck was probably Analysis, or maybe Test.  With Agile development becoming mainstream over the last decade, it has done a pretty good job of attacking those bottlenecks, resulting in analysis and test becoming more just-in-time, spread out over the course of a project, and embedded in the regular dev workflows.  They are no longer the bottleneck.

A new bottleneck has arisen, that is at the boundary of the dev/test team and the operations team.  These tend to be very separate teams, with a clear handoff between them.  This results in friction, and a bottleneck in the flow of value.

So back to my definition of DevOps:

### DevOps is recognizing that a bottleneck exists between Development and Operations, and doing something to address it.

This bottleneck manifests itself in a number of ways, here's a few common ones:

	1. Provisioning / Managing Infrastructure - Creating environments for dev/test/uat/prod, and managing or making changes to those environments.
	2. Deployment to Production - Still often done by writing word documents with deployment instructions, scheduling a time for Operations team to do the deployment, then delivering the document and deployment packages to Operations.
	3. Production Support / Monitoring - Is the application available, are there errors, what is the load on the servers.

These are common causes of friction within development organizations.  I could go into details, but I expect just reading the points above you can identify with at least some of these concerns.

When I hear people talk about DevOps, I often hear 3 common approaches:

	1. Closer collaboration between the development and operations team.  Perhaps having an Ops team member actively involved with the dev team throughout the project.
	2. Increased Dev Team Responsibility - Writing automation scripts to provision / manage environments, deployment automation scripts, etc
	3. New Role: DevOps Engineer - Introducing a new role specifically to sit between dev and ops to facilitate the automation and collaboration.

Although #2 is the approach I see most often, I believe all 3 approaches are perfectly valid ways to attack the problem.

If you want help adopting DevOps practices or technologies, my company Imaginet is always happy to help.  Check out our DevOps offerings here: http://www.imaginet.com/devops-as-a-service/


