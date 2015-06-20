---
layout: page
title: Where We'll Be
permalink: /wherewellbe/
---

Here is a list of upcoming events where you can see some of us speak:

<ul class="events">
{% for event in site.data.conferences %}
  <li class="event">
    <p>
      <div class='date'>
        <div class='month'>{{event.date | date: '%B'}}</div>
        <div class='year' >{{event.date | date: '%Y'}}</div>
      </div>
      <div class='event'><a href="{{event.link}}">{{event.event}}</a></div>
    </p>
    <p>{{event.topic}} by {{event.speaker}}</p>
    <p>{{event.location}}
  </li>
{% endfor %}
</ul>
