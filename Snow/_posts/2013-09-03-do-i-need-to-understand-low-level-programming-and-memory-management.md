---
layout: post
title: Do I Need To Understand Low Level Programming And Memory Management?
date: 2013-09-03 06:07
author: fekberg
comments: true
metadescription: Do I Need To Understand Low Level Programming And Memory Management?
categories: Programming
tags: low level programming, Memory leaks, memory management, progarmming, sql injection
---
There's been some radio silence here recently, sorry about that but everything is literally upside down at the moment; hence I moved to the other side of the world! So let's break this radio silence by touching something rather interesting and quite frequently discussed; Do I Need To Understand Low Level Programming And Memory Management?<!--excerpt-->

Let's start this off with a self-explaining "JIF":

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/09/HatersGonnaHate.gif" alt="HatersGonnaHate" width="300" height="200" class="alignnone size-medium wp-image-2096" />

<h3>Well Do I?</h3>
Rather frequently you’ll meet developers that praise abstractions with the same enthusiasm that Mr. Ballmer once shouted "Developers, Developers, Developers!" There's nothing wrong with aiming to perfect abstractions that help you in your daily work. However it's important to really understand what the abstraction solves and how it impacts performance, security and most importantly manageability. Let's say that you're a web developer that has just learned how to use the best abstractions out there. For instance you know how to set up a data context using EF and how to get some users out of the database. Now your customer asks you not to use EF but rather write the SQL yourself, as you've never done this you go on with your day, google for some rather simple SQL management in C# and end up with something like this:

	public int GetUserId(string username, string password)
	{
	    var command = new SqlCommand(string.Format("select Id from Users where UserName={0} and Password={1}", username, password));
	    // and so on..
	}

You get the idea, right? The developer just went on with his day because he never had to bother understanding SQL Injection since the abstraction took care of all that. <strong>Wrong!</strong> The developer surely needs to understand everything there is about SQL Injections even if the abstraction says it takes care of the most common SQL Injections.

Now let's say that we have another developer that needs to perform some computation and starts doing something like this:

	public int Calculate(object data)
	{
	    var result = 0;
	    for(int i = 0; i < 10000; i++)
	    {
	        result += SomeMagicMethodThatDoesSomething(((int)data) + i);
	    }
	}

In this scenario we need to know about value types and reference types and why memory matters. The C# compiler might help us optimize this, other compilers might not. When we cast a value type to a reference type or the other way around some boxing and unboxing will be performed. This means moving the value in memory and doing so once might not be a performance penalty but doing it over and over again in a loop? Well that is just not good. In other scenarios obscure attempts to beat the compiler on optimization might make code unreadable which could have been avoided by understanding what happens on a lower level once the code is translated.

So once again, the lack of understanding what happens behind the scenes has lead us to shoot ourselves in the foot. In the examples above the problems might be quite obvious.

<strong>So what does this really have to do with low level programming and memory management?</strong>

High level languages, such as C# or PHP can be seen as abstractions on top of something lower level. On the final step of executing a C# program it will be executed as plain assembly. Which means that understanding how the C# code that we write is translated to that will help us understand how the processor might act on certain operations.

This in return will help us write faster and more reliable applications because we understand what happens on a lower level. The same goes with memory management. If we understand how objects are stored in memory and how to avoid memory leaks this will just as well help us write more reliable applications.

On a personal note, I've found that it is easier to transition between different programming languages when understanding lower level programming and memory management. Different people learn differently, for me it's been a great help to understand low level programming, I even have a weird urge to do some assembly now and then.

<em>What's your personal opinion on low level programming and understanding memory management? Do you think it helps with understanding new programming languages or is it just a waste of time?</em>
