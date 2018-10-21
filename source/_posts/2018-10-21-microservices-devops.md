layout: post
title: DevOps and Microservices - Symbiotes
authorId: simon_timms
date: 2018-10-20
originalurl: https://blog.simontimms.com/2018/10/19/microservices_and_devops/
---

Two of the major ideas de jour in development circles these past few years have been DevOps and Microservices. That they rose to the forefront at the same time was not a coincidence. They are inexorably linked ideas. 

<!-- more -->

Microservices Architecture is a top level software design which favours creating small, loosely connected services which maintain data autonomy. Part of this design requires that each service you deploy has its own data storage (this could be as complex as its own SQL Server instance or as simple as an in-memory cache) and that the service be independently deployable. If you've ever built out a deployment pipeline for a monolithic application and thought "geez, this takes a lot of work" then imagine scaling that over 20 services or 100 services. Equally deploying a lot of databases can be painful to say nothing of how complex it is to deploy copies of your microservices collection over several environments (dev, test, prod,...).

The added work of deploying this large number of services necessitates changes to the old models where releases took weeks and infrastructure was manually provisioned. Perhaps the greatest motivator for people is avoiding boring, repetitive work. Microservices accentuate the pain points which traditional, monolithic design has hidden. It is slow to provision severs, difficult to set up build and annoying to log into servers to get logs. Changes had to be made to unblock microservices. Out of the pain was born a desire to make builds and infrastructure provisioning faster, more repeatable and easier to set up.

DevOps is obviously more that just speeding up builds and unblocking infrastructure. It is a cultural mindset together the previously disjoint operations and development groups to better serve the business by providing reliable changes rapidly. DevOps permeates the entire development life-cycle. 
![Image from https://medium.com/@neonrocket/devops-is-a-culture-not-a-role-be1bed149b0](https://blog.simontimms.com/images/devops_microservices/infinity.png)

To achieve success in DevOps there do need to be some changes to how the software is written. Large applications are obviously slower to build than smaller ones, so that applies pressure to create more smaller applications. As teams become larger to maintain a rate of change which limits the scope of changes pushed to production (which you want to limit investigation when something goes wrong) that also pushes towards smaller services. 

Logging and instrumentation is a necessity when there is no simple, single process path for a request. Opening a half dozen log files and trying to hunt through them all is obviously far less efficient than entering a query into a log aggregator. 

If the inputs and outputs from a service are well known then that unlocks the ability to blackbox services during testing. This practice allows for much better testing: another feature of a strong DevOps culture. 

Independent services are needed in order to permit different parts of the business to move at different speeds without blocking each other. A monolithic application must wait for all parties to agree before promoting a build. 

Without DevOps microservices would be so much more difficult to manage that it would no longer be worth it. At the same time a lot of the advantages you get from a DevOps culture push the shape of applications built under it to be more like microservices. The two are strongly related. 