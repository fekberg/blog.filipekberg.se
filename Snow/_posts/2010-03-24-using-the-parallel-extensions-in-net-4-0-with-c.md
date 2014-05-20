---
layout: post
title: Using the Parallel Extensions in .NET 4.0 with C#
date: 2010-03-24 10:59
author: fekberg
comments: true
metadescription: Using the Parallel Extensions in .NET 4.0 with C#
categories: .NET, C#, Programming
tags: .NET, .net 4.0, csharp, LINQ, parallel programming
---
As .NET 4.0 will be released in a couple of weeks and the RC has been out for a while. It's about time that I write something about the new helpful features of .NET 4.0. One of these helpful things are the Parallel Extensions and Parallel helpers that allowes you to do parallel programming.<!--excerpt-->

<blockquote><strong>Parallel computing</strong> is a form of <a title="Computing" href="http://en.wikipedia.org/wiki/Computing">computation</a> in which many calculations are carried out simultaneously</blockquote>

In this example I will be using a WebRequestPool which just helps me out a bit to carry on this example. You might think if it like this: You have different request types which takes different long to execute you might be doing some WebDAV uploading, Image Fetching and other Over-The-Web-Access which takes time. Instead of waiting for each request to stop, you might as well run them simultaneously.


	internal delegate void WebRequest(int ms);

	internal class WebRequestPool
	{
		public List Requests { get; set; }
	}

So to make it easy I just have a simple Delegate which will allow us to Run/Invoke our `WebMethods` which all takes some input parameter that will, in some way, make the requests take longer / shorter.

Inside of the `WebRequest` class all we have is a Requests Pool, a simple list of delegates.

To make the whole a little bit interesting we have three different types of Requests: Standard Request, Long Request and Extreme Request

	static void StandardRequest(int ms)
	{
		Thread.Sleep(ms);
	}

	static void LongRequest(int ms)
	{
		Thread.Sleep(ms^2);
	}

	static void ExtremeRequest(int ms)
	{
		Thread.Sleep(ms^10);
	}

So now we have three different types of methods that all validate with our delegate! Let's head on and fire up this pool

	var pool = new WebRequestPool
	{
		Requests =
			new List
			{
				StandardRequest,
				LongRequest,
				ExtremeRequest,
				StandardRequest,
				LongRequest,
				ExtremeRequest
			}
	};

This actually demonstrates something new too, the object initializers. So the list now contains six requests, All we want to do now is Processes these.

First of all we want to do it like we did in the old days, so I've created a method called `ProcessPool` which looks like this

	private static void ProcessPool(WebRequestPool pool)
	{
		var start = DateTime.Now;

		foreach (var item in pool.Requests)
			item.Invoke(2000);

		var end = DateTime.Now;

		var span = end - start;

		Console.WriteLine(
		string.Format("Execution time: {0}", span));
	}

Of we run this the output is
<img src="http://cdn.filipekberg.se/fekberg-blog/using-the-parallel-extensions-in-net-4-0-with-c/parallel_run_1.png" alt="Execution time" />

Now, that's a bit too slow for me, so <strong>Let's Parallelize that!</strong> All i've done now is to creat a new method called ProcessPoolAsParallel which takes the same input and expects to give the same result. There's a little bit difference though, the foreach is now replaced with the `Parallel.ForEach` method.

	private static void ProcessPoolAsParallel(WebRequestPool pool)
	{

		var start = DateTime.Now;

		Parallel.ForEach(pool.Requests,
			item => item.Invoke(2000));

		var end = DateTime.Now;

		var span = end - start;

		Console.WriteLine(
			string.Format("Execution time: {0}", span));
	}

So if we run this now the result is:
<img src="http://cdn.filipekberg.se/fekberg-blog/using-the-parallel-extensions-in-net-4-0-with-c/parallel_run_2.png" alt="Parallel run 2" />

So this increased significally!

This is just a small example of the power in using Parallel programming patterns. Look into the Task class to head on!

<strong>Edit</strong>

There's a slightly miss-used method in the code above, the ^ in C# is XOR and I was thinking of the Math.Pow, however, this doesn't really matter in this case since the result is still Parallel = Faster.
