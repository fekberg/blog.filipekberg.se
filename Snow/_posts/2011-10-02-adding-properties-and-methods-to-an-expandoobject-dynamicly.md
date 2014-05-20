---
layout: post
title: Adding properties and methods to an ExpandoObject, dynamically!
date: 2011-10-02 00:47
author: fekberg
comments: true
metadescription: Adding properties and methods to an ExpandoObject, dynamically!
categories: .NET, C#, Programming
tags: .NET, .net 4.0, csharp, csharp 4, dotnet, dynamic, dynamic programming, expandoobject
---
Meanwhile I am planning and writing manuscript and code samples for my upcoming video series that will cover "Programming fundamentals using C#", I thought it was time for a short post on some dynamic programming in C#!<!--excerpt-->

Another thing worth mentioning is that I will be using Visual Studio 11 Developer Preview, if you haven't checked it out, <a href="http://blog.filipekberg.se/2011/09/19/visual-studio-11-and-visual-studio-2010-side-by-side/">I posted a quick blog post about it running side by side with Visual Studio 2010!</a>.

So, for those that are completely new and haven't yet checked out my videos on <a href="http://blog.filipekberg.se/2011/07/21/c-4-0-using-the-dynamic-keyword/">"C# 4.0 Using the Dynamic Keyword"</a>, here's a quick summary:

<ul>
	<li>C# is not dynamically typed even though you can have dynamic types. It's a statically typed dynamic type!</li>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.dynamic.expandoobject.aspx">ExpandoObject </a>is the object that you use with the dynamic keyword(<a href="http://msdn.microsoft.com/en-us/library/the35c6y.aspx">contextual keyword</a>) in order to add properties and methods dynamically.</li>
	<li>Dynamics are evaluated at runtime</li>
</ul>

A typical dynamic setup that creates a dynamic object and adds a static amount of properties might look like this:

	dynamic person = new ExpandoObject();
	person.Name = "Filip";
	person.Age = 24;

What is interesting about the <a href="http://msdn.microsoft.com/en-us/library/system.dynamic.expandoobject.aspx">ExpandoObject </a>is that it implements the interface: `]IDictionary<string, Object>`

So what this means is that if we cast the person-object to an <a href="http://msdn.microsoft.com/en-us/library/s4ys34ea.aspx">IDictionary</a> we will be able to do some really cool stuff with it. The same code above but re-written to make use of the dictionary instead could look like this:

	dynamic person = new ExpandoObject();
	var dictionary = (IDictionary<string, object>)person;

	dictionary.Add("Name", "Filip");
	dictionary.Add("Age", 24);

Now you might ask why this would ever be useful? In fact I first encountered this when Rob Conery threw together a part of <a href="https://github.com/robconery/massive">Massive </a>on stage on the Norwegian Developers Conference this summer. In his case he wanted to create an extension for an IDataReader which would give you a List<dynamic> instead of having to fight with the IDataReader.

So to make this as dynamic as possible, all the fields from the table was read, added with their corresponding values from the IDataReader into the dictionary, which made the whole thing very dynamic. 

There are actually more ORMs(<a href="https://github.com/markrendle/Simple.Data">Simple.Data</a>) out there that uses this approach, but I will get to that later on when I'll cover DynamicObject!

This is how you add dynamic properties, but how about adding a method? It's simple!

What you do is that you add a new key to the dictionary and the object should just be an action, like this:

	dictionary.Add("Shout", new Action(() => { Console.WriteLine("Hellooo!!!"); }));

	person.Shout();

When calling the Shout-method it will print out "Hellooo!!!" in the Console.

I hope you had fun reading this and that you learned something new! Stay tuned for more posts!

