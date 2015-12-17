---
layout: post
title:  Realistic Sample Data With GenFu
date: 2015-11-16T08:47:02-05:00
categories:
comments: true
authorId: dave_paquette
originalurl: http://www.davepaquette.com/archive/2015/11/15/realistic-sample-data-with-genfu.aspx
alias: /realistic-sample-data-with-genfu/
---

Last week, I had the opportunity to spend some time hacking with my good friend [James Chambers][1]. One of the projects we worked on is his brainchild: [GenFu][2]

> GenFu is a test and prototype data generation library for .NET apps. It understands different topics – such as "contact details" or "blog posts" and uses that understanding to populate commonly named properties using reflection and an internal database of values or randomly created data.

As a quick sample, I attempted to replace the Sample Data Generator in the ASP.NET5 Music Store app with GenFu. With the right GenFu configuration, it worked like magic and I was able to remove over 700 lines of code!

As part of that process, it became clear that our documentation related to configuring more complex scenarios was slightly lacking. We are working on creating official project documentation. In the mean time, this post can serve as the unofficial documentation for GenFu.

## Installing GenFu

GenFu is available via [NuGet][3] and can be added to any .NET 4.5, 4.6, or aspnet5 project.

> Install-Package GenFu

## Basic Usage

Let's say you have a simple Contact class as follows:

{% codeblock lang:csharp %}
public class Contact
{
    public int Id { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string EmailAdress { get; set; }
    public string PhoneNumber { get; set; }
    public override string ToString()
    {
        return $"{Id}: {FirstName} {LastName} - {EmailAdress} - {PhoneNumber}";
    }
}
{% endcodeblock %}

To generate a list of random people using the GenFu defaults, simply call the `A.ListOf` method:

{% codeblock lang:csharp %}
var people = A.ListOf<Contact>();
foreach (var person in people)
{
    Console.WriteLine(person.ToString());
}
{% endcodeblock %}

This simple console app will output the following:

![image][4]

That was easy, and the data generally looks pretty realistic. The default is to generate 25 objects. If you want more (or less), you can use an overload of the `ListOf` method to specify the number of objects you want. Okay, but what if the defaults aren't exactly what you wanted? That's where GenFu property filler configuration comes in.

## Configuring Property Fillers

GenFu has a fluent API that lets you configure exactly how your object's properties should be filled.

### Manually Overriding Property Fillers

Let's start with a very simple example. In the example above, the Id is populated with random values. That behaviour might be fine for you, but if you are using GenFu to generate random data to seed a database this will probably cause problems. In this case we would want the Id property to be always set to 0 so the database can automatically generate unique ids.

{% codeblock lang:csharp %}
A.Configure<Contact>()
            .Fill(c => c.Id, 0);

var people = A.ListOf<Contact>();
{% endcodeblock %}

Now all the Ids are 0 and the objects would be safe to save to a database:

![image][5]

Another option is to use a method to fill a property. This can be a delegate or any other method that returns the correct type for the property you are configuring:

{% codeblock lang:csharp %}
var i = 1;

A.Configure<Contact>()
            .Fill(c =>; c.Id, () => { return i++; });
{% endcodeblock %}

With that simple change, we now have sequential ids. Magic!

![image][6]

There is also an option that allows you to configure a property based on other properties of the object. For example, if you wanted to create an email address that matched the first name/last name you could do the following. _Also, notice how you can chain together multiple property configurations_.

{% codeblock lang:csharp %}
A.Configure<Contact>()
            .Fill(c => c.Id, 0)
            .Fill(c => c.EmailAdress,
                c => { return string.Format("{0}.{1}@zombo.com", c.FirstName, c.LastName); });
{% endcodeblock %}

This can be simplified greatly by using string interpolation in C#6.

{% codeblock lang:csharp %}
A.Configure<Contact>()
            .Fill(c => c.Id, 0)
            .Fill(c => c.EmailAdress,
                  c => $"{c.FirstName}.{c.LastName}@zombo.com");
{% endcodeblock %}

![image][7]

### Property Filler Extension Methods

In some cases, you might want to give GenFu hints about how to fill a property. For this there is a set of _With*_ and _As*_ extension methods available. For example, if you wanted an integer property to be filled with values within a particular range:

{% codeblock lang:csharp %}
A.Configure<Contact>()
            .Fill(c => c.Age).WithinRange(18, 67);
{% endcodeblock %}

IntelliSense will show you the list of available extensions based on the type of the property you are configuring.

![image][8]
_IntelliSense showing extensions for a String property_

Extensions are available for String, DateTime, Integer, Short, Decimal, Float and Double types.

### WithRandom

In some situations, you might want to fill a property with a random value from a given list of values. A simple example of this might be a boolean value where you want approximately 2/3rds of the values to be true and 1/3 to be false. You could accomplish this using the WithRandom extension as follows:

{% codeblock lang:csharp %}
A.Configure<Contact>()
            .Fill(c => c.IsRegistered)
            .WithRandom(new bool[] { true, true, false });
{% endcodeblock %}

The `WithRandom` method is also useful for wiring up object graphs. Imagine the following model classes:

{% codeblock lang:csharp %}
public class IncidentReport
{
    public int Id { get; set; }
    public string Description { get; set; }
    public DateTime ReportedOn { get; set; }
    public Contact ReportedBy { get; set; }
}

public class Contact
{
    public int Id { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string EmailAdress { get; set; }
    public string PhoneNumber { get; set; }
}
{% endcodeblock %}

We could use GenFu to generate 1,000 IncidentReports that were reported by 100 different Contacts as follows:

{% codeblock lang:csharp %}
var contacts = A.ListOf<Contact>(100);

A.Configure<IncidentReport>()
            .Fill(r => r.ReportedBy)
            .WithRandom(contacts);

var incidentReports = A.ListOf<IncidentReport>(1000);
{% endcodeblock %}


## Wrapping it up

That covers the basics and you are now on your way to becoming a GenFu master. In a future post we will cover how to extend GenFu by writing your own re-usable property fillers. In the mean time, give GenFu a try and let us know what you think.

[1]: http://jameschambers.com/
[2]: http://genfu.io/
[3]: http://nuget.org/packages/GenFu
[4]: http://www.davepaquette.com/wp-content/uploads/2015/11/image_thumb.png "image"
[5]: http://www.davepaquette.com/wp-content/uploads/2015/11/image_thumb1.png "image"
[6]: http://www.davepaquette.com/wp-content/uploads/2015/11/image_thumb2.png "image"
[7]: http://www.davepaquette.com/wp-content/uploads/2015/11/image_thumb3.png "image"
[8]: http://www.davepaquette.com/wp-content/uploads/2015/11/image_thumb4.png "image"
