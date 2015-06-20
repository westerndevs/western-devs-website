---
layout: post
title:  "Getting lookup data into your view ASP.net MVC 6 version"
date:   2015-06-09 20:09:05
author: Simon Timms
originalurl: http://blog.simontimms.com/2015/06/09/getting-lookup-data-into-you-view
categories:
---

This is a super common problem I encounter when building ASP.net MVC applications. I have a form that has a drop down box. Not only do I need to select the correct item from the edit model to pick from the drop down but I need to populate the drop down with the possible values.

Over the years I've used two approaches to doing this. The first is to push into the ViewBag a list of values in the controller action. That looks like

    public ActionResult Edit(int id){
        var model = repository.get(id);
        ViewBag.Provinces = provincesService.List();
    
        return View(model);
    }

Then in the view you can retrieve this data and use it to populate the drop down. If you're using the HTML helpers then this looks like

    @Html.DropDownListFor(x=>x.province, (IEnumerable)ViewBag.Provinces)

This becomes somewhat messy when you have a lot of drop downs on a page. For instance consider something like

    public ActionResult Edit(int id){
      var model = repository.get(id);
    
        ViewBag.Provinces = provincesService.List();
        ViewBag.States = statesService.List();
        ViewBag.StreetDirections = streetDirectionsService.List();
        ViewBag.Countries = countriesService.List();
        ViewBag.Counties = countiesService.List();
    
        return View(model);
    }

The work of building up the data in the model becomes the primary focus of the view. We could extract it to a method but then we have to go hunting to find the different drop downs that are being populated. An approach I've taken in the past is to annotate the methods with an action filter to populate the ViewBag for me. This makes the action look like

    [ProvincesFilter]
    [StatesFilter]
    [StreetDirectionsFilter]
    [CountriesFilter]
    [CountiesFilter]
    public ActionResult Edit(int id){
      var model = repository.get(id);
      return View(model);
    }

One of the filters might look like

    public override void OnActionExecuting(ActionExecutingContext filterContext)
    {
        var countries = new List();
        if ((countries = (filterContext.HttpContext.Cache.Get(GetType().FullName) as List)) == null)
        {
            countries = countriesService.List();
        }
        filterContext.Controller.ViewBag.Countries = countries;
        base.OnActionExecuting(filterContext);
    }

This filter also adds a degree of caching to the request so that we don't have to keep bugging the database.

Keeping a lot of data in the view bag presents a lot of opportunities for error. We don't have any sort of intellisense with the dynamic view object and I frequently use the wrong name in the controller and view, by mistake. Finally building the drop down box using the HTML helper requires some nasty looking casting. Any time I cast I feel uncomfortable.

    @Html.DropDownListFor(x=>x.province, (IEnumerable)ViewBag.Provinces)

Now a lot of people prefer transferring the data as part of the model; this is the second approach. There is nothing special about this approach you just put some collections into the model.

I've always disliked this approach because it mixes the data needed for editing with the data for the drop downs which is really incidental. This data seems like a view level concern that really doesn't belong in the view model. This is a bit of a point of contention and I've challenged more than one person to a fight to the death over this very thing.

So neither option is particularly palatable. What we need is a third option and the new dependency injection capabilities of ASP.net MVC open up just such an option: we can inject the data services directly into the view. This means that we can consume the data right where we retrieve it without having to hammer it into some bloated DTO. We also don't have to worry about annotating our action or filling it with junk view specific code.

To start let's create a really simple service to return states.

    public interface IStateService
    {
        IEnumerable List();
    }
    
    public class StateService : IStateService
    {
        public IEnumerable List() {
            return new List
            {
                new State { Abbreviation = "AK", Name = "Alaska" },
                new State { Abbreviation = "AL", Name = "Alabama" }
            };
        }
    }

Umm, looks like we're down to only two states, sorry Kentucky.

Now we can add this to our container. I took a singleton approach and just registered a single instance in the Startup.cs.

    services.AddInstance(typeof(IStateService), new StateService());

This is easily added the the view by adding

    @inject ViewInjection.Services.IStateService StateService

As the first line in the file. Then the final step is to actually make use of the service to populate a drop down box:

    <div class="col-lg-12">
        @Html.DropDownList("States", StateService.List().Select(x => new SelectListItem { Text = x.Name, Value = x.Abbreviation }))
    </div>

That's it! Now we have a brand new way of getting the data we need to the view without having to clutter up our controller with anything that should be contained in the view.

What do you think? Is this a better approach? Have I brought fire down upon us all with this? Post a comment. Source is at <https://github.com/stimms/ViewInjection>