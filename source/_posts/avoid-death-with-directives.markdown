---
layout: post
title:  Avoid Death With C# Compiler Directives
date: 2019-06-13T23:30:00-05:00
categories: happiness
comments: true
authorId: justin_self
---
Compiler directives in C#: they should be avoided. If they aren't, and you're using them to compile different code based on build modes (like DEBUG or RELEASE), then listen closely and do what I do... it'll change your life.

<!--more-->

Simple scenario: You talk to another service that uses Azure AD. For development, you want to use a stub service that returns things and does things similar to the real one in Azure. Doesn't matter what it is. 

Some people may use IoC to handle this. Sometimes, that requires config switches. However, what if you want to be 100% sure that code can never be accidentally turned on in production? You may consider using a compiler directive.

{% codeblock lang:csharp %}
#if DEBUG
DoUnsafeThingThatShouldNeverBeInProduction();
#elif RELEASE
DoItTheSafeWay();
#endif
{% endcodeblock %}

Depending on the build mode, one of those methods will not be make it to the assembly. This prevents any accidents that could do the unsafe thing. Yes, there are other ways of doing this and typically those ways require process and convention. No, this is not fail safe is technically someone could accidentally change the build mode to DEBUG for a production release (sure, whatever).

{% codeblock lang:csharp %}
class Program
{
    static void Main(string[] args)
    {
        HttpClient client;
        
        //weeping and gnashing of teeth
#if RELEASE
        client = ClientFactory.UseClientWithAzureAD();
#elif DEBUG
        client = new HttpClient();
#endif
        
    }
}
{% endcodeblock %}

There's are problems, though, that can arise from using these directives. First, if you have your environment set to DEBUG and this is the only spot you use the `DoItTheSafeWay` method, looking for any usages using your IDE will result in ZERO INSTANCES! NONE! You'll spend 45 minutes trying to figure out how this thing is done in production because, like any normal person, you're using the Find References in your tool. 

But NO! You won't find it. Your IDE simply laughs at you while you struggle knowing it must be used somehow. The IDE knows what's going on. It knows what you want but it decides to continue to hide this from you. So, you end up doing a damn regex search among all the files. The IDE knows it has be caught red handed trying to sabotage you and surfaces the files for you while sheepishly blaming Resharper for performance problems. I call it BS2019 for a reason (not always, generally I like VS).

The other problem is your trusty IDE will tell you that certain using statments are not being used and you should delete them or it will remind you with grayed out text or a colored dash on the scroll bar. You delete them, commit, push, and then find out the build failed because, in release mode, they are being used...

So, use the following code (or something similar):

{% codeblock lang:csharp %}
public class RunMode
{

#if !DEBUG
    private static bool _isRelease = true;
#elif DEBUG
    private static bool _isRelease = false;
#endif

    // ReSharper disable once ConvertToAutoProperty
    public static bool IsRelease => _isRelease;
}
{% endcodeblock %}

And then use it like this:

{% codeblock lang:csharp %}
class Program
{
    static void Main(string[] args)
    {
        HttpClient client;

        //Children laughter and happiness
        if (RunMode.IsRelease)
        { 
            client = ClientFactory.UseClientWithAzureAD();
        }
        else
        {
            client = new HttpClient();
        }
    }
}
{% endcodeblock %}

Your experiences will vary, but reports of using this code show it has saved marriages, increased gas mileage and prevented the death of at least 2 dozen water fowl.
