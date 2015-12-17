---
layout: post
title: "BDD vs TDD"
date: 2015-08-11 02:09:40 -0500
comments: true
authorId: amir_barylko
originalurl: http://orthocoders.com/blog/2015/08/12/bdd-vs-tdd/
alias: /bdd-vs-tdd/
---

Testing is a very important part of software development, but should we do black box testing or test every line of code? 

How can we find balance between writing the right thing (BDD) and writing things right (TDD)?

<!--more-->

## A perfect world

_Test Driven Development_ (TDD) makes you think. It’s not only about the _test first approach_ but also about following some [rules](http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd). 

TDD, however, is not enough to ensure that you are building the features that address the client’s expectations.

_Behaviour Driven Development_ (BDD) makes you think about the whole feature. Owners/champions participation helps you write the acceptance criteria and drive the implementation until the feature is implemented. 

When you combine _BDD_ and _TDD_ you get the best of both worlds: you are able to match your clients’ expectations with high quality code and write the minimum amount of code possible. 

![](http://orthocoders.com/images/bdd_cycle.jpg)


Clearly both BDD and TDD are useful, however, is not always easy to implement both. 

Ideally, to find balance you need to make sure you are well versed in both BDD and TDD, so you can be objective and, in the words of a great wizard, choose [between what is easy and what is right](http://www.goodreads.com/quotes/701025-dark-times-lie-ahead-of-us-and-there-will-be). 
That means we need to overcome two major drawbacks (to start): the __learning curve__ and __poor tooling__.

### Learning curve

As with any new methodology both TDD and BDD share a big drawback: _the learning curve_. Not only you need to learn how to implement each of them but also how to combine them.

This part is __crucial__ to find balance between these methodologies. If your team doesn't feel comfortable doing either and see it as a _drag_ they will resist using them or will implement only the bit they can do quickly and find an excuse not to use the other methodology.

Online you can find multiple examples of how to use both BDD and TDD, but they are often simplified and don't deal with more complex and frequent problems such as populating databases, generating testing data, making sure the acceptance cases run on multiple browsers, brittle tests, etc.

Don't get discouraged because you don't get results as quickly as you thought you would. Implementing BDD and TDD is going to take time, but it is very, very, very important (can't stress it enough) to make sure that writing tests is as natural for your team as _using the turn signal when you drive_. You just do it, don't think if it is worth it or not, it is automatic.

Many of these problems in your path, find you will… mitigate them you shall...

What’s the secret?  Training, practice, exercise and...then more practice.  There are great [books](https://pragprog.com/book/hwcuc/the-cucumber-book) to help you follow the process and _tooling_ is essential.

### The right tool for the job

In my experience, one of the main reasons developers get discouraged to write tests is _poor tooling_.

I think we are past finding testing frameworks and runners, still we have areas that are not always covered.

#### Testing hooks & metadata

Most frameworks you may choose to work with will have some kind of _hooks_. Before tests, after tests, before all tests, etc.

Being able to _tag_ tests and identify which ones are using the database, is another great feature to have.

[RSpec](http://rspec.info/) is a great tool to take a peek at what kind of features could be useful for your current need. Probably there are similar libraries with the language you work with that implement the same or similar ideas. 

And if not, why not collaborate with the community and build some?

#### Fake domain data

It is very common to need dummy data to support your scenarios. They can be useful for acceptance testing and for unit testing as well.

Having an easy way to generate fake data is really important. It will simplify how you write your tests and also give you the feeling that you are talking in domain terms, making much easier to understand what the test is about and implement the code.

Libraries like [Factory Girl](https://github.com/thoughtbot/factory_girl),  [FsCheck](https://fscheck.github.io/FsCheck/), [AutoFixture](https://github.com/AutoFixture), [GenFu](https://github.com/MisterJames/GenFu) are great examples to know what to look for.

Not only you can generate good customers, bad customers, etc., but you can also generate multiple cases to test and, even further, why not look into some automatic generation.

#### Databases

Working with databases should be simple and straightforward: loading data before the tests, cleaning after, restoring the schema (if you have one) to a certain point, and populating.

Combining database manipulation with hooks and data generation will give you lots of power to set up scenarios in an easy, painless way.

## The importance of *NOT* being *brittle*

Let’s imagine we have mastered the _tools_ and _the learning curve_. Now we have a new foe that threatens our Ninja skills and may bring our confidence to the floor: __Brittle tests__. 

Tests have to be maintained and kept running _green_ all the time, otherwise defeats the purpose.

You want your tests to be (somehow) _resilient_ to changes in the code. This is a more advanced problem and here are a few tips to check before we can talk about balance.

### Isolation

Avoid assuming a particular state that you don't control. Tests may run now but may not run in the future.

Any state needed to make the test pass has to be set up before the test runs and torn down after the test finishes running.

### Implementation coupling

Tests should be about _inputs_ and _outputs_, not about how they are implemented. Testing a method that queries the database by mocking the way the query is implemented is __dangerous__.  Similarly, testing with a very small set of data may lead you to the wrong conclusion. 

You will be better off focusing on [_Properties Testing_](http://fsharpforfunandprofit.com/posts/property-based-testing). Libraries like [FsCheck](https://fscheck.github.io/FsCheck/) and [Rantly](https://github.com/abargnesi/rantly) can help you enforce pre-conditions and post-conditions and inspire you to look for other ways to make your testing robust.
 

### Mocking the mock

Tests should work for you, not the other way around. If you find yourself creating more code in order to make your current code _testable_ that deserves some attention.

Whenever you postpone testing complexity and replace it with a mock remember that the same complexity will have to be tested later.

Creating interfaces to improve reusability is a great idea, however, make sure you need it. 
For example, abstracting the [repository]({% post_url 2015-06-23-repository-nightmares %}) pattern may not be always a good idea.

### Tools galore

Though there's a plethora of tools to choose from, they will not always come in the exact shape and color you need them.

Don't get discouraged! Learn from it and build your own.

For example, writing domain specific languages to help you test will ease the pain of repeating common scenarios again and again. The investment will pay off.

## Finding balance

Now our team has overcome the hardships of testing and is quite confident implementing both _TDD_ and _BDD_. They can do them with their eyes closed while dancing the Macarena.

So what's the right balance? For me it is __confidence__.

    Do I need to write tests for every domain model, every single scenario, every api call?

Well...it is up to you.

I lean on the __acceptance__ side often to ensure everything works as expected. 

If you have a senior team then perhaps you can relax a bit more and choose which unit tests should be implemented to find a balance between BDD and TDD that you feel comfortable with. 

If you don't see crystal clear that writing one test will imply that the other part is working, then don't skip anything.

Even for acceptance test if you find features that are really similar to others and strongly believe that implementing test scenarios won’t be necessary because your unit/integration test already covers that, go ahead and skip them.

It is a fine line, but the key is __confidence__. 


