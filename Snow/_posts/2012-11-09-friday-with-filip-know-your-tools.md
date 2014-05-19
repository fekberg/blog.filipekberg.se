---
layout: post
title: Friday with Filip – Know your tools
date: 2012-11-09 11:30
author: fekberg
comments: true
metadescription: On Fridays, Filip shares interesting thoughts and experience that hopefully will lead to interesting discussions. Enjoy Friday with Filip!
categories: C#, Friday with Filip, Programming
tags: code quality, csharp, friday with filip, LINQ, LINQ to EF, LINQ to Object, quality
---
<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/FridayWithFili.png" alt="" title="Friday with Filip" style="display: block;   margin-left: auto;   margin-right: auto;" width="342" height="194" class="aligncenter size-full wp-image-1016" />

<h3>Welcome to this week's Friday with Filip!</h3>
There's a saying that goes like this:

<blockquote>Use the right tool for the right job</blockquote><!--excerpt-->

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/11/wrong_tool.jpg"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/11/wrong_tool.jpg" alt="" title="Wrong tool" height="150" style="float: right; padding-left: 20px;" class="size-thumbnail wp-image-1456" /></a>Even if you find the right tool for your job, do you know how to use the tool correctly? <br/><br/>This is exactly what I want to talk about this Friday; <em>you need to know your tools in order for you to know it's the right tool for this job!</em>

<h3>Do you know your tooling?</h3>
All too often I see developers using amazing new tools but in many cases not knowing the limits or how to use it correctly. It's very important to understand how to use a tool and what the implications of using a tool in a certain way has. When I find a new tool or a new library that I want to use, I try to research it and understand it before I recommend it for production use.

To me a tool is not only a software that I run or a hammer that I use, but I also consider a third party library a tool. A tool for me is something that I use to solve a certain problem and smaller parts can build a larger tool.

<h3>Problems with not knowing your tools</h3>
If you don't know what your tool does behind the scenes you can get very big problems in the end. If you try to use a hammer to screw something into the wall there might be an easy work around just to hammer the screw into the wall. But what if it was the other way around? 

Imagine that you had a screwdriver but a nail that you had to put into a plank; getting that into the plank would be much harder, no?

It's still possible of course to solve the problem by just using the other end of the screwdriver and hammer the nail slowly into the plank.

<em>So where am I going with this?</em>

If you use a library or software that is new and hype which solves a certain problem but makes it harder for you; <strong>maybe you're doing it wrong!</strong> The tooling might be great for solving one of the problems, but the way that you use it just gives you too much of a headache. If you go back and do some research on the tools, you might find that you are using it wrong or that the tool simply is not for the specific use case.

A good example here is <strong>LINQ to EF</strong>. I've seen many developers knowing how to use [cc lang="c#" inline="true"]LINQ[/cc] but not knowing what happens behind the scenes. This can be very dangerous for the performance of your application.

One other problem that arises with this is that most of us test our applications with very little data in it, but in a real world application after some time there might be a lot more data to process which was not considered at the beginning.

Now to be a bit more concrete, see of the following [cc lang="c#" inline="true"]LINQ[/cc] to EF query:

[cc lang="c#"]
var persons = from person in db.Persons 
              where person.Name.Contains("Filip") 
              select person;
[/cc]

This can of course be written like this as well: 

[cc lang="c#"]var persons = db.Persons.Where(person => person.Name.Contains("Filip");[/cc]

Both of these will be executed as soon as you request the result by doing [cc lang="c#" inline="true"]persons.ToList();[/cc] for instance.

This all looks very good, it might be exactly what we want to do as well. But what happens if we have 1 billion persons in our database?

The SQL query that is generated from this will perform what is called a row search, which means it does not use any indexing which means it will have to go over 1 billion persons and do a search within each person’s name.

Consider that it generated the following SQL:

[cc lang="SQL"]
select * from Persons where Name like '%Filip%';
[/cc]

Of course we can optimize this by using full text search! But that is not the point, the point is that we might not have considered that [cc lang="c#" inline="true"]Contains()[/cc] will actually be a slow operation to run. If we knew that this would skip all indexes we might had chosen to use [cc lang="c#" inline="true"]StartsWith()[/cc] instead.

Another problem with not knowing how LINQ works internally is that all too often I see developers doing [cc lang="c#" inline="true"]ToList()[/cc] just because they want to use the types in .NET instead of having it translated to SQL. If they had known of [cc lang="c#" inline="true"]EntityFunctions[/cc] or [cc lang="c#" inline="true"]SqlFunctions[/cc] they might had chosen to run the query on the database side instead of doing [cc lang="c#" inline="true"]LINQ to Object[/cc]!

Because if we perform the query below, we will actually fetch the 1 billion rows from the database and have them in memory and then perform the search in the application instead.

[cc lang="c#"]db.Persons.ToList().Where(person => person.Name.StartsWith("Filip").ToList();[/cc]

<em>Again, if we know our tooling and use the right tool for the right job, we are going to do a much better job.
</em>

<strong>Do you know your tools?</strong>
