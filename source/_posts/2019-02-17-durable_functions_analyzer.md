9layout: post
title: Durable Functions Analyzer
authorId: simon_timms
date: 2019-02-17 19:00
originalurl: https://blog.simontimms.com/2019/02/17/2019-02-17-durable_functions_analyzer/
---

When it was announced the Roslyn would become the default compiler for C# in Visual Studio I was [super excited](https://blog.simontimms.com/2014/04/04/roslyn-changes-everything/). I felt like it would generate all sorts of domain specific languages, custom flavors of C#, tons of custom error providers. So here we are 5 years later and almost none of it has come to pass. Why not?
<!--more-->

Well turns out the compiler stuff is kind of hard. It is just a bridge too far for people to do any of the cool things I thought they would do. I guess we can add this to the long list of things that I'm wrong about. 

But a few weeks ago I broke some code in a durable function because I was returning the wrong shaped data. I didn't find out until the code was deployed which is obviously later than I wanted. Because of the way that Durable Functions were constructed favoring magic strings and Objects it tends to be more susceptible to bugs which you wouldn't normally see in a statically typed language. 

For instance consider this code 

```csharp
[FunctionName("HireEmployee")]
public static async Task<Application> RunOrchestrator(
    [OrchestrationTrigger] DurableOrchestrationContext context,
    ILogger log)
{
    var applications = context.GetInput<List<Application>>();
    var approvals = await context.CallActivityAsync<List<Application>>("ApplicationsFiltered", Guid.NewGuid());
    log.LogInformation($"Approval received. {approvals.Count} applicants approved");
    return approvals.OrderByDescending(x => x.Score).First();
}
```

There are two magic strings in this code. The first is the name of the function in the annotation before the function declaration. The second is in the `CallActivityAsync` where a function called `ApplicationsFiltered` is called. If there is a typo in either of these strings the orchestration will fail at runtime.

You'll note too that we pass a Guid into that function. The function definition simply has an Object as the second argument so there is no type checking. Instead of passing in the Guid which is required there would be no compiler issues if we instead passed in a `Frog` or a `Puppy` or even an `int`.

I started working on a Roslyn analyzer which could solve some, or all of these short comings. I won't get into the technical parts of how to build an analyzer here (although I did just submit a conference talk on that). 

It produces warnings (for now) when your functions aren't used correctly. Right now it will detect 

* Incorrectly named functions
* Incorrect return types from functions
* Incorrect argument for functions
* Orchestration annotations misapplied to arguments

Here are some screenshots of it in action.

![A misnamed function and a suggestion for what it should be called.](https://blog.simontimms.com/images/roslynanalyzer/poc.png)
A misnamed function and a suggestion for what it should be called.

![An incorrect argument being detected](https://blog.simontimms.com/images/roslynanalyzer/poc2.png)
An incorrect argument being detected


![An incorrect return type being detected](https://blog.simontimms.com/images/roslynanalyzer/poc3.png)
An incorrect return type being detected

![Orchestration trigger on the wrong data type](https://blog.simontimms.com/images/roslynanalyzer/poc4.png)
Orchestration trigger on the wrong data type

If you want to try this out on your own project it is as easy as installing a [nuget package](https://www.nuget.org/packages/DurableFunctionsAnalyzer/). 

I'm looking for suggestions for new features or bugs in existing features. My tests are limited so any bug people can contribute will improve the product. Open an issue on [github](https://github.com/stimms/DurableFunctionsAnalyzer)

Now I know how to build these analyzers I think I'll try to build more for internal applications. 