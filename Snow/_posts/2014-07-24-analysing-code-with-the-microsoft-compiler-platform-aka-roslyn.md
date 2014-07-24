---
layout: post
title: Analysing Code with the Microsoft Compiler Platform aka Roslyn
date: 2014-07-24 00:00
author: fekberg
published: draft
comments: true
metadescription: Analysing Code with the Microsoft Compiler Platform aka Roslyn
categories: Roslyn, Microsoft Compiler Platform, .NET, C#, Programming
tags:  Roslyn, Microsoft Compiler Platform, .NET, CSharp, Programming
---

A bit over a year ago I wrote and talked about Roslyn a fair bit, a lot has happened in this last year both in terms of the progression of the C# language and the compiler platform itself. Most notably is probably the decision to make the compiler platform open source (which happened earlier this year)[http://blog.filipekberg.se/2014/04/04/microsoft-open-sources-c-compiler/]. With the decision to open source the compiler platform, it meant that the community could take part of what is the next version of the languages, what the compilers looks like under the hood and most intersting of them all: the decision making behind language features and directions of the project.

I will not go into detail on the language features of C# vNext as there will be an article published by me in the DNC Magazine on this, keep an eye out for that if you are keen on the new language features of C# (6) vNext. Instead we will take a look at how we can use what is available to us today from an analysis perspective and use that to analyse some C# code.

The idea is that we pass a chunk of code to the compiler and then we have the opportunity to analyse the sematics and the syntax that is produced by the compiler, before telling it to emit the code and make it runnable. You might be asking yourself why you would want to analyse code yourself, there may be multiple reasons for you to do so. Consider you are working on a project where you have some very specific code guidelines, in order for your team to adapt to these guidelines you may write a simply plugin using the compiler platform that analyses the code and based on passing or failing the guideline, it may fail the build for your or give you some indication that you need to change it.

Another scenario is aspect oriented programming, you may want to analys and when finding something particular, modifyng the behavior. I did a talk (in 2013)[http://blog.filipekberg.se/2013/05/02/utilize-roslyn-to-create-the-next-level-plugin-capability/] about how to utilize this to create a fairly interesting plugin system. In this talk I used PostSharp to do the aspect oriented programming parts, but this could just as well have been done with the Microsoft Compiler Platform, Roslyn, instead. Take a look at the following image, here we have two representations as trees of an expression saying 10 + 20. The right hand tree shows how we have replaced the + with a -.

<img src="http://cdn.filipekberg.se/fekberg-blog/analysing-code-with-the-microsoft-compiler-platform-aka-roslyn/syntax_tree_rewrite.png" />

This very simply example does not rightfully show you the power of what the compiler platform allows you to do, your possibilities are somewhat endless. Consider another scenario, where you use the compiler platform to find all method calls to a certain method, you replace the method call with a custom block of code that adds some logging, the following code sample shows an example of this.

	// Original method call
	var result = MyMethod(10);

	// Re-written method call using Roslyn
	Debug.WriteLine("Calling {0} with first parameter value {1}", "MyMethod", 10);
	var result = MyMethod(10);
	Debug.WriteLine("Call to {0} finished", "MyMethod");

Imagine also being able to add timers in here to see how long certain calls take, of course the analysis tools in Visual Studio still enables you to do so. Sometimes though you might want to get this type of data from a production environment, then you could just have a custom compilation that would replace all these method calls to include more logging, timing and so forth.

Performing the actual replacing of nodes may not be as trivial as you expect though, it does take some understanding of the compiler platform and what the representation of code looks like from the compilers perspective. On a very abstract and basic level, the tree that represents a code block is immutable, what you do is that you tell the node that you are currently inspecting (the +) that you want to replace it with another node (the -). This will return a new tree representation that you can include in your compilation. You need to think of the replacement of nodes as replacements of a string, it will not do inplace replacing, but the structure is immutable!

### Analysing code with the Compiler Platform aka Roslyn