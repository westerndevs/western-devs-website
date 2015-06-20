---
layout: page
title: Where We'll Be
permalink: /wherewellbe/
---

Western Devs are active speakers. Take a look and see if we'll be in your area.

<ul class="events">
  {% assign today = 'today' | date: "%Y-%m-%d" %}
  {% assign items = site.data.conferences  | sort: 'date' %}
  {% for event in items %}
  {% assign ed = event.date | date: "%Y-%m-%d" %}
  {% if ed >= today %}
  <li class="event">
    <div class="date">
      <div class="month">{{event.date | date: '%b'}}</div>
      <div class="year">{{event.date | date: '%Y'}}</div>
    </div>
    <div class="info">
      <div class="link">
        <span>{{event.speaker}} @ </span>
        <a href="{{event.link}}">{{event.event}}</a>
      </div>
      <div class="topic">{{event.topic}} </div>
      <div class="location">{{event.location}}</div>
    </div>
  </li>
  {% endif %}
  {% endfor %}
</ul>
