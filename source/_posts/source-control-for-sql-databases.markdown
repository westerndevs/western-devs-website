---
layout: post
title:  Source Control for SQL Databases
date: 2015-11-18T20:40:31-07:00
comments: true
authorId: simon_timms
excerpt: "There are a bunch of options for migrating database schema, how can you be sure you've picked the right one?"
originalurl:
alias: /source-control-for-sql-databases/
---

Discussion on the Western Devs slack channel today turned to how to manage the lifecycle of databases. This is something we've discussed in the past and today's rehash was brought to us by [D'Arcy](http://www.westerndevs.com/bios/darcy_lussier/) asking an innocent question about Entity Framework. As seems to happen on slack instead of helping five people immediately told him how wrong he was to be using EF in that way in the first place (we helped him later).  Database migrations are a hot topic and there are a lot of options in the space so I thought I'd put together a little flow chart to help people decide which option is the best for their scenario. 

Let's start by looking at the options. 

1. Explicit migrations in code
2. Explicit migrations in SQL
3. Desired state migrations

What's all this mean? First let's look at explicit migrations vs desired state. In explicit migration we write out what changes we want to make to the database. So if you want to add a new column to a table then you would actually write out some form of `please add column address to the users table it is a varchar of size 50`.  These migrations stack up on each other. This means that after a few weeks of development you might have a dozen or more files with update instructions. It is very important that once you've checked in one of these migrations that you don't ever change it. Migrations are immutable. If you change your mind or make a mistake then you correct it by adding another migration. 

```
migration 1: add column addresss
//oh drat, spelled that wrong
migration 2: rename column addresss to address
```

The reason for this is that you never know when your database is going to be deployed to an environment. Typically the tools in this space keep track of the migrations which have been applied to a database. If you change a migration which has been applied then they have no way to correct the database and the migration will fail. Best not to get yourself into that situation. 

With migrations you can get yourself into a mess of migrations. A project that lasts a couple of years may acquire hundreds or even thousands of migrations. For the most part this doesn't matter because the files should never change however it can slow down deployments a bit. If it does bug you and you are certain that all your database instances in the wild are current up to a certain migration then you can build a checkpoint. You would take an image of the database or generate the schema and check that in. Now you can delete all the migrations up to that point and start fresh. 

These migrations can be created in code using something like entity framework migrations or using a tool like [Fluent Migrator](https://github.com/schambers/fluentmigrator) - that's option #1. Option #2 is to keep all the migrations in SQL and use something like [Roundhouse](https://github.com/chucknorris/roundhouse). Option #1 is easier to integrate with your existing ORM and you might even be able to generate some of the migrations though tools like EF's add migration which compares the previous state of your model with the new state and builds migrations (this is starting to blur the lines between options #1 and #3). However it is further away from pure SQL which a lot of people are more comfortable with. I have also found in the past that EF is easily confused by multiple people on a project building migrations at the same time. Explicit SQL migrations are a bit more work but can be cleaner. 

The final option is to use a desired state migration tool. These tools look at the current state of the database and compare them with your desired state then perform whatever operations are necessary to take current to desired. You might have seen desired state configuration in other places like [puppet](https://puppetlabs.com/) or [Powershell DSC](https://technet.microsoft.com/en-us/library/dn249912.aspx) and this is pretty much the same idea. These tools are nice because you don't have to care about the current state of the database. If it is possible the tool will migrate the database. Instead of specifying what you want to change you just update the model and the desired state tooling will calculate the change. These tools tend to fall down when you have to make changes to the data in the database - they are very focused on structural changes. 

We've now looked at all the options so which one should you pick? There is never going to be a 100% right answer here (unless your boss happens to be in love with one of the solutions and will fire you if you pick a different one) but there are some indicators that might point you in the right direction. 

1. Is your product one which has a single database instance? An example of this might be most internal corporate apps. There is only one instance and only likely to be one instance. If so then you could use any migration tool. If not then the fact that you can't properly manage multiple data migrations with SQL Server Database Projects preclude it. Code based migrations would work but tend to be a bit more difficult to set up than using pure SQL migrations. 

2. Do you need to create a bunch of seed data or default values? Again you might want to stay away from desired state because it is harder to get the data in. Either of the explicit migration approaches would be better. 

3. Is this an existing database which isn't under source control? SQL server database projects are great for this scenario. They will create a full schema from the database and properly organize it into folders. Then you can easily jump into maintaining and updating the database without a whole lot of work. 

4. Are there multiple slightly different versions of the database in the wild? Desired state is perfect for this. You don't need to figure out a bunch of manual migrations to set a baseline. 

5. Are you already using EF and have a small team unlikely to step on each other's toes? Then straight up EF migrations could be your best bet. You don't have to introduce another technology or tool. (I should mention here that you can use EF's automatic migrations to act in the same way as a desired state configuration tool so consider that. Generally the EF experts recommend against doing that in favour of explict migrations)

6. Do you have a team that is very strong in SQL but not modern ORMs? Ah then SQL based migrations are likely you friend. A well-versed team may have already created a version of this. Switch to roundhouse, it will save you time in the long run. 

I hope that these will give you a little guidance as to which tool will work best for your project. I'm sure there are all sorts of other questions one might ask to give a hint as to which technique should be used. Please do comment on this post and I'll update it. 


![http://imgur.com/SlfjxSE](http://imgur.com/SlfjxSE.png)
![http://imgur.com/Kq0UvYt](http://imgur.com/Kq0UvYt.png)
![http://imgur.com/yNcJdl9](http://imgur.com/yNcJdl9.png)