---
layout: post
title:  "Running a .NET app against a Postgres database in Docker"
date: 2015-10-25T13:24:14-04:00
categories:
comments: true
authorId: kyle_baley
---

Some days/weeks/time ago, I did a presentation at MeasureUP called "Docker For People Who Think Docker Is This Weird Linux Thing That Doesn't Impact Me". The slides for that presentation can be found [here](http://www.slideshare.net/KyleBaley/docker-for-people-who-have-heard-of-docker-but-think-its-just-this-weird-linux-thing-that-doesnt-impact-me) and the sample application [here](https://github.com/stimms/AzureCodeCamp).

<!--more-->
  
### Using the sample app with PostgreSQL

The sample application is just a plain ol' .NET application. It is meant to showcase different ways of doing things. One of those things is data access. You can configure the app to access the data from SQL storage, Azure table storage, or in-memory. By default, it uses the in-memory option so you can clone the app and launch it immediately just to see how it works.

![PancakeProwler](http://i.imgur.com/xeKON0u.png) 

Quick summary: Calgary, Alberta hosts an annual event called the [Calgary Stampede](http://www.calgarystampede.com/). One of the highlights of the 10-ish day event is the pancake breakfast, whereby dozens/hundreds of businesses offer up pancakes to people who want to eat like the pioneers did, assuming the pioneers had pancake grills the size of an Olympic swimming pool.

The sample app gives you a way to enter these pancake breakfast events and each day, will show that day's breakfasts on a map. There's also a recipe section to share pancake recipes but we won't be using that here.

To work with Docker we need to set the app up to use a data access mechanism that will work on Docker. The sample app supports Postgres so that will be our database of choice. Our first step is to get the app up and running locally with Postgres *without* Docker. So, assuming you have Postgres installed, find the `ContainerBuilder.cs` file in the `PancakeProwler.Web` project. In this file, comment out the following near the top of the file:

{% codeblock lang:csharp %}
// Uncomment for InMemory Storage
builder.RegisterAssemblyTypes(typeof(Data.InMemory.Repositories.RecipeRepository).Assembly)
       .AsImplementedInterfaces()
       .SingleInstance();
{% endcodeblock %}

And uncomment the following later on:

{% codeblock lang:csharp %}
// Uncomment for PostgreSQL storage
builder.RegisterAssemblyTypes(typeof(PancakeProwler.Data.Postgres.IPostgresRepository).Assembly)
    .AsImplementedInterfaces().InstancePerRequest().PropertiesAutowired();
{% endcodeblock %}

This configures the application to use Postgres. You'll also need to do a couple of more tasks:

* Create a user in Postgres
* Create a Pancakes database in Postgres
* Update the `Postgres` connection string in the web project's `web.config` to match the username and database you created

The first two steps can be accomplished with the following script in Postgres:

{% codeblock lang:sql %}
CREATE DATABASE "Pancakes";

CREATE USER "Matt" WITH PASSWORD 'moo';

GRANT ALL PRIVILEGES ON DATABASE "Pancakes" TO "Matt";
{% endcodeblock %}

Save this to a file. Change the username/password if you like but be aware that the sample app has these values hard-wired into the connection string. Then execute the following from the command line:

    psql -U postgres -a -f "C:\path\to\sqlfile.sql"

At this point, you can launch the application and create events that will show up on the map. If you changed the username and/or password, you'll need to update the Postgres connection string first.

You might have noticed that you didn't create any tables yet but the app still works. The sample is helpful in this regard because all you need is a database. If the tables aren't there yet, they will be created the first time you launch the app.

> Note: recipes rely on having a search provider configured. We won't cover that here but I hope to come back to it in the future.

Next, we'll switch things up so you can run this against Postgres running in a Docker container.

### Switching to Docker

I'm going to give away the ending here and say that there is no magic. Literally, all we're doing in this section is installing Postgres on another "machine" and connecting to it. The commands to execute this are just a little less click-y and more type-y.

The first step, of course, is installing Docker. At the time of writing, this means installing [Docker Machine](http://docs.docker.com/windows/started/). 

With Docker Machine installed, launch the Docker Quickstart Terminal and wait until you see an ASCII whale:

![Docker Machine](http://i.imgur.com/UOgoWfK.png)

If this is your first time running Docker, just know that a lightweight Linux virtual machine has been launched in VirtualBox on your machine. Check your Start screen and you'll see VirtualBox if you want to investigate it but the `docker-machine` command will let you interact with it for many things. For example:

    docker-machine ip default

This will give you the IP address of the default virtual machine, which is the one created when you first launched the Docker terminal. Make a note of this IP address and update the Postgres connection string in your web.config to point to it. You can leave the username and password the same:

{% codeblock lang:xml %}
<add name="Postgres" connectionString="server=192.168.99.100;user id=Matt;password=moo;database=Pancakes" providerName="Npgsql" />
{% endcodeblock %}

Now we're ready to launch the container:

    docker run --name my-postgres -e POSTGRES_PASSWORD=moo -p 5432:5432 -d postgres`

Breaking this down:

<style>
    .docker-breakdown td {
        padding: 8px;   
        border: 1px solid #ccc;
    }
    .docker-breakdown code {
        font-size: 14px;
    }
    .docker-breakdown td:nth-child(1) {
        width:220px;
    }
    .docker-breakdown tr:nth-child(even) td {
        background-color: #eee;
    }
</style>
{: .docker-breakdown }
| `docker run` | Runs a docker container from an image |
| `--name my-postgres` | The name we give the container to make it easier for us to work with. If you leave this off, Docker will assign a relatively easy-to-remember name like "floral-academy" or "crazy-einstein". You also get a less easy-to-remember identifier which works just as well but is...less...easy-to-remember |
| `-e POSTGRES_PASSWORD=moo` | The `-e` flag passes an environment variable to the container. In this case, we're setting the password of the default postgres user |
| `-p 5432:5432` | Publishes a port from the container to the host. Postgres runs on port 5432 by default so we publish this port so we can interact with Postgres directly from the host|
| `-d` | Run the container in the background. Without this, the command will sit there waiting for you to kill it manually |
| `postgres` | The name of the image you are creating the container from. We're using the [official postgres image](https://hub.docker.com/_/postgres/) from Docker Hub. |

If this is the first time you've launched Postgres in Docker, it will take a few seconds at least, possibly even a few minutes. It's downloading the Postgres image from Docker Hub and storing it locally. This happens only the first time for a particular image. Every subsequent postgres container you create will use this local image.

Now we have a Postgres container running. Just like with the local version, we need to create a user and a database. We can use the same script as above and a similar command:

    psql -h 192.168.99.100 -U postgres -a -f "C:\path\to\sqlfile.sql"

The only difference is the addition of `-h 192.168.99.100`. You should use whatever IP address you got above from the `docker-machine ip default` command here. For me, the IP address was 192.168.99.100.

With the database and user created, and your web.config updated, we'll need to stop the application in Visual Studio and re-run it. The reason for this is that the application won't recognize that we've changed database so we need to "reboot" it to trigger the process for creating the initial table structure.

Once the application has been restarted, you can now create pancake breakfast events and they will be stored in your Docker container rather than locally. You can even launch pgAdmin (the Postgres admin tool) and connect to the database in your Docker container and work with it like you would any other remote database.

### Next steps

From here, where you go is up to you. The sample application can be configured to use [Elastic Search](https://www.elastic.co/) for the recipes. You could start an Elastic Search container and configure the app to search against that container. The principle is the same as with Postgres. Make sure you open both ports 9200 and 9300 and update the `ElasticSearchBaseUri` entry in `web.config`. The command I used in the presentation was:

    docker run --name elastic -p 9200:9200 -p 9300:9300 -d elasticsearch

I also highly recommend Nigel Poulton's [Docker Deep Dive](http://www.pluralsight.com/courses/docker-deep-dive) course on Pluralsight. You'll need access to Linux either natively or in a VM but it's a great course.

There are also a number of posts right here on Western Devs, including an [intro to Docker for OSX](http://www.westerndevs.com/docker/yet-another-docker-intro/), tips on [running Docker on Windows 10](http://www.westerndevs.com/getting-docker-running-on-windows-10/), and a summary or two on a discussion [we had on it internally](http://www.westerndevs.com/westerndevs-learn-about-docker-part-2/).

Other than that, Docker is great for experimentation. Postgres and Elastic Search are both available pre-configured in Docker on Azure. If you have access to Azure, you could spin up a Linux VM with either of them and try to use that with your application. Or look into Docker Compose and try to create a container with both.

For my part, I'm hoping to convert the sample application to ASP.NET 5 and see if I can get it running in a Windows Server Container. I've been saying that for a couple of months but I'm putting it on the internet in an effort to make it true.