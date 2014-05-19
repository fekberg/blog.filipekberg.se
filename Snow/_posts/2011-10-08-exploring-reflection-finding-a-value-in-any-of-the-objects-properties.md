---
layout: post
title: Exploring reflection - Finding a value in any of the objects properties
date: 2011-10-08 02:37
author: fekberg
comments: true
metadescription: Exploring reflection - Finding a value in any of the objects properties
categories: .NET, C#, Programming
tags: csharp, csharp 4, dotnet, dynamic, dynamic programming, reflection
---
I want to explore reflection by playing with both reflection, anonymous types and dynamically typed things all at once! My goal is not to be confusing or anything, but it is to leave out the parts that are redundant.<!--excerpt-->

<strong>So let's get to it!</strong>

I sometimes find myself having a lot of data that I want to search through, it might be the same structure for each element and it might not, I can never assume that it's the same structure though, because if I would, there would most certainly be a case where it differs.

Let's assume that we have two anonymous types here:

    var person = new {Name = "Filip", Surname = "Ekberg", Age = 24};
    var animal = new {Name = "Baloo", Breed = "Some breed", Age = 14, Owner = "Filip"};

In my last post, I talked about the properties on anonymous types being read-only, the fact is that the entire anonymous object is read only, so even if I would say that it's a dynamic anonymous type, I wouldn't be able to specify new properties or methods on it.

Anyways! We have the above two objects that I want to search for something in, it might be the age, it might be a common string. So there are a few things that I got to figure out before I can start retrieving my results, here are the things we need to know:

<ul>
	<li>How do we get all the properties from the object?</li>
	<li>How do we get the value for the current property on the current object?</li>
	<li>How do we get the type of the object, does it matter that it's anonymous/dynamic?</li>
</ul>

Almost all of the above have been used here and there in my previous posts, but to answer them again:

<strong>How do we get all the properties from the object?</strong>

To get all the properties, we must first get the type, so we can retrieve all the properties for that type, like this: 

    obj.GetType().GetProperties()

<strong>How do we get the value for the current property on the current object?</strong>

To get the current value of the objects property you call GetValue like this, the second parameter is null because it's not an array: 

var value = property.GetValue(obj, null);

<strong>How do we get the type of the object, does it matter that it's anonymous/dynamic?</strong>

When you've retrieved the value of the property, you get the type of the value by doing this:

    value.GetType()

Now we have the basics and need to put every piece together so that we can search our objects, I want to have a method like this to find objects in a list with any property containing the Exact value that I pass:

    IEnumerable<dynamic> Find(dynamic pattern, IEnumerable<dynamic> source)

My code that calls this method will look like this:

    var person = new {Name = "Filip", Surname = "Ekberg", Age = 24};
    var animal = new {Name = "Baloo", Breed = "Some breed", Age = 14, Owner = "Filip"};
    var toLookup = new List<dynamic> {person, animal};

    var found = Find("Filip", toLookup);

So what can the implementation look like? We can either solve it with LINQ or with a foreach.

My method will start out by only declaring a new list that we will put the found elements in and then I just return it to make everything build nicely:

    IEnumerable<dynamic> Find(dynamic pattern, IEnumerable<dynamic> source)
    {
        var found = new List<dynamic>();

        // Implementation goes here....

        return found;
    }

Now I need to iterate over my source-variable and for each item, I need to go through each property and see if the value matches the pattern input. I add the two nested foreach-loops like this:

    foreach (var obj in source)
    {
        foreach (var property in obj.GetType().GetProperties())
        {
        }
    }

It's now iterating over each property on each object, you don't want to move the `GetType().GetProperties()` outside the foreach-loop, since in our case the structure changes over each iteration. Now we've come to the final part, we need to get the value of the current property on the current object and see if the type matches the pattern type and then check if the value matches the pattern:

    var value = property.GetValue(obj, null);
                        
    if (pattern.GetType() != value.GetType()) continue;
    if(pattern == value)
        found.Add(obj);

You might not want to use the equality operator in your case, if it's a string you might want to check if the pattern is anywhere in the current value or something like that.

This is how my Find-method turned out:

    IEnumerable<dynamic> Find(dynamic pattern, IEnumerable<dynamic> source)
    {
        var found = new List<dynamic>();
        foreach (var obj in source)
        {
            foreach (var property in obj.GetType().GetProperties())
            {
                var value = property.GetValue(obj, null);

                if (pattern.GetType() != value.GetType()) continue;
                if(pattern == value)
                    found.Add(obj);
            }
        }
        return found;
    }

I hope you found this interesting and if you have any thoughts please leave a comment below!
