---
title: End to end testing for your saga
layout: post
tags:
  - NserviceBus
categories:
  - Tools
authorId: simon_timms
date: 2016-07-15 14:56:56 
excerpt: "Looking to do end to end testing of your saga? I strugged."

---

**Disclaimer**

In this article I'm going to use the term "saga" because that's what NServiceBus calls it. Don't take this as acceptance of this definition of "saga" in general. What NServiceBus call "saga" would be better called a "workflow" or "process manager". Kellabyte has a [great article](http://kellabyte.com/tag/saga/) on it.

I've recently been playing with sagas in NServiceBus. A saga is a tool for coordinating a number of messages across time. Generally there will be one or messages which start a saga and then the saga will listen for new messages to wake up and perform action. A saga is stateful which means that you can put all sorts of useful information in the saga data to allow making decisions later on. A very useful feature of sagas is that you can set a timeout to be fired at some point in the future. So for example you could start a shopping cart saga and schedule a timeout 24 hours in the future. When that timeout is reached the saga is woken up again and you could send a reminder e-mail to the owner of cart to check out. There are countless business processes which have some requirement to do something in the future even if that something is checking to make sure that some action has occured and compensating if not.

As you can imagine when testing a saga in an end to end test you don't really want to wait 24 hours for something to timeout. The usual advice around this is to make the timeout configurable in some fashion and just set it to a low value. This is difficult to do in an end to end test and still have confidence that you're not hiding some broken functionality. This is why we don't like to have special constructors just for unit testing. In my case I'm using SQL persistance to save timeout information to a database. This means that the database can be hacked to allow the manual execution of timeouts. Let's do it.

The `TimeoutEntity` table is the one we want to alter. It contains a column called `Time` which is the time at which the timeout will occur. In my case I knew an Id from the saga so I joined against the specific saga data table to find the approprate timeout to update. I only schedule one timeout at a time with this saga so I don't have to worry about finding a timeout in a multitude of them for that saga.     

{% codeblock lang:sql %}
update te
set Time=GETUTCDATE()
from nservicebus.dbo.TimeoutEntity te inner join 
        nservicebus.dbo.SockFinderSagaData sfsd on te.SagaId = sfsd.Id
where SockId=@sockId
{% endcodeblock %}

You'll note here that I set the time to the current time. It is important that you don't set the date to some time in the past. I initially did that and found timeouts weren't firing. The reason is that the query NServiceBus uses to find the timeout looks for timeout entries since the last polling event to now. This query would miss things scheduled way in the past. Here are the queries the NHibernate persistence uses

```
2016-07-15 16:17:29,197 DEBUG [15][NT AUTHORITY\SYSTEM] SELECT this_.Id as y0_, this_.Time as y1_ FROM TimeoutEntity this_ WHERE this_.Endpoint = @p0 and (this_.Time >= @p1 and this_.Time <= @p2) ORDER BY this_.Time asc;@p0 = 'AdverseActions' [Type: String (4000)], @p1 = 7/15/2016 3:47:42 PM [Type: DateTime (0)], @p2 = 7/15/2016 4:17:29 PM [Type: DateTime (0)]
2016-07-15 16:17:29,197 DEBUG [15][NT AUTHORITY\SYSTEM] SELECT this_.Id as Id6_0_, this_.Destination as Destinat2_6_0_, this_.SagaId as SagaId6_0_, this_.State as State6_0_, this_.Time as Time6_0_, this_.Headers as Headers6_0_, this_.Endpoint as Endpoint6_0_ FROM TimeoutEntity this_ WHERE this_.Endpoint = @p0 and this_.Time > @p1 ORDER BY this_.Time asc OFFSET 0 ROWS FETCH FIRST @p2 ROWS ONLY;@p0 = 'AdverseActions' [Type: String (4000)], @p1 = 7/15/2016 4:17:29 PM [Type: DateTime (0)], @p2 = 1 [Type: Int32 (0)]
 ```

 Polling of the timeout table happens at least once per minute. So this still means that your tests need to wait 60 seconds from hacking the table to checking the result of the timeout. This is still a bit painful but these are integraiton tests and likely you're running a bunch in parallel so the hit isn't horrific. With this code in place I was able to reliably simulate the state of the saga in the future. I'm like a time traveler and you can be too. 