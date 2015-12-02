---
layout: post
title: "Repository nightmares"
date: 2015-06-23 21:17:24 -0500
author: amir_barylko
originalurl: http://orthocoders.com/blog/2015/06/23/repository-nightmares
categories: 
comments: true
---

The ```Repository``` pattern is a famous (or infamous?) pattern that we can find in Martin Fowler's _[Patterns of Enterprise Application Architecture](http://martinfowler.com/eaaCatalog/repository.html)_.

It was meant to be used as an interface to a collection, but what I have seen more often is that it becomes an abstraction to the data layer or ORM framework. 

Not so long ago I did a presentation on _[Who killed object oriented programming](http://www.slideshare.net/amirbarylko/who-killed-object-oriented-design)_, and I mentioned the ```Repository``` implementation as one of the culprits.

So what's so bad about it? What can we do to improve it? 

I have a counter-proposal: What if we don't need it at all?

<!--more-->

## Repository overpopulation

Have you ever felt that the ``Repositories`` in your code replicate at night? You remember that when you started the project you had one or two, but now the number has grown to almost one per data model.

I remember starting with something like this:

{% codeblock lang:csharp %}
public interface ICustomerRepository {
  IEnumerable<Customer> GetCustomers();
}
{% endcodeblock %}

And then I needed to add queries such as find by ```Address```, find by ```Id``` and find which customers have pending invoices:

{% codeblock lang:csharp %}
public interface ICustomerRepository {
  IEnumerable<Customer> FindByAddress(Address address);
  IEnumerable<Customer> FindById(CustomerId id);
  IEnumerable<Customer> FindWithPendingInvoices();    
}
{% endcodeblock %}

Once one was completed, I replicated the recipe for each model: ```Invoice```, ```Car```, ```Chair```, etc.

### Eliminating the repetition

Maybe we don't need one per model. What if we could use a generic class?

{% codeblock lang:csharp %}
public interface IRepository<T> {
  IEnumerable<T> GetAll();
}
{% endcodeblock %}

Now that's slightly better, but what happened to the queries? 

### Extracting custom queries

Instead of adding queries following the business rules and modifying the ```Repository``` each time, why not use ```IQueryable``` instead? That way we can combine the results with further queries.

{% codeblock lang:csharp %}
public interface IRepository<out T> {
  IQueryable<T> GetAll();
}
{% endcodeblock %}

Then we just need to combine the filtering and ordering after:

{% codeblock lang:csharp %}
var customers = ... // instantiate a concrete IRepository<Customer>
  
return customers
    .Where(c => c.Address != null)
    .OrderBy(c => c.Name)
    .Take(100);
{% endcodeblock %}


### Common queries

We can easily put this logic (if it's really commonly used) into an extension method (or another class) to avoid repeating the same query and to capture complexity.

{% codeblock lang:csharp %}
public static class CustomerQueries {
  public static IQueryable<Customer> WithAddress(this IQueryable<Customer> customers) {
    return customers
        .Where(c => c.Address != null)
        .OrderBy(c => c.Name)
        .Take(100);
  }
}
{% endcodeblock %}


This would allow us to reuse the query when needed:

{% codeblock lang:csharp %}
var customers = ... // instantiate a concrete IRepository<Customer>
  
return customers.WithAddress();
{% endcodeblock %}


## Abstracted abstraction

We’ve done a great job (pat on the back) so far! Now it’s much simpler...so simple that when we look at the implementation, we see we are just using the ORM (NHibernate, Entity Framework, etc.) to return the main collection and nothing else.

The result in this case is that the ```Repository``` pattern is abstracting us from another abstraction! What are we gaining from this?

Why not just use the ORM? Are we planning on changing ORMs in the middle on the project?

We should take advantage of all the power that the ORM is giving us. We don't want to have to copy the ability to do joins, sorting, etc.

Weeping...is cathartic...

## What about testing?

Another reason to introduce the ```Repository``` could be testing.

But what are we going to test? Should we be testing the method ```GetAll```?

Are we planning to mock ```IQueryable```? Or, even further, mock all the methods that come with the ORM session?

The logic is mostly in the queries or, for example, in controllers doing queries in a web application.

Unit tests won't work in this case. We don't want to depend on which methods are used or in which order they’re used, so we need to make sure the inputs are defined and write assertions on the outputs enforcing the pre- and post-condition.

This case calls for integration tests (small tests setting up the database before and cleaning it up after) to help us ensure it works as expected.

## Summary

Make your life simpler and your work more enjoyable. Abstractions should make the code easier to read. If that is not the case, then it is time to reflect and review.

Perhaps it is a bit late to change the project we are working on right now, but next time let’s make sure we give quite a bit more thought to using the ```Repository``` pattern.
