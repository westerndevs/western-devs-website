---
layout: post
title:  Cancelling Long Running Queries in ASP.NET MVC and Web API
date: 2015-07-20T14:11:50-04:00
categories:
comments: true
author: dave_paquette
originalurl: http://www.davepaquette.com/archive/2015/07/19/cancelling-long-running-queries-in-asp-net-mvc-and-web-api.aspx
---


A lot has been written about the importance of using [async controller actions][1] and [async queries][2] in MVC and Web API when dealing with long running queries. If done properly, it can hopefully [improve throughput][3] of your ASP.NET applications. While async won't solve the problem of your database being a bottleneck, it can help to ensure that your web server is still able to process other smaller/shorter requests. It will especially ensure requests that do not require access to that database can be processed in a timely fashion.

There is one very important aspect that is often missed in the tutorials that talk about async and that is cancellation.

> NOTE: For the purpose of this article, I am referring to long running queries in terms of read queries (those that are returning data but not modifying data). Cancelling queries that have modified data might not be a good choice for your application. Do you really want to cancel a Save because the user navigated to another page in your application? Maybe you do but probably not. Aside from the data issue, this also won't likely help performance because the database server will need to rollback that transaction which could be a costly operation.

## What is cancellation and how does it work?

Cancellation is a way to signal to an async task that it should stop doing whatever it happens to be doing. In .NET, this is done using a CancellationToken. An instance of a cancellation token is passed to the async task and the async task monitors the token to see if a cancellation has been requested. If a cancellation is requested, it should stop doing what it is doing. Most Async methods in .NET will have an overload that accepts a cancellation token.

Here is a simple console application that illustrates how cancellation tokens work. In this example, a cancellation token is created (via a CancellationTokenSource) and passed along to an async task that does some work. When the user presses the 'z' key, the Cancel method is called on the CancellationTokenSource. This sets the IsCancellationRequested property to true for the token which will cause the async task to stop doing the work.

{% highlight c# %}
static void Main(string[] args)
{
    Console.WriteLine("Silly counter: Press Z to Stop");
    var tokenSource = new CancellationTokenSource();
    var cancellationToken = tokenSource.Token;
    Task.Run(() =>
    {
        long n = 0;                
        while (!cancellationToken.IsCancellationRequested)
        {
            Console.WriteLine(n);
            n = n + 1;
        }
    }, cancellationToken);
 
    while (true)
    {            
        if (Console.Read() == 'z')
        {
            tokenSource.Cancel();                  
        }
    }            
}
{% endhighlight %}

## Why is this so important?

Think about this in the context of a long-running query in a web application. Somewhere on the other side of this long running query is a frustrated user. WHY IS THIS TAKING SO LONG???  What is that user likely to do? Will they sit there diligently waiting for a query to finish running? The longer the query is running, the less likely the user will wait. It is likely the user will give up and navigate to another page or they might hit the browser refresh button in hopes that it will load faster next time.

So, what happens now you have a query running on the server and the user has moved on to another page (or another site all together). Unfortunately, both your database server and web server will continue processing the request, wasting resources executing a query that likely no one cares about anymore.

## Cancellation and the Browser

When I was first looking in to this, I assumed there was no way in my MVC controller to be notified when the user has moved to another page. I turns out I was wrong. If a user navigates to a new page or refreshes the browser, any HTTP Requests that are in progress will be cancelled.

Here is an example where the user visited the MyReallySlowReport page. After waiting for nearly 5 seconds, they gave up and went to the Contact page (_I assume to look for a phone number to call and complain about how slow that report is_). You can see the status of the original page request is _canceled_.

![image][4]

Both MVC and Web API will recognize the cancelled request and signal a cancellation to the async action method for that request.  All you need to do for this to work is add a CancellationToken parameter to your controller action method and pass that token on to whatever async task is doing the work. In this case, Entity Framework:

{% highlight c# %}
public async Task MyReallySlowReport(CancellationToken cancellationToken)
{
    List items;
    using (ApplicationDbContext context = new ApplicationDbContext())
    {
        items = await context.ReportItems.ToListAsync(cancellationToken);
    }
    return View(items);
}
{% endhighlight %}

If your action method already has parameters, just add the CancellationToken parameter to the end of your parameter list. That's it. Now if the browser cancels the HTTP Request, MVC will set the CancellationToken to cancelled and Entity Framework will cancel the SQL query that was executing as part of that request.

That was easy! One simple change to make sure there are fewer server resources wasted processing canceled requests.

## Cancelling Additional Work

Okay, so it's easy to cancel the SQL server request, but what if we were doing some long running task ourselves in the controller method. In that case all we need to do is check the IsCancellationRequested property of the cancellation token and stop the processing if it is set to true.

{% highlight c# %}
public async Task MyReallySlowReport(CancellationToken cancellationToken)
{
    List items;
    using (ApplicationDbContext context = new ApplicationDbContext())
    {
        items = await context.ReportItems.ToListAsync(cancellationToken);
    }
   
    foreach (var item in items)
    {
        if (cancellationToken.IsCancellationRequested)
        {
            break;
        }
        //Do some fairly slow operation
    }
    return View(items);
}
{% endhighlight %}

By exiting the for loop when a cancellation is requested, we can avoid using server CPU resources for HTTP requests that no longer matter.

## SPAs and Ajax Requests

If you are working in a Single Page Application, your app will likely spawn a number of ajax requests to get data from the server. In this case, the browser will not automatically cancel requests when the user navigates to another 'page' in your app. That's because you are handling page navigation yourself in JavaScript rather then using traditional web page navigation. In a single page app, you will need to cancel HTTP requests yourself. This is usually fairly easy to do. For example in jQuery all you need to do is call the abort() method on the XMLHttpRequest instance:

{% highlight javascript %}
var xhr = $.get("/api/myslowreport", function(data){
  //show the data
});
 
//If the user navigates away from this page
xhr.abort();
{% endhighlight %}

You will of course need to tie in to the page/component lifecycle of whatever framework you are using. This varies a lot from framework to framework so I won't specifically cover it here.

## Conclusion

If you are using MVC 5, Web API or MVC 6 in combination with any modern data access layer, it should be extremely easy to pass your cancellation token and cancel long running queries when a request from the client is aborted. This is a simple approach that can help to avoid situations where a small number of users can accidentally overload your web server and database server.

[1]: http://www.asp.net/mvc/overview/getting-started/getting-started-with-ef-using-mvc/async-and-stored-procedures-with-the-entity-framework-in-an-asp-net-mvc-application
[2]: https://msdn.microsoft.com/en-us/data/jj819165
[3]: https://channel9.msdn.com/Events/TechEd/NorthAmerica/2013/DEV-B337
[4]: http://www.davepaquette.com/wp-content/uploads/2015/07/image_thumb.png "image"