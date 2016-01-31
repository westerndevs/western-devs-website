---
layout: post
title: "ProTip: Get a random date in SQL Server"
tags:
  - SQL Server
categories:
  - SQL Server
authorId: simon_timms
excerpt: "How to fill a table with some random dates."
---

Need to put a random date in each row of a table? Here is how to do it:

I have a table which contains a RequiredCompletionDate and I wanted to give it a random date in last year so I did


{% codeblock lang:sql %}
update systems 
   set RequiredCompletionDate = DATEADD(day, 
                                        ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) % 365, 
                                        '2015-01-01')
{% endcodeblock %}