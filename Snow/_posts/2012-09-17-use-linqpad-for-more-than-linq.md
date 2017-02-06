---
layout: post
title: Use LINQPad for more than LINQ
date: 2012-09-17 10:56
author: fekberg
comments: true
metadescription: LINQPad is a powerful tool that you can use to run expressions, statements and small programs using C#, VB and F#!
categories: .NET, C#, Programming
tags: .NET, csharp, developer tools, dotnet, linqpad, linqpad 4
---
I like to spend time on StackOverflow and contribute by answering as many questions as I have time to. Many of the questions consist of code that doesn't always work as expected. In these times I find that <a href="http://www.linqpad.net/">LINQPad</a> is the perfect tool to use when you want to run the sample code or create smaller samples yourself for your answers.

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/linqpadlogo.png" alt="" title="LINQPad Logo" width="259" height="249" class="aligncenter size-full" /><!--excerpt-->

<h3>Don't be confused by the name!</h3>
Just because the name is <strong>LINQ</strong>Pad, it doesn't mean it only does LINQ. Even if evaluating and running expressions is what it does best. LINQPad will allow you to run the following code types:

<ul>
	<li>C# Expression</li>
	<li>C# Statement(s)</li>
	<li>C# Program</li>
	<li>VB Expression</li>
	<li>VB Statement(s)</li>
	<li>VB Program</li>
	<li>SQL</li>
	<li>ESQL</li>
	<li>F# Expression</li>
	<li>F# Program</li>
</ul>

<strong>This makes LINQPad really powerful!</strong>

Best of all, there's a <a href="http://www.linqpad.net/">free alternative</a> with a little less sugar on it. I recommend <a href="http://www.linqpad.net/Purchase.aspx">buying a license</a> to support this amazing developer tool though and it will give you autocompletion in LINQPad, which makes it even more powerful!

<h3>Running C# code</h3>
Let us take a look at LINQPad and what it looks like. Here's what LINQPad looks like when you first start it up, it's clean and intuitive:

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/LINQPad_1.png" alt="" title="LINQPad"  width="750" class="aligncenter size-full" />

By default, it's preset to running C# Expressions, but you can easily switch between the different types of code snippets to execute in the dropdown menu:

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/LINQPad_21.png" alt="" title="LINQPad - Changing language / code type" width="750" class="aligncenter size-full" />

In an expression, you can't declare variables, think of it like you can't add multiple statements. This is an example of a C# Expression:

	new [] {11,20,33}.Where(x => x % 2 == 0)

We can execute this by pressing the green "run" button or by pressing F5 (as in Visual Studio). This will display a result of the expression as you would imagine any REPL would do:

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/LINQPad_3.png" alt="" title="LINQPad - Executing a C# Expression" width="750" class="aligncenter size-full" />

Now let us assume that we have a more complex code snippet that we want to execute and we want to get information about variables along the way. LINQPad hooks in an extension to `object` which provides a method called `Dump`. This will dump information about the object that you use it on.

The more complex code snippet will be a BubbleSort implementation in C#. First we create a list of integers, order it randomly and then sort it using BubbleSort (side note: BubbleSort is the slowest sorting algorithm.).

To see that my items were actually sorted, I want to show the content of my list before and after it was sorted. To do this, I can use the extension method `Dump()` that comes with LINQPad. It will look like this:

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/LINQPad_4.png" alt="" title="LINQPad - Implementing bubblesort" width="750" class="aligncenter size-full" />

This is the code that I executed:

	var items = Enumerable.Range(0,4)
						  .OrderBy(x => Guid.NewGuid())
						  .ToArray();
	items.Dump();

	// Bubblesort: O(n^2)
	bool done = false;
	while(!done)
	{
		done = true;
		for(int i = 0; i < items.Length - 1; i++)
		{
			if(items[i] > items[i + 1])
			{
				var temp = items[i];
				items[i] = items[i + 1];
				items[i + 1] = temp;
				done = false;
			}
		}
	}

	items.Dump();

This is a great example of how powerful multiple statements are in LINQPad. But there's more, you could also execute an entire program and have multiple classes and methods in it. But for larger projects like that, I personally like to create a Visual Studio project instead.

Notice the different outputs that we can select as well. If we wrote LINQ, we might want to see the actual SQL that is executed and if we write a couple of statements we want to see the IL:

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/LINQPad_5.png" alt="" title="LINQPad - Exploring IL" width="750" class="aligncenter size-full" />

LINQPad can do much more than this as well, we can have it connect to a database to run queries against our data. We can also change if the code is optimized or not; if we want to explore the IL that is generated when using optimization contra when it is not.

<a href="http://www.linqpad.net/">LINQPad</a> is awesome and I use on a daily basis!