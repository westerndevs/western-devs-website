---
layout: post
title: You're using HTTPClient wrong and it is destabilizing your software
tags:
  - .net
categories:
  - Deployment   
authorId: simon_timms
date: 2016-08-28 17:36:36
excerpt: I've been using HTTPClient wrong for years and it finally came back to bite me. My site was unstable and my clients furious, with a simple fix performance improved greatly and the instability disapeared. 
---

Microservices can be a bear to deal with. As more services are added and monoliths broken there tend to be more communication paths between services. There are many options for communicating but HTTP is an ever popular option. If the microservies are built in C# or any .NET language then chances are you've made use of HTTPClient. I know I did. 

The typical usage pattern looked a little bit like 

```
using(var client = new HttpClient())
{
    //do something with http client
}
```

The using statement is a C# nicity for dealing with disposable objects. Once the using block is complete then the disposable object, in this case HTTPClient, goes out of scope and is disposed. The `dispose` method is called and whatever resources are in use are cleaned up. This is a very typical pattern in .NET and we use it for everything from database connections to stream writers. Really any object which has external resources that must be clean up uses the IDisposable interface. 

But HTTPClient is different. Although it implements the IDisposable interface it is actually a shared object. This means that under the covers it is [reentrant](https://en.wikipedia.org/wiki/Reentrancy_(computing)) and thread safe. Instead of creating a new instance of HTTPClient for each execution you should share a single instance of HTTPClient for the entire lifetime of the application. Let's look at why

Here is a simple program written to demonstrate the use of HTTPClient

```
using System;
using System.Net.Http;

namespace ConsoleApplication
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("Starting connections");
            for(int i = 0; i<10; i++)
            {
                using(var client = new HttpClient())
                {
                    var result = client.GetAsync("http://aspnetmonsters.com").Result;
                    Console.WriteLine(result.StatusCode);
                }
            }
            Console.WriteLine("Connections done");
        }
    }
}
``` 

This will open up 10 requests to one of the best sites on the internet [http://aspnetmonsters.com](http://aspnetmonsters.com) and do a GET. We just print the status code so we know it is working. The output is going to be 

```
C:\code\socket> dotnet run
Project socket (.NETCoreApp,Version=v1.0) will be compiled because inputs were modified
Compiling socket for .NETCoreApp,Version=v1.0

Compilation succeeded.
    0 Warning(s)
    0 Error(s)

Time elapsed 00:00:01.2501667


Starting connections
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
Connections done
```

All work and everything is right with the world. Except that it isn't. If we pull out the `netstat` tool and look at the state of sockets on the machine running this we'll see 

```
C:\code\socket>NETSTAT.EXE
...
  Proto  Local Address          Foreign Address        State
  TCP    10.211.55.6:12050      waws-prod-bay-017:http  TIME_WAIT
  TCP    10.211.55.6:12051      waws-prod-bay-017:http  TIME_WAIT
  TCP    10.211.55.6:12053      waws-prod-bay-017:http  TIME_WAIT
  TCP    10.211.55.6:12054      waws-prod-bay-017:http  TIME_WAIT
  TCP    10.211.55.6:12055      waws-prod-bay-017:http  TIME_WAIT
  TCP    10.211.55.6:12056      waws-prod-bay-017:http  TIME_WAIT
  TCP    10.211.55.6:12057      waws-prod-bay-017:http  TIME_WAIT
  TCP    10.211.55.6:12058      waws-prod-bay-017:http  TIME_WAIT
  TCP    10.211.55.6:12059      waws-prod-bay-017:http  TIME_WAIT
  TCP    10.211.55.6:12060      waws-prod-bay-017:http  TIME_WAIT
  TCP    10.211.55.6:12061      waws-prod-bay-017:http  TIME_WAIT
  TCP    10.211.55.6:12062      waws-prod-bay-017:http  TIME_WAIT
  TCP    127.0.0.1:1695         SIMONTIMMS742B:1696    ESTABLISHED
...
```

Huh, that's weird the application has exited and yet there are still a bunch of these connections open to the Azure machine which hosts the ASP.NET Monsters website. They are in the TIME_WAIT state which means that the connection has been closed on one side (ours) but we're still waiting to see if any additional packets come in on it because they might have been delayed on the network somewhere. Here is a diagram of TCP/IP states I stole from https://www4.cs.fau.de/Projects/JX/Projects/TCP/tcpstate.html.

![Imgur](http://i.imgur.com/rXxnIA8.png)

Windows will hold a connection in this state for 240 seconds (It is set by [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\TcpTimedWaitDelay]). There is a limit to how quickly Windows can open new sockets so if you exhaust the connection pool then you're likely to see error like 

```
Unable to connect to the remote server
System.Net.Sockets.SocketException: Only one usage of each socket address (protocol/network address/port) is normally permitted.
```

Searching for that in the Googles will give you some terrible advice about decreasing the connection timeout. Instead of tinkering with machine level variables how about we fix the underlying problem?

I really must thank [Harald S. Ulrksen](https://twitter.com/hsulriksen) and [Darrel Miller](https://twitter.com/darrel_miller) for pointing me to [The Patterns and Practices documents](https://t.co/bewSxPqlps) on this.

If we share a single instance of HTTPClient then we can reduce the waste of sockets by reusing them

```
using System;
using System.Net.Http;

namespace ConsoleApplication
{
    public class Program
    {
        private static HttpClient Client = new HttpClient();
        public static void Main(string[] args)
        {
            Console.WriteLine("Starting connections");
            for(int i = 0; i<10; i++)
            {
                var result = Client.GetAsync("http://aspnetmonsters.com").Result;
                Console.WriteLine(result.StatusCode);
            }
            Console.WriteLine("Connections done");
            Console.ReadLine();
        }
    }
}
```

Note here that we have just one instance of HttpClient shared for the entire application. Eveything still works like it use to (actually a little faster due to socket reuse). Netstat now just shows 

```
TCP    10.211.55.6:12254      waws-prod-bay-017:http  ESTABLISHED
```

In the production scenario I had the number of sockets in use dropped from more than 4000 to less than 400.

This is a chunk of a graph from our monitoring tools and shows what happened after we deployed the fix. 

![Imgur](http://i.imgur.com/0QVdLMT.png)

The socket exhaustion problems we had been struggling with for months disapeared and our client threw a parade. This was not an obvious bug. For years we have been conditioned to dispose of objects that implement IDisposable and many refactoring tools like R# and CodeRush actually warn if you don't. In this case disposing of HttpClient was the wrong thing to do. It is unfortunate that HttpClient implements IDisposable and encourages the wrong behaviour. 