---
layout: post
title: What's the difference between doing this and that in C#?
date: 2012-09-24 08:00
author: fekberg
comments: true
metadescription: Ever gotten the question: What's the difference between doing this and that in C#? This is how you prove your answer!
categories: .NET, C#, Programming
tags: csharp, IL, MSIL, Programming, WinMerge
---
<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/spotting_the_difference-300x192.jpg" alt="" title="Spot the Difference" width="300" height="192" style="float: right; padding-left: 20px;"/>I often get the questions or enter discussions where the topic is: <em>What is the difference between doing this and that in C#?</em> It is not always that easy spotting the difference between code samples. I'm not referring to the actual code you have in Visual Studio, but the code that will be executed, or the IL produced when you compile. Most recently I answered a <a href="http://stackoverflow.com/q/11351214/39106">question on StackOverflow </a> that asked if there would be any difference between nesting and not nesting (using AND) if-statements.<!--excerpt-->

<strong>Nested version</strong>

	if (x == 5)
	{
		if (y == 3)
		{
	            Console.WriteLine("Hello!");
		}
	}

<strong>Not nested version</strong>

	if ((x == 5) && (y == 3))
	{
	    Console.WriteLine("Hello!");
	}

Before we actually prove if there is a difference/no difference, I think it is important to ask ourselves: <strong>Which version is most readable?</strong> Readability and maintainability is to me what is most important, as long as I'm not working with RTS or Embedded Systems.

At a first glance it does look like there is a difference between the two, because if you use your head as a compiler, there would have to be at least two branches. However (and this is important) it is not our brains that does the actual compiling! Really, we shouldn't have to bother trying to beat the compilers optimization. 

With that said, let us take a look at the IL generated when we run this in optimization / release mode for the first code snippet:

	IL_0000:  ldc.i4.5    
	IL_0001:  stloc.0     
	IL_0002:  ldc.i4.3    
	IL_0003:  stloc.1     
	IL_0004:  ldloc.0     
	IL_0005:  ldc.i4.5    
	IL_0006:  bne.un.s    IL_0016
	IL_0008:  ldloc.1     
	IL_0009:  ldc.i4.3    
	IL_000A:  bne.un.s    IL_0016
	IL_000C:  ldstr       "Hello!"
	IL_0011:  call        System.Console.WriteLine

Now, let us take a look at the second one:

	IL_0000:  ldc.i4.5    
	IL_0001:  stloc.0     
	IL_0002:  ldc.i4.3    
	IL_0003:  stloc.1     
	IL_0004:  ldloc.0     
	IL_0005:  ldc.i4.5    
	IL_0006:  bne.un.s    IL_0016
	IL_0008:  ldloc.1     
	IL_0009:  ldc.i4.3    
	IL_000A:  bne.un.s    IL_0016
	IL_000C:  ldstr       "Hello!"
	IL_0011:  call        System.Console.WriteLine

Instead of us comparing instruction by instruction, let's use a tool for that which will spot all the differences for us; <a href="http://winmerge.org">WinMerge</a>! With <a href="http://winmerge.org">WinMerge</a> we can select two different files on disk that we want to compare with each other. So I saved both the IL outputs that I got from LINQPad (as you can see in the below image) as different text files:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/LINQPad.png" alt="" title="LINQPad" width="641" height="608" class="alignnone size-full wp-image-1216" />

<em><a href="http://filipekberg.se/2012/09/17/use-linqpad-for-more-than-linq/">(You know that you can use LINQPad for more than just LINQ, </em>right?)</a>

Now that you've saved both the IL outputs as text files, I copied into Notepad and saved it like that. You can create a new Compare session by selecting the left and right file like this in WinMerge:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/WinMerge.png" alt="" title="WinMerge" width="577" height="244" class="alignnone size-full wp-image-1217" />

This will start comparing the files and then bring up a very nice interface where we can spot the differences, but in our case we will get a message box telling us that the files were identical!

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/WinMerge2.png" alt="" title="WinMerge" width="820"  class="alignnone size-full wp-image-1218" />

However, if we instead would have compiled these without optimization we would see a difference. Here's how you turn on/off optimization in LINQPad:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/LINQPad2.png" alt="" title="LINQPad" width="616" height="478" class="alignnone size-full wp-image-1220" />

Swap to "without optimization", recompile and save the IL to the text files and re-run the comparison in WinMerge. This will show us that there is in fact a difference when we turn off optimization:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/WinMerge3.png" alt="" title="WinMerge" width="831" height="780" class="alignnone size-full wp-image-1221" />

This is what I normally do when someone asks me about the difference between two similar (or what you expect to be similar) code snippets. The IL might not be good enough for your arguments sake, so you might even want to take a look at the bits and bytes actually used when executing your application. This is possible by using a tool called <a href="http://msdn.microsoft.com/en-us/library/6t9t5wcf(v=vs.110).aspx">Native Image Generator (NGen)</a>. NGen is good for <a href="http://msdn.microsoft.com/sv-se/magazine/cc163610(en-us).aspx">many reasons</a>, the MSDN Page for it describes the biggest reason like this:

<blockquote>The Native Image Generator (Ngen.exe) is a tool that improves the performance of managed applications. Ngen.exe creates native images, which are files containing compiled processor-specific machine code, and installs them into the native image cache on the local computer.</blockquote>

<em>So using it to compare the byte code is not what it was designed for.</em>

If the question is regarding the difference between methods in earlier .NET versions contra the older ones, you can use a tool like <a href="http://www.reflector.net/">Reflector</a> to step through the .NET assemblies and see for yourself what the difference is. If you want to prove that for instance the built in BubbleSort algorithm is in fact O(n^2) in some third party library, you could use Reflector to step through the code and do so!

<strong>When you don't really know if there is a difference or not and someone asks you about it, how do you tackle it and answer that question?</strong>

