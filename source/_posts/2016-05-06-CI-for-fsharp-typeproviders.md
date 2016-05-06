---
title: CI with F# SQL Type Providers
layout: post
categories:
  - docker
authorId: simon_timms
date: 2016-05-06 18:56:56 
excerpt: "F# type providers are awesome but it took me a bit to figure out how to get them to work with CI"
---

My experimentation with F# continues. My latest challenge has been figuring out how to get SQL type providers to work with continuous integration. The way that SQL type providers work (and I'm speaking broadly here because there are about 4 of them) is that they examine a live database and generate types from it. On your local machine this is a perfect set up because you have the database locally to do development against. However on the build server having a database isn't as likely.

In my particular case I'm using Visual Studio Online or TFS Online or whatever the squid it is called these days. Visual studio team services that's what it is called. 

![Screenshot of VSTS](http://i.imgur.com/raetyHn.jpg)

I'm using a hosted build agent which may or may not have a database server on it - at least not one that I really want to rely on. I was tweeting about the issue and Dmitry Morozov (who wrote the type provider I'm using - the F# community on twitter is amazing) suggested that I just make the database part of my version control. Of course I'm already doing that but in this project I was using EF migrations. The issue with that is that I need to have the database in place to build the project and I needed to build the project to run the migrations... For those who are big into graph theory you will have recognized that there is a cycle in the dependency graph and that ain't good.

![Graph cycles](http://i.imgur.com/8tORskw.png)

EF migrations are kind of a pain, at least that was my impression. I checked with Canada's Julie Lerman, David Paquette, to see if maybe I was just using them wrong.

![Discussion with Dave Paquette](http://i.imgur.com/0O49NuU.jpg)

So I migrated to roundhouse which is a story for another post. With that in place I set up a super cheap database in azure and I hooked up the build process to update that database on every deploy. This is really nice because it catches database migration issues before the deployment step. I've been burned by migrations which locked the database before on this project and now I can catch them against a low impact database. 

One of the first step in my build process is to deploy the database.
![Build process](http://i.imgur.com/rcrX5KS.jpg)

In my F# I have a setting module which holds all the settings and it includes 

```
module Settings = 
    [<Literal>]
    let buildTimeConnectionString = "Server=tcp:builddependencies.database.windows.net,1433;Database=BuildDependencies;User ID=build@builddependencies;Password=goodtryhackers;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
```
And this string is used throughout my code when I create the SQL based types 
```
type Completions = SqlProgrammabilityProvider<Settings.buildTimeConnectionString>
```
and 

```
let mergeCommand = new SqlCommandProvider<"""
        merge systems as target
        ...""", Settings.buildTimeConnectionString>(ConnectionStringProvider.GetConnection)
```
In that second example you might notice that the build time connection string is different from the run time connection string which is specified as a parameter. 

##How I wish it worked

For the most part having a database build as part of your build process isn't a huge deal. You need it for integration tests anyway but it is a barrier for adoption. It would be cool if you could check in a serialized version of the schema and, during CI builds, point the type provider at this serialized version. This serialized version could be generated on the developer workstations then checked in. I don't think it is an ideal solution and now I've done the footwork to get the build database I don't think I would use it.

