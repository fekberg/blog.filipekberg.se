---
layout: post
title: Using the C# Interactive Window that comes with Roslyn - Part 2
date: 2011-11-25 08:00
author: fekberg
comments: true
metadescription: What can we do with the Roslyn Interactive Window? A C# REPL can help you explore language features without a big fuss.
categories: .NET, C#, Programming
tags: csharp, dotnet, productivity, roslyn
---
In the <a href="http://filipekberg.se/2011/11/14/using-the-c-interactive-window-that-comes-with-roslyn/">previous post</a> we looked over an introduction to the C# Interactive Window that comes with Roslyn, now let's have a look at some things in the c# interactive window that will increase your productivity! I want to thank Kevin Pilch-Bisson ( @Pilchie ) for pointing some of these things out.

One question that arise when I showed off the C# Interactive Window at work was: This looks great, but can we use types in our current solution?<!--excerpt-->

<strong>Yes,</strong> you can and this is one of the things that I think makes this C# Interactive Window very powerful. Here's how you do it, go on about your day, coding your classes and when you want to fire up the C# Interactive Window you can just right click your solution and select "Reset Interactive from Project" like this:

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_8.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_8.png" alt="" title="csharp_interactive_8" width="729" height="739" class="alignnone size-full wp-image-479" /></a>

Now this will bring up the C# Interactive Window like this:

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_9.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_9.png" alt="" title="csharp_interactive_9" width="627" height="410" class="alignnone size-full wp-image-483" /></a>

As you might see here you can reference assemblies by writing `#r <name>` and then import the namespace by writing a using-statement. You can experiment a bit with it, try writing the following:

	> #r "System.Windows.Forms"
	> System.Windows.Forms.MessageBox.Show("test");

You could also do it like this:

	> #r "System.Windows.Forms"
	> using System.Windows.Forms;
	> MessageBox.Show("test");

Now this is pretty powerful, because now we can do live testing on our objects with intellisense without actually adding or changing anything in our solution. As I said in the previous post this is nice when you want to test code out and play with it. Let's say that you're completely new to a project, it lacks good documentation and sure you see all the code files and you can navigate around inside them to learn about them, but how do you test everything out?

You can write tests for yourself, compile, run test and do that over and over again or you can fire up the C# Interactive Window and start playing around. 

Have a look at this, I've created an instance of my Person class and then I check if the instance is null or not and instantly the result of this expression is printed out (hence REPL). We also get intellisense on our classes which makes exploring and working with the interactive window a blast!

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_10.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_10.png" alt="" title="csharp_interactive_10" width="626" height="411" class="alignnone size-full wp-image-484" /></a>

I hope you found this interesting, if you have any thoughts please leave a comment below!
