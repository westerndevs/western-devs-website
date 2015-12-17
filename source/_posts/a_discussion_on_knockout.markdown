---
layout: post
title:  A discussion on knockout
date: 2015-09-10T22:26:34-06:00
categories:
comments: true
authorId: simon_timms
alias: /a_discussion_on_knockout/
---

It is rare that a day passes on the Western Devs' slack channel that we don't have some lively discussion. Today was my day to rant about knockout.js. 

If you haven't used knockout.js it is a JavaScript library used for bi-directional model binding. It was the first library of its type that I encountered, being deeply involved in the Microsoft web mentality at that point. 

My current project uses knockout.js and although we've been successful with it there has been a great deal of pain. In fact it has been so irritating that I no longer recommend using knockout to anybody working on a serious project. This may seem crazy because there are a lot of sites out there, big sites, that make use of knockout. The new Azure portal is, perhaps, the most famous of these sites.

What are my issues? Allow me to tell you: 

<ol>
	<li> The ko.observable model creates confusion between what is an observable and what isn't. There is not a day that passes that I don't mess up a binding or a piece of logic because I expect a variable to be a value and it is a function. This is because binding requires using ko.observables to actually function properly. I don't know if it is helpful that binding in either way works for basic properties.
	</li>
</ol>
{% codeblock lang:html %}
<span data-bind="someproperty"/>
​
<span data-bind="someproperty()"/>
{% endcodeblock %}

<div style="margin-left: 40px">
Once you start making more complicated bindings then you have to remeber to make the function call
</div>
{% codeblock lang:html %}
<span data-bind="someproperty() + 1"/>
​{% endcodeblock %}

<ol start="2">
<li>Observable array is missing a bunch of functions that exist on Array. I'm not talking just the new array prototype functions in ES6 but older functions like filter which have been around since 2011. This is super confusing. Why aren't the rest of the functions implemented? I'm not sure. I find the lack of filter especially irritating.</li> 

<li>The syntax around loops is messy. If you're in a foreach loop then it is really weird to get stuff from the outside</li>
</ol>

{% codeblock lang:html %}
<tbody data-bind="foreach: somecollection">
	<tr>
		<td data-bind="text: rowvalue"/>
		<td data-bind="text: $parents[0].valueFromOuterModel"/>
	</tr>
</tbody>	
​{% endcodeblock %}


<ol start="4">
<li>Binding using data- attributes encourages you to move your logic into the html code where it is all but untestable 
</li>
</ol>
{% codeblock lang:html %}
<select class="form-control" data-bind="value: item.State, 
		attr:{'name': 'StateDropdown' + rowSuffix }, 
		foreach: $parents[1].states().filter(function(item){ return item.Value() == $parents[0].State() || $parents[1].rows().map(function(row){return row.State();}).indexOf(item.Value()) < 0;}) ">
{% endcodeblock %}

<div style="margin-left: 40px">
<a href="http://www.westerndevs.com/bios/dave_white/">Dave White</a> called me to the carpet for this complaint. "Why aren't you doing your filtering in the model?" he asked. Quite right, I should be doing it in the model and I, indeed, refactored the code later to do that. The point was that because you're doing the bindings in the html it is easy to fall into the lazy trap of just leaving it. Maybe knockout shouldn't support expressions in the data-bindings. 
</div>
<ol start="5">
<li>
	<p>Knockout supports creating components but these are rendered at a non-deterministic time. This means that if you want to do something after the component has rendered you're pretty much left guessing. You can't do it right after you call the model bind because that is defered and as there is no componentHasMounted equivilent to hook into you can't do it there. If you wanted to, say, add an autocomplete to a dynamically added text box then when would you call that code? </p>
	<p>

I honestly don't know. I've tried just setting a timeout and I've also tried hooking into mutation observers. The first is hacky and the second has limited browser support. 
</p>
<p>
<b>Update:</b> Dave and I poked about a bit and there might be a solution in using synchronous components, I'll experiment and update some more. 
</p>
</li>
</ol>
<a href="http://www.westerndevs.com/bios/amir_barylko/">Amir</a> asked what I would use instead. <a href="http://facebook.github.io/react/">React</a>. Maybe <a href="http://aurelia.io/">Aurelia</a>, although I haven't explored it enough yet. 