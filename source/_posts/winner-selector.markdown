---
layout: post
title:  Winner Selector
date: 2015-10-03T10:53:29-06:00
categories:
excerpt: A quick tool for picking winners from a list
comments: true
authorId: simon_timms
alias: /winner-selector/
---

We constantly run into the problem of drawing winners for events. It is silly because it is such an easy problem and yet every time I'm left stumbling for a solution. Here is a really simple one:

Simply paste in a list of people, one per line and hit pick a winner. 
<textarea id="sourceNames" rows="20"></textarea>
<span id="foundPeople"></span>
<button id="winnerPicker">Pick a winner from the list</button>

We welcome code audits of this page: simply check out the source to see how it works. [Source on github](https://raw.githubusercontent.com/westerndevs/western-devs-website/source/_posts/2015-10-03-winner-selector.markdown)

<script>

window.onload = function(){
	document.querySelector("#winnerPicker").addEventListener("click", showWinner);
	document.querySelector("#sourceNames").addEventListener("change", countPeople);
	}
	
function countPeople(){
	var names = document.querySelector("#sourceNames").value.split("\n");
	document.querySelector("#foundPeople").innerHTML = "Found " + names.length+ " people in the list";
}	
function showWinner(){
	var names = document.querySelector("#sourceNames").value.split("\n");
	var rand = Math.floor(Math.random() * 10000)%names.length;
	alert("The winner is: " + names[rand]);
}

</script>