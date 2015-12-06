---
layout: post
title:  Casting in Telerik Reports
date: 2015-08-02T11:03:21+02:00
categories:
comments: true
authorId: simon_timms
originalurl: http://blog.simontimms.com/2015/07/30/casting-in-telerik-reports/
---

Short post as I couldn't find this documented anywhere. But if you need to cast a value inside the expression editor inside a Telerik Report then you can use the conversion functions

* CBool
* CDate
* CDbl
* CInt
* CStr

I used it to cast the denominator here to get a percentage complete:

![](http://imgur.com/LE1hUUP.png)

I also used the Format function to format it as a percentage. I believe the Format string here is passed directly into .net's string format function so anything that works there will work here.