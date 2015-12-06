---
layout: post
title:  "MVC 6 cache tag helper"
date:   2015-06-03 20:09:05
authorId: dave_paquette
originalurl: http://www.davepaquette.com/archive/2015/06/03/mvc-6-cache-tag-helper.aspx
comments: true
categories:
---

In this post in my series exploring the ASP.NET 5 MVC 6 tag helpers, I will dig into the Cache Tag Helper. The Cache Tag Helper is a little different than most of the other tag helpers we talked about because it doesn't target a standard HTML tag. Instead, it wraps arbitrary content and allows those contents to be cached in memory based on the parameters you specify.

<!--more-->

## How it works?

Simply wrap the contents you want cached with a __ tag and the contents of the tag will be cached in memory. Before processing the contents of the cache tag, the tag helper will check to see if the contents have been stored in the MemoryCache. If the contents are found in the cache, then the cached contents are sent to Razor. If the contents are not found, then Razor will process the contents and the tag helper will store it in the memory cache for next time. By default, the cache tag helper is able to generate a unique ID based on the context of the cache tag helper.

Here is a simply example that would cache the output of a view component for 10 minutes.
    
    <cache expires-after="@TimeSpan.FromMinutes(10)">    
        @Html.Partial("_WhatsNew")
        *last updated  @DateTime.Now.ToLongTimeString()
    </cache>

The Cache tag will not be included in the generated HTML. It is purely a server side tag. In the example above, only the results of the _WhatsNew_ partial view and the _*last updated _text would be sent to the browser. Any subsequent requests within the 10 minute span simply return the cached contents instead of calling the partial view again. On the first request after the 10 minutes has passed, the contents would be regenerated and cached again for another10 minutes.

> Note, this should work out-of-the box but there is a strange bug with the way the memory cache is initialized in MVC 6 beta 4. For the cache to work properly in this version, add _services.AddSingleton(); _to the end of your Startup.ConfigurServices method.

## Cache Expiry

If no specific expiry is specified, the contents will be cached as long as the memory cache decides to hang on to the item which is likely the lifetime of the application. Chances are this is not the behaviour you want. You will likely want to use one of the 3 options for expiring the cached contents for the Cache Tag Helper: expires-after, expires-on and expires-sliding.

#### expires-after

Use the _expires-after_ attribute to expire the cache entry after a specific amount of time has passed since it was added to the cache. This attribute expects a TimeSpan value. For example, you expire an item 5 seconds after it was cached:
    
    <cache expires-after="@TimeSpan.FromSeconds(5)">
        <!--View Component or something that gets data from the database-->
        *last updated  @DateTime.Now.ToLongTimeString()
    </cache>  

#### expires-on

Use the _expires-on _attribute to expire the cache entry at a specific time. This attribute expects a DateTime value. For example, imagine your system has some backend processing that you know will be updated by the end of each day. You could specify the cache to expire at the end of the day as follows:
    
    <cache expires-on="@DateTime.Today.AddDays(1).AddTicks(-1)">
        <!--View Component or something that gets data from the database-->
        *last updated  @DateTime.Now.ToLongTimeString()
    </cache>  

#### expires-sliding

Use the _expires-sliding_ attribute to expire the cache entry after it has not been accessed for a specified amount of time. This attribute expects a TimeSpan value.
    
    <cache expires-sliding="@TimeSpan.FromMinutes(5)">
        <!--View Component or something that gets data from the database-->
        *last updated  @DateTime.Now.ToLongTimeString()
    </cache>   

## Vary-by / Complex Cache Keys

The cache tag helper builds cache keys by generating an id that is unique to the context of the cache tag. This ensures that you can have multiple cache tags on a single page and the contents will not override each other in the cache. You can also tell the tag helper to build more complex cache keys using a combination of the _vary-by_ attributes. Building these complex keys allows the cache tag helper to cache different contents for different requests based on nearly any criteria you can conceive. A very simple example is caching different contents for each user by adding the _vary-by-user_ attribute:
    
    <cache vary-by-user="true"> 
        <!--View Component or something that gets data from the database--> 
        *last updated @DateTime.Now.ToLongTimeString() 
    </cache>

You can specify any combination of _vary-by_ attributes. The cache tag helper will build a key that is a composite of the generated unique id for that tag plus all the values from the _vary-by_ attributes.

#### vary-by-user

Use this attribute to cache different contents for each logged in user. The username for the logged in user will be added to the cache key. This attribute expects a boolean value. _See example above._

#### vary-by-route

Use this attribute to cache different contents based on a set of route data parameters. This attribute expects a comma-separated list of route data parameter names. The values of those route parameters will be added to the cache key.

For example, the following cache tag would cache different contents based on the _id_ route parameter:

    <cache vary-by-route="id">
        <!--View Component or something that gets data from the database-->
        *last updated  @DateTime.Now.ToLongTimeString()
    </cache>  

#### vary-by-query

The _vary-by-query_ attribute allows you to cache different contents based on the query parameters for the current request. This attribute expects a comma-separated list of query string parameter names. The value of those query string parameters will be added to the cache key.

For example, the following cache tag would cache different contents for each unique value of the _search_ query parameter:

    <cache vary-by-query="search">
        <!--View Component or something that gets data from the database-->
        *last updated  @DateTime.Now.ToLongTimeString()
    </cache>

#### vary-by-cookie

The _vary-by-cookie_ attributes allows you to cache different contents based on values stored in a cookie. This attribute expects a comma-separated list of cookie names. The values of the specified cookie names will be added to the cache key.

For example, the following cache tag would cache different contents based on the value of the _MyAppCookie_.

    <cache vary-by-cookie="MyAppCookie">
        <!--View Component or something that gets data from the database-->
        *last updated  @DateTime.Now.ToLongTimeString()
    </cache>

#### vary-by-header

The _vary-by-header_ attribute allows you to cache different contents based on the value of a specific request header. This attribute expects a single header name. For example, the following cache tag would cache different results based on the User-Agent header:

    <cache vary-by-header="User-Agent">
        <!--View Component or something that gets data from the database-->
        *last updated  @DateTime.Now.ToLongTimeString()
    </cache>

#### vary-by

Finally, the _vary-by_ attribute allows you to cache different contents based on any arbitrary string value. This attribute can be used as a fall-back in case any of the other vary-by attributes do not meet your needs.

For example, the following cache tag would cache different results based on the value of a ProductId that is available on the ViewBag:

    <cache vary-by="@ViewBag.ProductId">
        <!--View Component or something that gets data from the database-->
        *last updated  @DateTime.Now.ToLongTimeString()
    </cache>  

#### Complex Keys

As mentioned earlier, you can specify any number of vary-by parameters and the cache tag helper will build a composite key. Here is an example of a cache tag that will cache different results for each user and _id_ route parameter:

    <cache vary-by-user="true" vary-by-route="id">
        <!--View Component or something that gets data from the database-->
        *last updated  @DateTime.Now.ToLongTimeString()
    </cache>  

## Cache Priority

The contents of a cache tag are stored in an IMemoryCache which is limited by the amount of available memory. If the host process starts to run out of memory, the memory cache might purge items from the cache to release memory. In cases like this, you can tell the memory cache which items are considered a lower priority using the _priority _attribute. For example, the following cache tag is specified as low priority:

    @using Microsoft.Framework.Caching.Memory
    
    <cache vary-by-user="true" 
           priority="@CachePreservationPriority.Low">
        <!--View Component or something that gets data from the database-->
        *last updated  @DateTime.Now.ToLongTimeString()
    </cache>

Possible values for CacheItemPriority are Low, Normal, High and NeverRemove.

The [CacheTagHelper implementation][1] uses an instance of an IMemoryCache which stores cache entries in memory in the local process. Anything that causes the host process to shutdown / restart will cause a full loss of all entries in the cache. For example, restarting an IIS App Pool or scaling down an Azure instance would cause the memory cache to reset. In this case, the CacheTagHelper would rebuild the contents on the next request. In a cloud service like Azure you never know when your website might get moved to a new server so this could happen at any time. The [MemoryCache][2] is not a durable storage mechanism so it is important not to treat it as one.

Another important scenario to consider is when you have multiple load balanced servers. You might get strange / unexpected results if you have [server affinity / application request routing][3] turned off. The [MemoryCache][2] is not a distributed cache. Each server would have it's own memory cache with potentially different contents for each cache tag helper. If the client refreshes a page 3 times and those requests are routed to 3 different servers, then the client could potentially see 3 different contents. Depending on the scenario, this could be very confusing for the user. The solution here would be to avoid turning off ARR / server affinity in a load balanced deployment scenario. By turning this feature on you will ensure that a specific client's requests are always routed to the same server.

The Cache cache tag helper is one of the more unique tag helpers in MVC 6. It provides a flexible and convenient approach to caching the output of a portion of a page and can be a useful tool for improving performance of MVC 6 applications.

_May 4, 2015: Updated with Limitations sections as suggested by Rick Anderson in the comments_

[1]: https://github.com/aspnet/Mvc/blob/dev/src/Microsoft.AspNet.Mvc.TagHelpers/CacheTagHelper.cs
[2]: https://github.com/aspnet/Caching/blob/dev/src/Microsoft.Framework.Caching.Memory/MemoryCache.cs
[3]: https://technet.microsoft.com/en-us/library/dd443543(v=ws.10).aspx