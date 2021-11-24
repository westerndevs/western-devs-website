---
layout: podcast
title:  "The Repository Pattern"
date: 2015-08-04T11:55:26-04:00
recorded: 2015-07-24
categories: podcasts
excerpt: "Do we really need all these repositories?"
comments: true
podcast:
    filename: "RepositoryPattern.mp3"
    length: "48:07"
    filesize: 57742198
    libsynId: 5292005
    anchorFmId: The-Repository-Pattern-evqdj5
participants:
    - dave_paquette
    - amir_barylko
    - simon_timms
    - dylan_smith
    - donald_belcham
links:
    - Repository nightmares|http://www.westerndevs.com/repository-nightmares/
    - Repository pattern|http://martinfowler.com/eaaCatalog/repository.html
    - Double dispatch|https://en.wikipedia.org/wiki/Double_dispatch
    - Interface Segregation Principle|https://en.wikipedia.org/wiki/Interface_segregation_principle
    - Domain Driven Design Aggregate|http://martinfowler.com/bliki/DDD_Aggregate.html
    - The N+1 problem|http://stackoverflow.com/questions/97197/what-is-the-n1-selects-issue
music:
    song:
        title: Doctor Man
        artist: Johnnie Christie and the Boats
        url: https://www.youtube.com/user/jwcchristie
---
### Synopsis

* What is the Repository Pattern?
* Where should the business logic go?
* Explosion of methods on repositories and the Interface Segregation Principle
* Testing repositories: integration vs. unit
* Transactions: Are they a database or business concern?
* Eager vs. lazy loading: The N+1 problem
* Extension methods and query objects as an alternative
* The misuse of reuse: "Hey, this looks like it does what I need it to do"
* The Double Dispatch Pattern
* Managing transactions and eventual consistency in distributed systems
* Eventual inconsistency in the real world
