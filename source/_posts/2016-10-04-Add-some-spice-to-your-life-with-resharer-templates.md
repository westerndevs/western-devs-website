---
layout: post
title:  Add some spice to your life with Resharper Templates
date: 2016-10-04T11:30:00-06:00
categories: Azure
comments: true
authorId: justin_self
---

Do you use Resharper? Do you have 5 minutes? Awesome, let's change your life.

<!--more-->

Open Visual Studio. Click on the `Resharper` menu item, navigate to Tools > Template Explorer, then click on the new template button (see image);

![Imgur](http://i.imgur.com/gkkaV52.png)

In the editor, paste this: `//TODO : $user$ $date$ $description$`

On the right, you'll now see three parameters. For `user`, click "choose macro", and the select "Full user name of current user".

For the `date` parameter, click "Choose macro", and then select "Current data specified format". In the format box, type "MM/dd/yyyy".

Uncheck the `editable` checkboxes for `user` and `date`.

Lastly, in the "Shortcut" box, type "todo" and name it "todo helper".

![Imgur](http://i.imgur.com/DGqDxdb.png)

Ok, save and make a new one for "hack" comments with "//HACK : $user$ $date$ $description$"

Now, you should be able to go into your C# class files and do this:

![Imgur](http://i.imgur.com/P8OUP3A.gif)

Cool, huh?

Ok, now let's make a unit test help with this: 

    [Test]
    public void $methodName$()
    {
	    //Arrange
	    $END$

	    //Act


	    //Assert
    
    }

I use the shortcut `nut` for "nUnit Test". If you use other testing frameworks, just modify it to suite your needs.

Save it and now add tests like this: 

![Imgur](http://i.imgur.com/jVo9WoU.gif)

Pretty sweet, right? Life changing? Maybe.