---
layout: post
title: When is 1 Not Equal to 1?
date: 2015-02-24 00:00
author: fekberg
comments: true
metadescription: When is 1 Not Equal to 1?
categories: .NET, C#
tags: C# 6.0, CSharp, Null Propagation, .NET, dotnet, CSharp 6.0, C# 6
---
Not too long ago I noticed a rather interesting question on JabbR that caught my attention:

**When is 1 not equal to 1?** asked the developer. Loving to solve problems and help others, I started questioning my fellow developer about the details of the problem. The first thought that popped up in my head take us back to my university days when first hearing about `NaN` (Not a Number), by definition [`NaN != NaN`](http://stackoverflow.com/questions/471296/how-can-while-i-i-be-a-non-infinite-loop-in-a-single-threaded-applicati). 

To my surprise the data type was not of a type where `NaN` is applicable;<!--excerpt--> in fact it was insisted that this was an integer compared to another integer. Being even more intrigued about the problem at this point I asked for a little bit more insight into the code. A piece of the code caught my eyes, the developer had to convert two parameters into the integers for some reason. To do this in C#, you can use `Convert.ChangeType`; minimum this method takes two parameters: the value and the type to convert to.

**I ask the developer** to send me the code snippet that fails, this is what the developer sends me:

	Convert.ChangeType("1", typeof(int)) == Convert.ChangeType("1", typeof(int))

Obviously it's simplified for the sake of this article, and they couldn't change their code to use **`int.TryParse`**, otherwise they would have. 

**Do you expect this to be true?** At this point you most likely figure out that the answer to this question is no. [If we look at the complete signature of this method, we can see that it will return an **`object`**!](https://msdn.microsoft.com/en-us/library/dtb69x08(v=vs.110).aspx)

This means that we are basically executing the following: `(object)1 == (object)1` and this will not work either! Why? Because it compares the references and they're of course not equal in this case. In the case of this developer, it was not possible to simply cast to the correct type however, there was still a solution at hand!

**Polymorphism to the rescue!**

Every type in .NET has the capabilities of overriding `Equals`, however the built in types already do this. At this point, I had asked the developer to try the following:
	
	((object)1).Equals((object)1)

And voila, it worked; which is obvious when you know the method signature of `Convert.ChangeType`. 

Let us look at something, equally interesting (pun intended). Consider we have the well-used `Point` and an `X` and `Y` coordinate. This type has an operator overload for equality checks looking like the following:

	public static bool operator ==(Point a, Point b)
	{
	    return a.X == b.X && a.Y == b.Y;
	}

What do you think happens in the following scenario?

	object a = new Point { X = 100, Y = 100 };
	object b = new Point { X = 100, Y = 100 };

	a == b

Will `a` equal `b`? No, of course not. We are actually not making use of the operator overload in this case, since both `a` and `b` are `objects` for all we care. The solution for this would be to override `Equals`!

	public override bool Equals(object obj)
	{
	    var point = obj as Point;

	    return point?.X == X && point?.Y == Y;
	}

We even got to use null propagation! This way it wouldn't blow up if we run it like this: `a.Equals(null)`.

Looking back at the fundamentals from time to time doesn't hurt, and helping out a fellow developer in need at least makes me sleep better at night.

I hope you found this read interesting!