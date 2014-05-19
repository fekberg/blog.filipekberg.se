---
layout: post
title: Using Parallel Extensions in LINQ
date: 2010-03-25 16:16
author: fekberg
comments: true
metadescription: Using Parallel Extensions in LINQ
categories: .NET, C#, Programming
tags: .NET, .net 4.0, csharp, LINQ, parallel programming
---
Once again, there was a little mistake in the last post I posted here which clearly didn't effect the result that much. But it is still worth mentioning again. The ^ was not meant to be XOR, I was clearly thinking of Math.Pow.<!--excerpt-->

In the last post I didn't spend to much time talking about the Parallel Extensions for LINQ which are Really great and helpful; If you just love to replace traditional loops with LINQ-expressions you will probably find this post somewhat amusing.

So let's dig down to the coding shall we!

First of all I have set up a smaller list with numbers, in this scenario we will just assume that we have a list of something and depending on the contents of that list, the time it takes to perform an action on that result, will differ. So here's my list

	var latency = new[] {1, 2, 4, 8};

<em>Side note: `new[]{}` is really helpful, especially when you are creating examples like this!</em>

And then I have a method that I want to run for each element in my list, which I will call PerformLogic

	static int PerformLogic(int latency)
	{
	    var ms = 500 * latency;

	    Thread.Sleep(ms);

	    return ms;
	}

In "traditional" programming, you would maybe do something like this:

	for ( int i = 0; i < latency.Lenght; i++ )
	{
	    PerformAction(i);
	}

But I don't find that so amusing anymore, using LINQ is so much neater so instead of that for-loop we can actually do this:

	(from i in latency select PerformAction(i)).ToList();

We don't really have to write the expession like this though, since LINQ + .NET 4.0 is so smart, we can Refactor this to look somewhat like this:

	(latency.Select(PerformLogic)).ToList();

The previous one is a bit more elaborate but this is fine aswell.

<strong>Making it parallel</strong>

We've reached the place where we no longer can refactor our code to make it faster, we can't replace anything in the logic to make everything faster; We need to parallelize it!

Let's have a look at what LINQ provides us with, oh, there's an method called `.AsParallel`.

All I did now was changing the above code to this:

	var result = (latency.Select(PerformLogic)).AsParallel().ToList();

And we have a parallelized query. For those with a fast mind can see that it will take about 7,5 seconds to run this since each of the "latency"-points will take itself times ½ second.

My final test-code looks like this

	var latency = new[] {1, 2, 4, 8};

	var start = DateTime.Now;

	var result = (latency.Select(PerformLogic)).AsParallel().ToList();

	var end = DateTime.Now;

	Parallel.ForEach(result, Console.WriteLine);

	Console.WriteLine("Execution time: {0}", (end - start));

And this is the output
<img src="http://dl.dropbox.com/u/4396175/snapshots/linq_parallel.png" alt="LINQ Parallelism" />
