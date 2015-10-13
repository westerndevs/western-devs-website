---
layout: post
title:  Getting Started With ELK using Docker
date: 2015-12-08T21:56:53-06:00
categories:
comments: true
author: simon_timms
originalurl:
---

In my last post I talked about how I was setting up docker to experiment with [Elastic Search, Logstash and Kibana](https://deviantony.wordpress.com/2014/05/19/centralized-logging-with-an-elk-stack-elasticsearch-logback-kibana/). One of the challenges with microservices is that we have a lot of different processes all over the network. It would not be uncommon to have 30 or 40 services on many different machines. The services could be deployed within virtual machines or even docker containers. The same isolation of services that makes developing and evolving microservices easy makes logging very difficult. Being able to trace calls through services can be difficult and logs on VMs or in containers may disappear as these abstractions are recycled. We need to find some way to gather and aggregate these disparate logs. 

This is exactly what the ELK stack does. Let's look at all the components involved one at a time and then we'll see how to use is. 

**Logstash** is the first component: it is a service which can be used to gather data from multiple sources and the perform post processing on it. For instance you might have a log file that contains the user id of a user who made a request against the server. Log stash could have a rule in place to look up the associated user name which is much friendlier for end users. Another example might be resolving an IP address to a geographic location. Logstash can also normalize data from many different sources so it is easier to correlate. You can think of logstash as really being a sewage plant which takes in various sources of garbage(your logs), cleans it and then dumps the consistent clean water into holding tanks. The holding tank can be anything but in our case it will be Elasticsearch. 

That brings us to **Elasticsearch**.  You may have heard of Elasticsearch as a general purpose search engine. It is a service which indexes large number of documents and provides an interface for searching over them. It can be used for almost anything and many people use it as a replacement for a database driving their entire application off search. In this case it is used to hold logs piped in from Logstash. This is an innovative idea. Normally log files become an inaccessible dumping ground for all sorts of data.  You only open up the logs when there is a problem discovered through other means. It is hard to find the one entry that you really need or to extract trends. Keeping the log data in a search engine really opens up the data for investigation. 

Build on top of the Elasticsearch database is **Kibana**. Kibana is a data visualizaiton tool combined with an interface for Elasticsearch's indexes. You can use Kibana to search for logs, to visualize the data or to do investigations of issues. 

The one component I haven't mentioned here is a way to get your log data from various different machines into your centralized logstash. You applications can write to logstash directly but there is always the possibility that logstash will be down and then you need to write a bunch of retry logic yourself. No fun! Instead it is better to simply write you log files locally and then ship the log files off to logstash. You can use logstash itself for that but logstash is built on top of the JVM which is kind of inefficient and means you have to install the JVM onto all you machines. Yuck. Instead you can use one of a number of standalone tools for shipping the logs. I like one which was called Lumberjack and is now called [logstash-forwarder](https://github.com/elastic/logstash-forwarder). It is written in Go and jolly quick. 

Okay, okay enough introduction let's get going. 

# Staring the ELK

There are a couple of pre-built docker containers out there with ELK pre-configured. I found that sebp/elk was the best of them. It is well documented [here](http://spujadas.github.io/elk-docker/). We run the container with  

```
docker run -p 5601:5601 -p 9200:9200 -p 5000:5000 -it --name elk sebp/elk
```

You can see that we're exposing 3 ports

 - 5601 Kibana web interface
 - 9200 Elasticsearch's web interface
 - 5000 Logstash (this is where we would send logs from logstash-forwarder)
 
 If you're running with docker-machine don't forget to add at least ports 5601 and 5000 to the virtual machine. 
 
 With that kibana should be up and running. You can test it out by going to http://localhost:5000. Of course there isn't much to visualize because we haven't put any data in there yet. Next up we have to push some data into it. To do so I pulled down logstash-forwarder and ran it locally. 
 
 It didn't work because of SSL. 
 
```
2015/10/12 19:13:13.452439 Connecting to [127.0.0.1]:5000 (elk)
2015/10/12 19:13:13.470699 Failed to tls handshake with 127.0.0.1 x509: certificate is valid for , not elk
```
 
 The problem here is that the certificate for logstash-forwarder locally is not the same as the one on the image. You can grab the certificate from the container by running
 
```
docker cp 61c2e23ad51a:/etc/pki/tls/private/logstash-forwarder.key lumberjack.key
docker cp 61c2e23ad51a:/etc/pki/tls/certs/logstash-forwarder.crt lumberjack.crt 
```
 
 Even with that I couldn't get it to work because the host name in the certificate is not the same as the one I used in logstash-forwarder's config file. I initially tried using 127.0.0.1 but I guess using IP addresses in certificates is really crummy and the [logstash-forwarder readme](https://github.com/elastic/logstash-forwarder) recommends against it. 
 
 Thus I logged into the docker image and generated a new certificate. Logging required launching the container with a shell specified
 
```
 docker run -p 5601:5601 -p 9200:9200 -p 5000:5000 -it --name elk sebp/elk /bin/bash
```
 
 Once logged into the container I ran
 
```
 openssl req -x509  -batch -nodes -newkey rsa:2048 -keyout /etc/pki/tls/private/logstash-forwarder.key -out /etc/pki/tls/certs/logstash-forwarder.crt -subj /CN=elk
```
 
 You'll note that I included ```/CN=elk``` in the command. This is the name of the domain to use in the certificate. I added a line pointing elk to 127.0.0.1 in my hosts file
 
```
 127.0.0.1	elk
```
 
 Finally I got logstash-forwarder running and sending messages.  The config file I used looked like
 
 {% highlight json %}
 {
  "network": {
    "servers": [ "elk:5000" ],
    "ssl certificate": "./lumberjack.crt",
    "ssl key": "./lumberjack.key",
    "ssl ca": "./lumberjack.crt",
    "ssl strict verify": false,
    "timeout": 15
  },

  # The list of files configurations
  "files": [
    {
      "paths": [
        "/tmp/testlog.log"
      ],
      "fields": { "type": "syslog" }
    }, {
      # A path of "-" means stdin.
      "paths": [ "-" ],
      "fields": { "type": "stdin" }
    }
  ]
}
{% endhighlight %}

I used stdin so I could just type thing into the console and have them show up in kibana. I also put in a log file to which I could append lines. The output from logstash-forwarder tells me the log entries are being forwarded

```
2015/10/12 21:12:19.365424 Launching harvester on new file: /tmp/testlog.log
2015/10/12 21:12:19.365512 harvest: "/tmp/testlog.log" (offset snapshot:0)
2015/10/12 21:12:20.109398 Registrar: processing 1 events
2015/10/12 21:12:30.109288 Registrar: processing 1 events
2015/10/12 21:13:15.111247 Registrar: processing 1 events
2015/10/12 21:13:25.109295 Registrar: processing 1 events
```

Indeed they do show up in Kibana

![http://i.imgur.com/FuS46Hf.jpg](http://i.imgur.com/FuS46Hf.jpg)

There are quite a few moving pieces here but the docker image takes care of most of them. In a future post we'll look at how to add some more information to our logs and how to get logs from ASP.net and C# in general into kibana. 