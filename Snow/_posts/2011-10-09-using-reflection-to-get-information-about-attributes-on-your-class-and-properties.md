---
layout: post
title: Using reflection to get information about attributes on your class and properties
date: 2011-10-09 23:23
author: fekberg
comments: true
metadescription: Using reflection to get information about attributes on your class and properties
categories: .NET, C#, Programming
tags: csharp, dotnet, reflection
---
In the previous post I focused on getting values from an instance and getting information about the class itself. In this post I want to focus on getting even more information about the class and the properties in it, I want to get information about the attributes that I using!

To get information about attributes either on a class or on a property you do this by invoking methods on the <a href="http://msdn.microsoft.com/en-us/library/system.attribute.aspx">Attribute</a> class, these methods are static so you won't need an instance of the <a href="http://msdn.microsoft.com/en-us/library/system.attribute.aspx">Attribute</a> class.<!--excerpt-->

There is just one method that we need to use in order to get information about the attributes on the properties and on the class itself, this method being:

	GetCustomAttributes(MemberInfo)

Both `Type` and `PropertyInfo` both derive from `MemberInfo` so we can use the same override of `GetCustomAttributes`.

Let's use an edited version of the person class from the previous post!

	[Serializable]
	class Person
	{
	    [XmlElement("PersonName")]
	    public string Name { get; set; }
	    [XmlElement("Age")]
	    public int Age { get; set; }
	}

Now in order to get the information about the attributes on our Person-class, we need to do the following:

	var personType = typeof (Person);
	var classAttributes = Attribute.GetCustomAttributes(personType);

This will give me an array of <a href="http://msdn.microsoft.com/en-us/library/system.attribute.aspx">Attribute</a>! So how do we get information about each properties attributes?

We need to iterate over each property and get the attributes on one property at a time! To get all properties we use the method `GetProperties()` and this gives us an `IEnumerable<PropertyInfo>`.

The `PropertyInfo` instance will let us get information about the value of the property on an instance, it will let us set the property value on an instance and it will let us do all kinds of useful things! In this case though, we are interested on just using the `PropertyInfo` instance to get information about the attributes that it has on it.

To do this we can use `Attribute.GetCustomAttributes()` as we did before! Here's how I did it:

	foreach (var property in personType.GetProperties())
	{
	    var propertyAttributes = Attribute.GetCustomAttributes(property);
	}

In each iteration here, we will get a list of attributes on the property, in this case it will only have attribute information regarding the <a href="http://msdn.microsoft.com/en-us/library/system.xml.serialization.xmlelementattribute.aspx">XmlElementAttribute</a>.

You can do a lot of powerful things with reflection, we've looked at getting information about classes that we've written ourselves, but imagine this being inside an assembly which you don't have the source to and your code is behaving unexpectedly.

I also hope you found this interesting and if you have any thoughts please leave a comment below!
