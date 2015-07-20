---
layout: post
title:  Extracting a Service to Interact With Azure Table Storage
date: 2015-07-20T12:06:03-04:00
categories:
comments: true
author: james_chambers
originalurl: http://jameschambers.com/2015/07/day-3-extracting-a-service-to-interact-with-azure-table-storage/
---

_In [this series][1] we are looking at the basic mechanics of interacting with cloud-based Table Storage from an MVC 5 Application, using the Visual Studio 2013 IDE and Microsoft Azure infrastructure._

Our controllers are not supposed to be about anything more than getting models together so that our views have something to present. When we start mixing concerns, our application starts to become very difficult to test, controllers start getting quite complex and the difficulty in maintaining our application can skyrocket.

Let's avoid that.

> If you want to follow along, please [pop into Azure][2] and make sure you've got an account ready to go. The trial is free, so get at it!

## Defining Our Service

Let's look at the operations we're going to need, from what we've already implemented, and knowing what we're planning from [our outline][1]:

* Insert a record
* Get a filtered set of records
* Update a record
* Deleting a record

Cool beans. At first blush it seems like we've got a pretty simple set of concerns, but notice that I didn't include things like "connecting to Azure", "creating table references" or "reading configuration information", as those are all separate concerns that our controller doesn't actually care about.  Remember, we're trying to isolate our concerns.

Hrm…so, manipulating records, adding, deleting, filtering, separating concerns from our business logic…this is starting to sound familiar, right? 

> Use a **repository** to separate the logic that retrieves the data and maps it to the entity model from the business logic that acts on the model. The business logic should be agnostic to the type of data that comprises the data source layer. Source: [MSDN][3].

So, we're going to want to build something using the repository pattern. We'll use that repository here in our application's controllers, but in a larger project you might go even further to have an application services layer where you map between the domain models and the view models that we have in our views. All in, our interface might look like the following:

{% highlight c# %}
public interface ITableStorageRepository where T : TableEntity
{
    void Insert(T entity);
    void Update(T entity);
    void Delete(T entity);
    IEnumerable GetByPartition(string partitionKey);
}
{% endhighlight %}

The public interface simply gives us a way to do our CRUD operations and treat a filtered result set [as a collection][4] in order to minimize duplicate constructs and operations related to table queries. You can think of the CloudTableClient and TableQueries from the Azure SDK as part of a [Data Mapper][5] layer that enables us to build this abstraction.

> Note: For the purpose of illustration, I'm going to continue to use TableEntity here, which doesn't completely abstract the Azure Table Storage concern away from my controller. I understand that; in a real-world scenario, I would typically have a view model that is used in the MVC application and an intermediary service would handle mapping as required.

## Implementing the Service

Leveraging this is going to be awesome, but we need to move some of the heavy-lifting out of our controller first.  Let's start by creating a Repositories folder and adding a class called KittehRepository, which will of course implement ITableStorageRepository.

**Don't peek!** As an exercise for the reader, you can use the interface noted above to implement the class. Use the interface above to craft your KittehRepository class. You should be able to find all the bits you need by exploring the objects already in use in the controller.

When you're ready, here's my version of the solution below:

{% highlight c# %}
public class KittehRepository : ITableStorageRepository
{
    private readonly CloudTableClient _client;

    public KittehRepository()
    {
        var storageAccount = CloudStorageAccount.Parse(CloudConfigurationManager.GetSetting("StorageConnectionString"));
        _client = storageAccount.CreateCloudTableClient();
    }

    public void Insert(KittehEntity entity)
    {
        var kittehTable = _client.GetTableReference("PicturesOfKittehs");
        var insert = TableOperation.Insert(entity);
        kittehTable.Execute(insert);
    }

    public void Update(KittehEntity entity)
    {
        var kittehTable = _client.GetTableReference("PicturesOfKittehs");
        var insert = TableOperation.Replace(entity);
        kittehTable.Execute(insert);
    }

    public void Delete(KittehEntity entity)
    {
        var kittehTable = _client.GetTableReference("PicturesOfKittehs");
        var insert = TableOperation.Delete(entity);
        kittehTable.Execute(insert);
    }

    public IEnumerable GetByPartition(string partitionKey)
    {
        var kittehTable = _client.GetTableReference("PicturesOfKittehs");
        var kittehQuery = new TableQuery()
                        .Where(TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, partitionKey));
        var kittehs = kittehTable.ExecuteQuery(kittehQuery).ToList();

        return kittehs;
    }
}
{% endhighlight %}

One thing to note is that I've pushed _most_ of the initialization up to the constructor, and I've not implemented any kind of seeding code. The table seeding that I illustrated in [Day 1][6] is a concern that should be implemented outside of a repository, likely as part of a process that starts up the application in first-run scenarios, or something that would be run as part of a deployment to a test/QA environment.

## Cleaning up Our Controller

I love this. The controller can now do what we need it to do. Here's the complete class, with an added constructor that accepts a reference to the repository (we'll wire that up shortly):

{% highlight c# %}
public class HomeController : Controller
{
    private readonly ITableStorageRepository _kittehRepository;

    public HomeController(ITableStorageRepository kittehRepository)
    {
        _kittehRepository = kittehRepository;
    }

    public ActionResult Index()
    {
        var kittehs = _kittehRepository.GetByPartition("FunnyKittehs");
        return View(kittehs);
    }

    [HttpPost]
    public ActionResult Index(KittehEntity entity)
    {
        _kittehRepository.Insert(entity);
        return RedirectToAction("Index");
    }

    public ActionResult About()
    {
        ViewBag.Message = "Your application description page.";

        return View();
    }

    public ActionResult Contact()
    {
        ViewBag.Message = "Your contact page.";

        return View();
    }
}
{% endhighlight %}

Notice how we've reduce the amount of code in this class _significantly_, to the point that anyone should be able to read it – with little or no exposure to Azure Table Storage – and still have a sense of what's going on. We've taken our controller from over 50 lines of code (non-cruft/whitespace) to about 5.

Just to see how much more clear we've made things, do a "remove and sort" on your usings. You'll notice that everything to do with Azure has all but disappeared; our repository has served it's purpose!

Okay, so the repository is in place, and our controller is dramatically simplified. Now we need to do a bit of wiring to let the MVC Framework know that we'd like an instance of the class when the controller fires up. Here's how.

## Adding Dependency Injection

First, open the Package Manager Console (View –> Other Windows –> Package Manager Console) and type the following:

    install-package Ninject.MVC5

The Ninject packages required for interoperation with the MVC Framework are installed, and you get a new class in _AppStart called NinjectWebCommon. This class contains an assembly-level attribute that allows it to properly wire dependency injection up in your application at startup, you'll see this at the top of the file.

What happens now is quite interesting: when the MVC Framework tries to create an instance of a controller (i.e., when someone makes a request to your application), it looks for a constructor with no parameters. This no longer exists on our controller because we require the ITableStorageRepository parameter.  Ninject will now step in for us and say, "Oh, you want something that looks like that? Here's one I made for you!"

To get that kind of injection love, you need to go into the NinjectWebCommon class and update the RegisterServices method to include this line of code:

    kernel.Bind>().To();

This simply says, "When someone asks for that interface, give them this concrete class.

So at this point, the wiring is done, and you can run your app! It will have the exact same functionality and user experience, but it will be much more technically sound.

## Notes and Improvements

Just a few things to note:

* I've kept things simple and omitted ViewModels
* You'd likely want to have a layer between your controller and repository class in most real-word scenarios
* The repository class should have it's dependencies injected as well, namely, the configuration information it needs to connect to Azure. A proper configuration helper class would do the trick and, once registered with Ninject, could also be accepted as a parameter on the constructor

## Summary

With the repository in place we can now lighten the load on the controller and more easily implement features with our concerns more clearly separated. In the next couple of posts, we're going to start allowing the user to manipulate the entities in the table.

Happy coding! ![Smile][7]

[1]: http://jameschambers.com/2015/01/day-0-8-days-of-working-with-azure-table-storage-from-asp-net-mvc-5/
[2]: http://www.microsoft.com/click/services/Redirect2.ashx?CR_CC=200575119
[3]: https://msdn.microsoft.com/en-us/library/ff649690.aspx
[4]: http://martinfowler.com/eaaCatalog/repository.html
[5]: http://martinfowler.com/eaaCatalog/dataMapper.html
[6]: http://jameschambers.com/2015/01/day-1-the-basics-of-the-basics-with-azure-table-storage/
[7]: http://jameschambers.com/wp-content/uploads/2015/07/wlEmoticon-smile.png
  