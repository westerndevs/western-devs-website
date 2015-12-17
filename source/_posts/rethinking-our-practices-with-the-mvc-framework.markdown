---
layout: post
title:  "Rethinking our practices with the MVC framework"
date:   2015-06-14 20:09:05
authorId: james_chambers
originalurl: http://jameschambers.com/2015/06/rethinking-our-practices-with-the-mvc-framework/
categories:
comments: true
alias: /rethinking-our-practices-with-the-mvc-framework/
---

We get set in our ways, don't we? It's funny how the sharper and more confident we get with our frameworks and the tooling we employ to work with them, we also get a little more attached to our way of doing things. And then along comes a major version change, ripe with breaking changes and new bits to twiddle and we're left saying, "But, that's not how we've always done it!".

Case in point: **service injection into views**. In ASP.NET's MVC Framework 6 we get this new concept which, if we're going to accept, requires that we relax on our thinking of how we've always done things.

> My friends [Dave Paquette][1], [Simon Timms][2] and [myself][3] have been ruffling through a few of these types of changes, and Simon did a great job of illustrating how we used to get data into our views, and how we might do it in [tomorrow's MVC][4].  For a walkthrough of service injection I highly recommend his article on it.

How does it work? The new inject feature gives us the ability to asynchronously invoke methods on classes that are dynamically created and given to our view. It's IoC for your UI.

Personally, I'd been wrestling with a good use case here because we had a way to do it, and it seems an obvious one (illustrated by Simon) had been missing my thought stream, likely because it's been clouded for a few years with ViewBag. In all reality, the idea of using the ViewBag – a dynamic object that is double-blind, easily forgotten about and easily polluted – to push bits of data to the view has always kind of bugged me, no less than using filters did, but we didn't have an elegant, framework-driven mechanism to make it happen more gracefully.  We do now.

> Also, let's not confuse things here: In more cases than not, your ViewModel is going to be the correct place to put your data, and where I've put my data for most things – like drop down lists – but this type of feature is exciting because it opens the door to explore new options in building views and experiences for our users.

## But, doesn't it break the design of MVC?

![Source: http://www.nv.doe.gov/library/photos/][5]

Sometimes things blow up when you try them out, but you still gotta try.

Perhaps. Maybe, if you want to say, "The only definition valid for any framework is the original definition." But we have more tools today to do our job, and in particular for this case dependency injection which has become a first-class citizen in ASP.NET. So, let's rewind a bit and ask, why is it a bad practice to give a component the pieces it needs to do its work?

Let's think of the type of problem that we're trying to solve here, as Simon did in his article: a view needs to populate a dropdown list. It doesn't need to access the database, and it shouldn't have it. It doesn't need to know a connection string, or if data is coming from a cache, a web service or otherwise, it just needs the data. Giving it an interface by which to look it up, well, to me that seems like a good idea.

If instead you favor the approach of using the controller to populate the ViewBag or use filters (or other techniques) you inherently introduce coupling to a specific view in the controller by forcing it to look up data to populate a dropdown box. _You are still injecting data into the view._ In my mind, the controller should know as little as possible about the view.  Why should I have to change my controller if I need to change my view?

> I want to make a clear distinction here, though, as I do believe the controller answers very specific concerns, namely, those that deal with a particular entity. But the PersonController shouldn't have to know the list of Canadian Provinces, should it?

## Don't need to know where I'm going, just need to know where I've been

The assumption that the controller provides everything the view needs is guided by past pretence. It was true in MVC5 and earlier because it was what we had to work with. My point is that in MVC6 we now have a construct that allows:

* Separation of concern/single responsibility
* Testability
* Type safety
* Injectable dependencies

In my mind, the controller is just a component. So is the view. The controller's concerns are related to the entity in question. The view is required to render correct UI such that a form can be filled out in a way that satisfies the requirements of the view model. Again, why use a person controller to retrieve details about countries and states?

I don't see controllers as any more important than any other component. They have things they need, and they should have those things injected. My controllers don't talk to the database, they talk to command objects and query objects via interface and those are injected from an IoC container.

I think now, with views as first-class components, that we can look at views in the same way.

## But what about ViewBag?

With ViewBag (and filters) we have a problem that we're not really talking about in the best interest of not upsetting anyone. The fact that my controller has to do the lifting for the combo boxes is awkward and doesn't really help us out too much with maintaining SRP. But we didn't previously have a good way to address this.

We also tend to overlook the fact that Views are effectively code. Why can't our principles apply to them as well? Of course I shouldn't access the database from the view, but why can't I know about an interface that does (and have it injected)?

This is a great use case of this new feature, and one that demonstrates that "not changing for the sake of not changing" isn't a good mantra. If my view code/class/script is responsible for rendering the view, I see no problem injecting into it the things it needs to do so.

After all, isn't that what you're doing with ViewBag? Just injecting things into the view through the Dynamic? Except, with ViewBag, no one sees type problems and everyone has to cast. Now we've got run time errors.

There is the argument that says that even if we're abstracting away the data access, we're introducing the ability for the view to call the database. Again, I don't think the view is any less important a component in the scheme of things, and there is a level of appropriateness with which we must use the feature. Will it be abused? Likely. You don't want to be injecting database change-capable components into the view, but that is more a case of bad choices in implementation. You can completely destroy the maintainability of a project and wreak havoc on your users with service injection, but that doesn't mean you should avoid it. I've seen people write 1,000 lines of code in a method, but that doesn't mean I don't use methods any more.

**When changes come to frameworks, I think it's okay to rethink our best practices**. Taking Simon's approach we have:

* Interface-based injection
* Abstraction from underlying data access strategy (db, cache, text file, whatever)
* Testable components
* Maintaining SRP in our controller and view
* No casting from dynamic to proper types

I'm okay with this approach and will be using this approach in MVC 6 projects.

I highly encourage you to do your own reading on this and explore the feature in greater detail. Here are a few links for your consideration.

Happy coding! ![Smile][6]

_Image credit: http://www.nv.doe.gov/library/photos/_

[1]: https://twitter.com/dave_paquette
[2]: https://twitter.com/stimms
[3]: https://twitter.com/canadianjames
[4]: http://blog.simontimms.com/2015/06/09/getting-lookup-data-into-you-view/
[5]: http://jameschambers.com/wp-content/uploads/2015/06/nuke-300x188.jpg
[6]: http://jameschambers.com/wp-content/uploads/2015/06/wlEmoticon-smile.png
  