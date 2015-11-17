---
layout: post
title:  "Testing With Data"
date: 2015-11-17T08:51:00-05:00
categories:
comments: true
author: kyle_baley
originalurl:
---

It's probably not a coincidence that this is coming off the heels of Dave Paquette's [post on GenFu](http://www.westerndevs.com/realistic-sample-data-with-genfu/) in the same way it was probably not a coincidence that Hollywood released three body-swapping movies in the 1987-1988 period (four if you include Big).

I was asked recently for some advice on generating data for use with integration and UI tests. I already have some ideas but asked the rest of the Western Devs for some elucidation. My tl;dr version was the same as what I mentioned in our [discussion on UI testing](http://www.westerndevs.com/on-ui-testing/): it's hard. But manageable. Probably.

The solution needs to balance a few factors:

* Each test must start from a predictable state
* Creating that predictable state should be fast as possible
* Developers should be able to figure out what is going on by reading the test

The two options we discussed both assume the first factor to be immutable. That means you either clean up after yourself when the test is finished or you wipe out the database and start from scratch with each test. Cleaning up after yourself might be faster but has more moving parts. Cleaning up might mean different things depending on which step you're in if the test fails.  

So given that we will likely re-create the database from scratch before each and every test, there are two options. My _current_ favourite solution is a hybrid of the two. 

### Maintain a database of known data

In this option, you have a pre-configured database. Maybe it's a SQL Server .bak file that you restore before each test. Maybe it's a `GenerateDatabase` method that you execute. I've done the latter on a Google App Engine project, and it works reasonably well from an implementation perspective. We had a class for each domain aggregate and used dependency injection. So adding a new test customer to accommodate a new scenario was fairly simple.

We also had it set up so that we could create only the customer we needed for that particular test if we needed to. That way, we could use a step like `Given I'm logged into 'Christmas Town'` and it would set up only that data.

There are some drawbacks to this approach. You still need to create a new class for a new customer if you need to do something out of the ordinary. And if you need to do something only _slightly_ out of the ordinary, there's a strong tendency to use an existing customer and tweak its data ever so slightly to fit your test's needs, other tests be damned. With these tests falling firmly in the _long-running_ category, you don't always find out the effects of this until much later.

Another drawback: it's not obvious in the test exactly what data you need for that specific test. You can accommodate this somewhat just with a naming convention. For example, `Given I'm logged into a company from India`, if you're testing how the app works with rupees. But that's not always practical. Which leads us to the second option.

### Create an API to set up the data the way you want

Here, your API contains steps to fully configure your database exactly the way you want. For example:

{% highlight cucumber %}
Given I have a company named "Christmas Town" owned by "Jack Skellington"
And I have 5 product categories
And I have 30 products
...
{% endhighlight %}

> I'm showing the example in Cucumber but the same applies if you set this up in, say, C# with a fluent API.

You can probably see the major drawback already. This can become _very_ verbose. But on the other hand, you have the advantage of seeing exactly what data is included which is helpful when debugging. If your test data is wrong, you don't need to go mucking about in your source code to fix it. Just update the test and you're done.

---
Loading up your data with a granular API isn't realistic which is why I like the hybrid solution. By default, you can pre-load your database with some common data, like lookup tables with lists of countries, currencies, product categories, etc. Stuff that needs to be in place for the majority of your tests.

After that, your API doesn't need to be that granular. You can use something like `Given I have a basic company` which will create the company, add an owner and maybe some products and use that to test the process for creating an order. Under the hood, it will probably use the specific steps.