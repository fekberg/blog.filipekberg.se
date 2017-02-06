---
layout: post
title: Microsoft Open Sources C# Compiler
date: 2014-04-04 00:42
author: fekberg
comments: true
metadescription: Microsoft Open Sources C# Compiler! Read about what is coming to C# in the next version of the language.
categories: .NET, C#, Programming
tags: Compiler, csharp, Language Features, Microsoft, open source, roslyn
---
<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2014/04/VS2013Logo.png" alt="VS2013Logo" width="200" style="float: right; margin-left: 15px; margin-bottom: 15px;" />This is truly an extremely exciting time, <a href="https://roslyn.codeplex.com/" target="_blank">Microsoft is Open Sourcing the C# Compiler (Roslyn)</a>. Even without being open source, the new C# (and VB) compiler have had some proven potential. We have seen some exciting things such as <a href="http://www.semanticmerge.com/" target="_blank">semantic merge</a> and powerful plugins for Visual Studio.<br/> <br> Now that the source is out there and they are accepting contributions - where do you think this will end? Personally, I cannot even imagine what the community will come up with.<br><br><a href="https://roslyn.codeplex.com/" target="_blank">C# Compiler Source Code Available Here.</a><!--excerpt-->

<h3>C# 6.0</h3>
During the last year, we have seen some announcements on coming features in the next version of C#, with the compiler being open source there is a roadmap and <a href="https://roslyn.codeplex.com/wikipage?title=Language%20Feature%20Status&referringTitle=Documentation" target="_blank">list of features</a> coming in each language.

I thought I would share a bunch of them that excites me the most!

<h4>Primary constructors</h4>
Instead of having to create your primary constructor yourself and initialize your fields manually, you can now take advantage of Primary constructors, which will turn up in the class declaration and look like this:

	public class Point(int x, int y) 
	{ 
	}

<h4>Auto-property initializers and Getter-only auto-properties</h4>
Now that we have the primary constructor we want to be able to initialize our properties with these values, instead of creating the constructor the old fashion way, we can do it a bit more nicely with the initializers:

	public class Point(int x, int y) 
	{ 
	    public int X { get; set; } = x;
	    public int Y { get; } = y;
	}


<h4>Using static members</h4>
Imagine how often you do `Console.WriteLine` in a console application. Would it not be nice if you could just define somewhere that you want to include the static members and have the accessible directly in your class?

You can do that now by simply adding a using statement for the static type!

	using System.Console;

	public class Point(int x, int y) 
	{ 
	    public int X { get; set; } = x;
	    public int Y { get; } = y;

	    public void Print()
	    {
	         Write(x);
	    }
	}

<h4>Dictionary initializer</h4>
Whenever I create a dictionary, I feel it is quite cumbersome to easily initialize it with some temporary values. Now with dictionary initializers that is quite easy!

	new JObject { ["x"] = 3, ["y"] = 7 }

<h4>Declaration expressions</h4>
Whenever you are working with methods that require an out parameter, you always have to create that variable before calling the method, which is a bit ugly so with declaration expressions this is fixed!

	int.TryParse(s, out var x);

<h4>Binary literals and Digit separators (Planned)</h4>
Sometimes working with numbers can be a bit hard, especially if you have long numbers, hex or binary to work with. It might get a bit easier; this is a planned feature for C# as it has already done for VB.

Binary literals will look like this: <strong>0b00000100</strong>
Digit separators will look like this: <strong>0xEF_FF_00_A0</strong>

<h4>Expression-bodied members (Planned)</h4>
This is a C# feature only, as of now this is just planned but is not planned at all for VB. Sometime you just want to have an expression that calculates a couple of things for you, but you might not want to be as expressive as creating a method. Expression-bodied members let you do this in a clean and short way.

	public double Dist => Sqrt(X * X + Y * Y);

<h4>Null propagation (Planned)</h4>
How many of you have had a <strong>null point reference exception</strong>? I would imagine quite a few. 

I tend to get them when working with partially loaded data, let us say that I have a Customer that in its turn have a bunch of Orders and the order has a price.

To ensure that we do not get an exception, we would have to check each parameter first before even trying to access price.

With null propagation, you do not have to do that, you simply have a way of expressing yourself in a manner that will evaluate the entire expression to null if one of them is null:

	customer?.Orders?[5]?.$price

This means if Orders is null or the Order that we fetched was null, we do not get a null reference exception.

<h4>String interpolation</h4>
When working with string concatenation and adding values into a string, you normally use a string builder or `string.Format`. Personally, most of the times I just want to add a name of a person or information about the person, or something similar. Which makes `string.Format` come off as chatty.

Instead, we could maybe do something like this:

	"\{p.First} \{p.Last} is \{p.Age} years old."

I say maybe because this feature is not even planned for either C# or VB.

These are not all of the language features in the next version of C#, but these are some of my favourite ones.

<strong>Which ones are you looking forward the most to?</strong>

<a href="https://roslyn.codeplex.com/wikipage?title=Language%20Feature%20Status&referringTitle=Documentation" target="_blank"><em>Examples taken from the Language feature implementation status page on the Codeplex website and the list here might not be complete.</em></a>
