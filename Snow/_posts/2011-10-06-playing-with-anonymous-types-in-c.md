---
layout: post
title: Playing with anonymous types in C#
date: 2011-10-06 21:10
author: fekberg
comments: true
metadescription: Playing with anonymous types in C#
categories: .NET, C#, Programming
tags: csharp, csharp 4, dotnet, dynamic, dynamic programming
---
In C# 3.0 something called anonymous types was introduced, this means that a certain context can have a type that is not defined anywhere except in that context. This has been seen a lot in LINQ-queries over the years. Here's an example of an anonymous type:

	var person = new { Name = "Filip" };

<!--excerpt-->
If we hover the person-variable we should see something like this show up:

<img src="http://cdn.filipekberg.se/fekberg-blog/playing-with-anonymous-types-in-c/anonymous_types.png" alt="" />

Having this anonymous type in our context means that we could write `person.Name` to get the value of the Name variable. One thing that is important when talking about anonymous types is that the variables are read only, which means that you cannot change Name after you've initialized the anonymous type.

I mentioned before that this has been seen a lot when using LINQ you might have seen code like this:

	var persons = from person in context.Persons
    	          select new { Name = person.Name, Age = person.Age };

This would as you might imagine give us a list of anonymous types where each type has a Name and Age property.

All this is pretty neat itself, but what happens when you want to use the anonymous type outside the context of where it was created and still maintain accessibility? The answer to this was introduced in .NET 4.0.

<strong><em>And the answer is dynamic!</em></strong>

Before we dig into what dynamic will help us with here, let's take a look at how we can return an anonymous type from a method without the use of dynamic. Consider the following method:

	object GetAnonymousType()
	{
	    var person = new { Name = "Filip" };
	    return person;
	}

If I call this like this:

	var person = GetAnonymousType();

Will I be able to do `person.Name`?

The answer is:<strong> No.</strong> ( <a href="http://tomasp.net/blog/cannot-return-anonymous-type-from-method.aspx">here's a trick you can use though.</a> )

But if we debug the application and hover the person-variable, we will see this:

<img src="http://cdn.filipekberg.se/fekberg-blog/playing-with-anonymous-types-in-c/anonymous_type_hover.png" alt="" />

This is quite irritating, right? There's a fun way to actually get the property value and that is by using reflection like this:

	var person = GetAnonymousType();
	var properties = person.GetType().GetProperties();
	var name = properties.First(x => x.Name == "Name").GetValue(person);

This will actually give us what we want, but hey, this is quite ugly right? I am all about readable and clean code, now I am not telling you to pass around anonymous types everywhere, but now and then it can actually be usefull.

There's actually just One thing that I need to change in the above code, and that is to set the return type to dynamic instead of object, like this:

	dynamic GetAnonymousType()
	{
	    var person = new { Name = "Filip" };
	    return person;
	}

I can now use this and successfully retreive my properties on this object:

	var person = GetAnonymousType();
	Console.WriteLine(person.Name);

This is what I call simple and readable code! Instead of having to add a new class, add each of the properties in the anonymous type to the new class and so forth, you can just use dynamic to get the stuff to work as you imagine it should!

However, even if we return it as a dynamic type, the properties are still read only!

I hope you found this interesting and if you have any thoughts please leave a comment below!
