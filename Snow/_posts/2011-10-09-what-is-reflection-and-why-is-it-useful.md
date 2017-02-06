---
layout: post
title: What is reflection and why is it useful?
date: 2011-10-09 01:16
author: fekberg
comments: true
metadescription: What is Reflection in .NET?
categories: .NET, C#, Programming
tags: csharp, dotnet, reflection
---
Lately you've seen me use something called <em><a href="http://msdn.microsoft.com/en-us/library/ms173183(v=VS.100).aspx">reflection</a></em>, but what is <a href="http://msdn.microsoft.com/en-us/library/ms173183(v=VS.100).aspx">reflection</a>? If we look it up on MSDN we get a quite good answer, but to the untrained eye it might be a bit cryptic<!--excerpt-->:

<blockquote>Reflection provides objects (of type Type) that describe assemblies, modules and types. You can use reflection to dynamically create an instance of a type, bind the type to an existing object, or get the type from an existing object and invoke its methods or access its fields and properties. If you are using attributes in your code, reflection enables you to access them</blockquote>

What does this mean? First of all, let's break it down into three sections!

<strong>The first thing</strong> mentioned in the quote is that it gives us a way to get a description of something, it could be a description of an object we've instantiated based on one of our classes. Imagine that we have a class called Person and we've got an instance of it like this:

    var person = new Person();

By using reflection, we can retrieve information about the fields, methods and attributes on the person object. 

By calling `var type = person.GetType()` or `var type = typeof(Person)`, we get information regarding the type Person itself, the methods, properties and attributes defined on the class.

The `Type` object returned from`person.GetType()` or `typeof()`  is thus the object that we use in order to retrieve even more information regarding either the current instance or the class itself.

<strong>The second thing</strong> mentioned in the quote is probably the biggest topic when talking about reflection in .NET, in this post at least I won't focus on the dynamic instance creation or binding but rather how you can extract information about an instance that you have.

There are a lot of methods on the Type class which you can find interesting, two of them being:
<ul>
	<li><a href="http://msdn.microsoft.com/en-us/library/td205ybf.aspx">GetMethods()</a></li>
	<li><a href="http://msdn.microsoft.com/en-us/library/aky14axb.aspx">GetProperties()</a></li>
</ul>

As you might imagine, these are used to get information about the methods and properties that are defined on a static or dynamic type. Consider this being our current structure that we want to retrieve more information about:

    class Person
    {
        public string Name { get; set; }
        public int Age { get; set; }

        public string Speak()
        {
            return string.Format("Hello, my name is {0}", Name);
        }
        public string Yell()
        {
            return "THERE IS NO CAKE!!!";
        }
    }

By calling `GetMethods()` you will get an `IEnumerable<MethodInfo>`. So what I've done is that I have the following code to retrieve the method information for all the methods in my class:

    var person = new Person {Age = 24, Name = "Filip Ekberg"};
    var type = typeof (Person);

    MethodInfo[] methods = type.GetMethods();

If you look closely enough you can see that I still don't have a relationship between my method information (firstMethod) and my instance (person). You might be a bit surprised that the following is the content of the methods variable:

<img src="https://cdn.filipekberg.se/fekberg-blog/what-is-reflection-and-why-is-it-useful/getMethods.png" alt="" />

As you can see here there's actually a get/set method for each of the properties and we want to get the first method, so we can do this by using a simple functional approach like this:

    var firstMethod = methods.Where(x => !x.Name.StartsWith("get_") && !x.Name.StartsWith("set_"))
                             .First();

Now I want to invoke the method and get the returned string, I simply do that like this:

    var spokenWords = firstMethod.Invoke(person, null)

The second parameter that is `null` is the parameters/arguments sent to the actual method and since we don't have any arguments defined on our method, we can just leave it as `null`.

In the above case `spokenWords` will contain the following text:

`Hello, my name is Filip Ekberg`

As you can see, using reflection can be quite powerful! This means that we could do dynamic invocations and explore objects in a pretty cool way.

<strong>The last thing</strong> mentioned in the quote is about getting information about attributes and their values. I might cover that in another post later on.

Reflection should be your last resort, try designing your software as you would not need it, when the time comes when you might need to use it, then re-think again and be sure that you need it. Using Reflection requires a lot more resources and can slow down your application greatly if it is miss-used, therefore think twice before you actually use it outside your playground!

There are of course times when Reflection is needed, by reading the series of Reflection articles on this blog you might get an idea of when it is appropriate to use and when it is not.

I also hope you found this interesting and if you have any thoughts please leave a comment below!
