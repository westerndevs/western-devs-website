---
title:  Choosing Power BI
# What is it? 
# Cost 
authorId: simon_timms
date: 2021-11-19
originalurl: https://blog.simontimms.com/2021/11/19/choosing-power-bi
mode: public
---



If you're a developer and you're looking for a solution for reporting in your application then Power BI might be the right choice for you. However, there are tradeoffs that are worth considering before you dig in too much. 

## What is it? 

The GitHub copilot I have running while writing this wants me to say that "Power BI is a platform for creating and managing data-driven reports. It's a powerful tool that allows you to create reports that are easy to understand and use." That sounds an awful lot like a sentence that an AI trained on Microsoft marketing data would say. It isn't entirely inaccurate. For me Power BI is a combination for two different reporting tools which are pretty different from one another. The first is the one you see in all the marketing literature: Dashboard reports. These are nifty looking reports that are largely driven by visuals like maps or charts. Users can easily drill into aspects of the data by clicking on the charts or tables to filter the data and drill in. These reports aren't great for people who like to see the underlying data and draw their own conclusions. 

The second report type is Paginated Reports. These reports are basically a complete migration of the older SQL Server Reporting Services (SSRS) reports. There is limited support for cool graphics but if you need an Excel like view of the data then they are great. I've run into a few cases in the past where I've tried to convince users that they cannot possibly want a 90 page report and that they should use the dashboard report. But frequently users do legitimately want to print 90 pages and go at the report with a highlighter. One of my favorite sayings for these situations is that as a developer I make suggestions and users make decisions.

The desktop based tools for building these reports are all pretty good. The dashboard report tool in particular is excellent. It may be that your users don't need to use online reporting and that providing them with a database connection and a copy of Power BI Desktop will be a good solution. The added advantage there is that the desktop tools are free to use. If you have a read only replica of your database then letting users develop their own reports doesn't have much of a downside other than having to support people as they learn the system. A cool idea is to build projections or views inside your database to handle the complex joins in your data and remove that burden from the users.

If you want to embed the reports in your application there is facility for doing that through a JavaScript API. You do need to jump through some hoops to authenticate and generate tokens but that's a lot easier than developing your own HTML based reports. There aren't a whole lot of examples out there for how to do embeddeding and you will need to spend some time learning the security models. 

The alternative to all this is to use one of the myriad of other reporting tools that are available. I've used Telerik Reporting quite a lot in the past and I can confidently say it is "not terrible". That's about as high of praise as you're going to get from me for a reporting tool. 

## Cost 

As with anything Microsoft the pricing for all this is convoluted and contently changing. This is my current understanding of it but  you can likely get a better deal and understanding by talking to your sales representative. 

* Power BI Desktop: Free as in beer
* Power BI Pro: Let's you run dashboard reports online and embed them in your application (note that this doesn't' let you embed paginated reports) $9.99/month a users
* Power BI Premium per user: This lets you run dashboard reports online and embed them in your application and also run paginated reprots (note I didn't say embed paginated reports) $20/month a user
* Power BI Premium per capacity: Run and embed both report types. Open for as many users as you have. $4995/month. Yikes, that price sure jumps up

Being able to embed paginated reports was the killer feature for me that took the reporting cost from very reasonable to very expensive. 
