---
layout: post
title:  Unit Conversions Done (Mostly) Right
date: 2015-07-22T14:30:30-06:00
categories:
excerpt: Thanks to a certain country which, for the purposes of this blog let's call it Backwardlandia, which uses a different unit system there is frequently a need to use two wildly different units for some value. And they have so many people and so much money that we can't ignore them.
comments: true
authorId: simon_timms
originalurl: http://blog.simontimms.com/2015/07/22/unit_convesions/
---

Thanks to a certain country which, for the purposes of this blog let's call it Backwardlandia, which uses a different unit system there is frequently a need to use two wildly different units for some value. Temperature is a classic one, it could be represented in Centigrade, Fahrenheit or Kelvin Rankine (that's the absolute temperature scale, same as Kelvin, but using Fahrenheit). Centigrade is a great, well devised unit that is based on the freezing and boiling points of water at one standard atmosphere. Fahrenheit is a temperature system based on the number of pigs heads you can fit in a copper kettle sold by some bloke on Fleet Street in 1832. Basically it is a disaster. Nonetheless Backwardlandia needs it and they have so many people and so much money that we can't ignore them. 

<!--more-->

I cannot count the number of terrible approaches there are to doing unit conversions. Even the [real pros](http://www.cnn.com/TECH/space/9909/30/mars.metric.02/) get it wrong from time to time. I spent a pretty good amount of time working with a system that put unit conversions in between the database and the data layer in the stored procedures. The issue with that was that it wasn't easily testable and it meant that directly querying the table could yield you units in either metric or imperial. You needed to explore the stored procedures to have any idea what units were being used. It also meant that any other system that wanted to use this database had to be aware of the, possibly irregular, units used within. 

Moving the logic a layer away from the database puts it in the data retrieval logic. There could be a worse place for it but it does mean that all of your functions need to have the unit system in which they are currently operating passed into them. Your nice clean database retrievals become polluted with knowing about the units. 

It would likely end up looking something like this:

{% codeblock lang:csharp %}
public IEnumerable<Pipes> GetPipesForWell(int wellId, UnitSystem unitSystem)
{
    using(var connection = GetConnection()){
    	var result = connection.Query<Pipes>("select id, boreDiameter from pipes where wellId=@wellId", new { wellId});
        return NormalizeForUnits(result, unitSystem);
    }
}
{% endcodeblock %}

I've abstracted away some of the complexity with a magic function that accounts for the units and it is still a complex mess. 

##A View Level Concern
I believe that unit conversion should be treated as a view level concern. This means that we delay doing unit conversions until the very last second. By doing this we don't have to pass down the current unit information to some layer deep in our application. All the data is persisted in a known unit system(I recommend metric) and we never have any confusion about what the units are. This is the exact same approach I suggest for dealing with times and time zones. Everything that touches my database or any persistent store is in a common time zone, specifically UTC. 

If you want to feel extra confident then stop treating your numbers as primitives and treat them as a value and a unit.  Just by having the name of the type contain the unit system you'll make future developers, including yourself, think twice about what unit system they're using.

{% codeblock lang:csharp %}
public class TemperatureInCentigrade{
	private readonly double _value;
	public TemperatureInCentigrade(double value){
    	_value = value;
    }
    
    public TemperatureInCentigrade Add(TemperatureInCentigrade toAdd) 
    {
    	return new TemperatureInCentigrade(_value + toAdd.AsNumeric());
    }
}
{% endcodeblock %}

You'll also notice in this class that I've made the value immutable. By doing so we save ourselves from a whole bunch of potential bugs. This is the same approach that functional programming languages take. 

Having a complex type keep track of your units also protects you from taking illogical actions. For instance consider a unit that holds a distance in meters. The ```DistanceInMeters``` class would likely not contains a ```Multiply``` function or, if it did, the function would return ```AreaInSquareMeters```. The compiler would protect you from making a lot of mistakes and this sort of thing would likely eliminate a bunch of manual testing. 

The actual act of converting units is pretty simple and there are numerous libraries out there which can do a very effective job for us. I am personally a big fan of the [js-quantities library](https://github.com/gentooboontoo/js-quantities). This lets you push your unit conversions all the way down to the browser. Of course math in JavaScript can, from time to time, be flaky. For the vast majority of non-scientific applications the level of resolution that JavaScripts native math supports is wholly sufficient. You generally don't even need to worry about it.

If you're not doing a lot of your rendering in JavaScript then there are libraries for .net which can handle unit conversions (disclaimer, I stole this list from the github page for QuantityType and haven't tried them all). 

- [Quantity Types](https://github.com/objorke/QuantityTypes)
- [CSUnits](https://github.com/cureos/csunits)
- [NGenericDimensions](https://ngenericdimensions.codeplex.com/)
- [quantities.net](http://sourceforge.net/projects/quantitiesnet/)
- [unitcon](http://sourceforge.net/projects/unitcon/)
- [units](http://www.gnu.org/software/units/)
- [Measurement Unit Conversion Library](http://www.codeproject.com/Articles/23087/Measurement-Unit-Conversion-Library)
- [Units of Measure Library](http://www.codeproject.com/Articles/404573/Units-of-Measure-Library-for-NET)
- [Units of Measure Validator for C#](http://www.codeproject.com/Articles/413750/Units-of-Measure-Validator-for-Csharp)
- [Working with Units and Amounts](http://www.codeproject.com/Articles/611731/Working-with-Units-and-Amounts)
- [Units.NET](https://github.com/InitialForce/UnitsNet)
- [Gu.Units](https://github.com/JohanLarsson/Gu.Units)
- [Unit Class Library](https://bitbucket.org/Clearspan/unit-class-library/wiki/Home)

Otherwise this might be a fine time to try out F# which supports units of measure [natively](https://msdn.microsoft.com/en-us/library/dd233243.aspx).

The long and short of it is that we're trying to remove unit system confusion from our application and to do that we want to expose as little of the application to divergent units as possible. Catch the units as they are entered, normalize them and then pass them on to the rest of your code. You'll save yourself a lot of headaches by taking this approach, trust a person who has done it wrong many times.
