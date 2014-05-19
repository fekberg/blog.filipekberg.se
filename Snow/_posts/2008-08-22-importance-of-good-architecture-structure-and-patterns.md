---
layout: post
title: Importance of good Architecture, Structure and Patterns
date: 2008-08-22 21:54
author: fekberg
comments: true
metadescription: Understand the importance of good architecture, structure and patterns
categories: Architecture
tags: programming architecture
---
Often when developing software such as websites, windows ( or any other operative system for that matter ) programs, the begining of the progress is quite simple; you have your ideas and may have some thoughts about how to implement everything. But what often is forgot when developing software is the importance of thinking ahead, thus, planning for a larger software that you have in mind.<!--excerpt-->

For an example, when i started developing SmartIT Invoice i thought of it as a software that would generally help me organize my small amount of invoices. But as the years pass my company grows bigger and bigger and once im up to n-numbers of invoices, a simple List View won't be sufficient. Therefore after implementing my Invoice software, i started thinking about how i could change everything and structure the code for helping me in the future. I had in mind that i might not always want to use the Windows Graphical Interface for input and output so as i always do, i seperate the Design code from the Logical Code. This meaning that my application has three layers. Them being:
<ul>
	<li>Application Layer, code for display, handling window events</li>
	<li>Logic data layer, database connections, objects</li>
	<li>Data layer, this being the database with functions, views and procedures</li>
</ul>
By having these three layers i can easily change one of the layers without changing the next. Of course this is not entierly true, i would have to change some parts in the Logic Data Layer if i changed the DBMS.  I would however not have to change that much if i just changed the behaviour of a Stored procedure.

Again takng my Invoice softwre as an example, i recently released a software called Webexpress.nu which allows customers to create their own website and for this i need somewhat of a payment system. Of course using Credit card payments is nice and easy but not entierly nessesary. So by just adapting my Webste to the current Logic Data Layer of my SmartIT Invoice software, i could easily get an intergration that allowed me to create customer invoices that pops up on the user account, when they are online on the page of course and even directly to my software, withouth any adjustments in the Data Layer or in my Windows Software.

This proves the point that well structured code and seperate layers will help you along the way of program development.

As a side note the Data Layer in this case is a Windows DLL with .NET 3.5 code which makes it even easier to implement when the website itself is asp.net with .net 3.5.

There are a lot of good design guidelines out there which will help you structure your software better and help you understand how to always follow a pattern. A pattern doesn't, in my point of view, have to be a pattern like Singelton etc, it can by any means be a way for yourself to regocnize your own code, thus following a pattern. Example, i often tend to use m_ before member variables and write all functions and access methods with a capital letter.

Have fun programming!
