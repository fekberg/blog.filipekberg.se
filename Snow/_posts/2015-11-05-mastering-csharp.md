---
layout: post
title: Mastering C#
date: 2015-11-05 00:00
author: fekberg
comments: true
metadescription: Do you want to master C#? Do you want to know what C# applications look like when they are decompiled? Here's a few really good resources!
categories: .NET, C#
tags: C#, CSharp, async, await, asynchronous programming, .NET, dotnet, raygun, mindscape, msil, il, compilers, roslyn
---
In 2013, I published my first Pluralsight course; [MSIL for the C# Developer](http://www.pluralsight.com/courses/msil-csharp-developer). The aim of this course was to teach you about how a compiler looks at your C# code, and translates that into something else. Understanding the internals of how C# is translated into IL is a good way to master C#. If you're building a car, knowing what an engine looks like on the inside will most certainly make you a better mechanic; although you'll get a long way without it as well.<!--excerpt--> 

If you are building high performance applications, or when optimizing your applications for IoT, knowing what penalties are applied to your code when introducing certain keywords will really help you build faster and more solid applications.

While writing IL by hand is probably not something you will do very often, being able to read through it and understand the behavior of an application will make you a better C# developer.

Of course, a really good C# applications follows best practices and patterns to help you along the way. One of the really hot topics over the years have been how to add logging to applications. It's better to find a problem and fix it before it reaches the customer. Over the years I think a lot of us have been writing our own systems for this, for instance systems that do: database logging, file logging, event logging. Why re-invent the wheel? Mastering C# is not only about mastering the language. It's about learning how to master your tooling, what packages, patterns and practices make the most sense in your current situation and how to tie it all together.

This is why earlier this year, 2015, I published a course on [Getting Started with Raygun in .NET](http://www.pluralsight.com/courses/raygun-dotnet-getting-started). This tool does not only give you the capability to track errors and allow you to configure this to your specific needs, it also provides you with a top of the line interface to track down and understand your errors. It may seem like a simple task to just store a blob with error details and when there's an issue, you simply go and look at that blob. Although, I'd certainly argue that proper error reporting is something that should be one of the first things you add to your applications; because finding bugs before your customers do is priceless.

As hinted with my first course, I personally think it's very important to understand the implications of keywords and practices. Naturally, my next course continues to help you master your C# skills by teaching you everything you need to [get started with asynchronous programming in C#](http://www.pluralsight.com/courses/asynchronous-programming-dotnet-getting-started). While adding the `async` and `await` keywords may seem trivial, I can ensure you that it certainly is not.

All to often, someone tells me that they don't understand why their application seem to be loading forever. I'm sorry to break it to you, but you've got a deadlock. Want to know why? It'll take a little while to explain this, which is why understanding the implications of adding the `async` keyword to your method is a really important step towards mastering C#.

Is this all you need to master C#? No, certainly not. It's a good step in the right direction: learn about what the compiled code looks like, learn how to analyze it, learn how to properly track errors in your applications and finally understand how to do proper asynchronous programming which is becoming more and more important. All of this will give you a good boost towards really mastering C#.

So what's next? I'd really love to hear about your ideas on what you want to learn next!

**Here's a list of my courses on Pluralsight to date:**

* [Getting Started with Asynchronous Programming in .NET](http://www.pluralsight.com/courses/asynchronous-programming-dotnet-getting-started)
* [Getting Started with Raygun in .NET](http://www.pluralsight.com/courses/raygun-dotnet-getting-started)
* [MSIL for the C# Developer](http://www.pluralsight.com/courses/msil-csharp-developer)
* [Game Programming with Python and PyGame](http://www.pluralsight.com/courses/game-programming-python-pygame)

Why did I do a Game Programming course in Python? It's a really good next step after learning programming fundamentals, and creating a game is super fun!

Enjoy watching my courses, I hope it helps you along the way to learn more about programming!