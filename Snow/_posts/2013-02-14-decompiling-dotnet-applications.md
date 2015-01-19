---
layout: post
title: Decompiling .NET Applications
date: 2013-02-14 14:34
author: fekberg
comments: true
metadescription: What tools do you use to Decompile .NET Applications? Here are some suggestions on Decompiling .NET Applications!
categories: .NET, C#, Programming
tags: .NET, csharp, decompile, dotnet, dotPeek, ILSpy, JustDecompile, Programming, Reflector, tools
---
There are many reasons to why you might want to decompile an application after it's been compiled. Compiling C# code "just" translates it into MS IL. The compiler of course does some magic and tweaks the code as much as possible. There's no metadata stored after compilation which means that comments and such will not be available in the IL output.

The following image illustrates what happens when we compile something, we put the C# code into a basket and tell the compiler to give us a binary of this which is sort of a black box at the moment. We know that whenever we want to use this black box we have something behind the curtain that knows how to open it and use it properly (read: CLR).<!--excerpt-->

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/Compiling_CSharpCode.png" alt="Compiling C# Code" width="752" height="224" class="alignright size-full wp-image-1720" />

Let's consider a basic variable instantiation and an equality check, when this is compiled it will output something partially readable. To me the output is readable but that's just because I have a weird love for IL. When this basic snippet was compiled using <a href="http://www.filipekberg.se/2012/09/17/use-linqpad-for-more-than-linq/" target="_blank">LINQPad</a> it generated some IL which you can see below.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/Compiled_CSharpCode.png" alt="Compiled C# Code" width="576" height="408" class="alignright size-full wp-image-1717" />

Imagine that you got a DLL from an old co-worker and the code is long gone but you need to make some changes to the code. What do you do?  One option is to mimic the functionality if the application is not too big and create it from scratch but that is just cumbersome. Instead what we want to do is something like you can see illustrated below; we want to go back from IL to C#!

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/Decompiling_CsharpCode.png" alt="Decompiling C# Code" width="548" height="413" class="alignright size-full wp-image-1718" />

<strong><em>So how do we do this?</em> By using a decompiler!</strong>

As I tend to do this quite often to understand how libraries work that I have no control over, I have tried some different tools for just this cause. Let's take a look at four of the most common ones on the market. Don't worry, there's both free versions and paid ones out there!

<h3>Telerik JustDecompile</h3>
The first one that we're looking at is a product from the Just* family created by Telerik. I do like the products from Telerik so this one should be quite interesting!

JustDecompile is completely free and <a href="http://www.telerik.com/products/decompiler.aspx" target="_blank">available for download over at Teleriks website</a>. One thing that I didn't like thought was the installer, generally Telerik's installers are pretty nice, but I don't like being "guided" to install other stuff than what I've asked for.

Below is a screenshot of the installer and as you can see it advices you to install a lot of trials for other Telerik products.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/JustDecompileInstaller.png" alt="JustDecompile Installer" width="810" height="590" class="alignright size-full wp-image-1723" />

After selecting only to install JustDecompile the installation will only take up 36MB. You'll also need to create a Telerik account if you don't already have one which can also be a hassle, but it's free so why not!

I've setup a project that has the same variable declarations and the equality check from above and then compiled and opened the executable in JustDecompile. The result is quite similar to the original source as you can see in the following image.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/Decompiling_With_JustDecompile.png" alt="Decompiling with JustDecompile" width="810" class="alignright size-full wp-image-1727" />

We can also select to show the result as IL instead of C# code!

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/Decompile_With_JustDecompile_IL.png" alt="Decompile with JustDecompile show IL" width="810" class="alignright size-full wp-image-1729" />

There are a couple of things that I didn't find straight forward using JustDecompile.

<h4>Pros</h4>
<ul>
	<li>It's free!</li>
<li>It's fast!</li>
	<li>The UI is beautiful</li>
	<li>It looks easy</li>
	<li>Does what it should (partially)</li>
</ul>

<h4>Cons</h4>
<ul>
<li>There's a button for creating a project, I expected it to be able to export my binary to a complete VS Solution but it's grayed out and there's no tooltip on why that is so.</li>
<li>Showing the source as VB instead of C# shows nothing at all, shouldn't matter if the original code was C# or not.</li>
</ul>

<h4>JustDecompile Summary</h4>
Even though there are some cons; would I recommend you using it? Of course! If you haven't installed it already go ahead and do so! It can only become better if more people support it and give them suggestions. There's even a suggestion button where you can submit requests.

<h3>ILSpy</h3>
This one is interesting, ILSpy is an open source assembly browser and decompiler for .NET Applications! This means that if you don't like what it does or if you have feature suggestions, "you can just" provide the fix yourself! The tool itself is equal to what JustDecompile offers but the installation process is much easier. You simply grab the binaries or source from the <a href="http://ilspy.net/" target="_blank">ILSpy website</a> and unzip it wherever you want it!

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/ILSpy.png" alt="ILSpy" width="759" height="467" class="alignright size-full wp-image-1731" />

I simply performed the same process as I did with JustDecompile; I started ILSpy and opened up my executable but this is where it gets interesting. The code that it decompiles to looks Exactly like the code that I wrote in Visual Studio as you can see in the following image.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/ILSpy_Decompile.png" alt="ILSpy Decompile" width="810" class="alignright size-full wp-image-1734" />

Decompiling to VB also works right out of the box, this tool has what it takes!

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/ILSpy_Decompile_VB.png" alt="ILSpy Decompile to VB" width="810"  class="alignright size-full wp-image-1736" />

Now to the more interesting feature; Can we save/export this to a C# Project?

By the looks of it there's a "Save Code" action in the File menu, selecting the assembly and then pressing ctrl+s or the "Save Code" action actually lets us save a csproj file! If you open up the location in your file explorer you will see that it actually generated a project file and the code file!

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/ILSpy_SaveProject.png" alt="ILSpy Save project and Export Code files" width="810" class="alignright size-full wp-image-1738" />

I think we've looked enough at ILSpy to write up a pros and cons!

<h4>Pros</h4>
<ul>
<li>Free!</li>
<li>Open-Source, do I need to say more?</li>
<li>All features seem to work as they should</li>
<li>Easy to use interface</li>
<li>Fast!</li>
</ul>

<h4>Cons</h4>
<ul>
<li>The UI isn't really that good lookig but it's functional</li>
<li>The application seemed to freeze once but it just took a while to analyze a code file, I had to stretch for this one..</li>
</ul>

<h4>Summary</h4>
There really aren't many bad parts regarding ILSpy, I like it but if I have to complain about something it's the UI and that it felt like it froze once. I really recommend trying out ILSpy and looking over the code for it, it's great for educational purposes and I have co-workers that use it all the time and like it a lot.

What are you waiting for, <a href="http://ilspy.net/" target="_blank">go download</a>!

<h3>dotPeek</h3>
Just as the two mentioned above dotPeek is available for free, it's not open source though. dotPeek comes from JetBrains and is <a href="http://www.jetbrains.com/decompiler/" target="_blank">available on their website</a> where you can also find a lot of interesting information about how to use it.

Installing this is easy and doesn't force you or ask you to install anything else than what you really want in this case.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/dotPeek.png" alt="dotPeek" width="528" height="516" class="alignright size-full wp-image-1753" />

If you are familiar with ReSharper (R#) which is also a product from JetBrains, the keyboard shortcuts will be something of value to you. In fact dotPeek uses the same navigation as you might be used to from using ReSharper!

Let's have a look at what dotPeek thinks of our executable. When opening up dotPeek you're meet with a beautiful interface that feels like it's a part of the Visual Studio family (except for the very colorful icons). Opening up the executable and looking at the code you can see that it didn't really give us the same result as any of the other decompilers we've looked at.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/dotPeek_1.png" alt="dotPeek looking at the code" width="810" class="alignright size-full wp-image-1754" />

So instead of actually displaying what the IL tells us, it analyzes the IL and optimizes the code for us which is really not what we want to do. There's also no way of swapping between C#, VB.NET, F# or IL. So in this case we are "stuck" with looking at some C# code without knowing what IL it comes from.

What is also a downside to this is that you cannot export the code that you are looking at, which means that this is a pure code browser.

<h4>Pros</h4>
<ul>
<li>Beautiful UI</li>
<li>Fast</li>
<li>Code inspection and navigation that you might be used to from ReSharper</li>
<li>Supports plugins just like ReSharper</li>
</ul>

<h4>Cons</h4>
<ul>
<li>Lack features such as show code in different ways; swapping between VB.NET, F# and IL</li>
<li>Doesn't resemble the actual code that was compiled</li>
<li>Doesn't support exporting code or projects</li>
<li>The application itself seem to be very light-weight and lacking configuration possibilities</li>
</ul>

<h4>Summary</h4>
While I like JetBrains products in general, this one feels like there's something missing. Personally when I use a decompiler I want it to be able to show me the output code in different ways and give me options to export it. But if you are looking for an assembly browser that decompiles to C# and just does that, this is perfect. Even better if you are used to ReSharper, you will certainly find the keyboard shortcuts for navigation handy.

<h3>.NET Reflector</h3>
Last but not least, my personal choice .NET Reflector! I'm not really sure why this is my personal favorite but keep on reading and you might find that it's because the mixture of good functionality with a common and easy to use UI.

.NET Reflector is available by RedGate but costs money which is maybe why it's "better" than the alternatives. This wasn't always the case though once upon a time it was available for free. I was lucky enough to win a free license a while back so I've been able to use it quite a lot. You can buy it or grab a free trial over at <a href="http://www.red-gate.com/products/dotnet-development/reflector/" target="_blank">RedGate's website</a>.

The installation is easy and doesn't try to force you to install a lot of other things that you don't expect. .NET Reflector comes with a Visual Studio extension that will let you use the features in Visual Studio instead of starting a new instance of .NET Reflector.

Just as with JustDecompile and ILSpy I opened up the executable that we looked at before and as expected it shows the same result as ILSpy does!

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/DotNetReflector.png" alt=".NET Reflector" width="810" class="alignright size-full wp-image-1741" />

As you can see here the UI is quite minimal and easy to understand. What is interesting here is that it also allows us to view the code as F# code as you can see in the following image.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/DotNetReflector_FSharp.png" alt=".NET Reflector F#" width="810"  class="alignright size-full wp-image-1742" />

If we want to export the code that we have just as we did with ILSpy we can right click the assembly and select "Export source code" this then asks us where to store it and gives us information about the exported files. As you can see in the two following images it exported more files than ILSpy did.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/DotNetReflector_ExportCode.png" alt=".NET Reflector Export Code" width="810" class="alignright size-full wp-image-1745" />

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/DotNetReflector_ExportCode_2.png" alt=".NET Reflector Export Code Window" width="406" height="329" class="alignright size-full wp-image-1744" />

And the resulted files look exactly as we expect them to, the code file has the same code as we did in the original source code.

<h4>Pros</h4>
<li>Easy to use</li>
<li>Everything is intuitive</li>
<li>Everything work as intended</li>
<li>Exports more code than alternatives</li>
<li>Fast</li>
<li>Beautiful UI</li>

<h4>Cons</h4>
<li>It costs $199 if you want the VS Extension and this is quite expensive when good alternatives are completely free</li>

<h4>Summary</h4>
The costs is the only downside that I've found during my time using it which means that if .NET Reflector was free tool for Decompiling .NET Applications it would be the number 1 choice. It isn't free and the cost must be factored in when comparing the value of the product.

<h3>Conclusion</h3>
If I hadn't won a free license for .NET Reflector I probably would have used JustDecompile or ILSpy as both of them are very good tools for Decompiling .NET Applications!

We've looked at how we can decompile applications and browse the code in different ways when only having the executable available. This also works with libraries in the global assembly cache.

Looking around in the .NET Framework to see how they've done certain implementations can be great for educational purposes but using this at work to understand how someone implements a certain feature can be priceless.

I hope you've found this read interesting and that you'll be digging deeper with tools for Decompiling .NET Applications. Let me know which one is your favorite or if you've used another tool than the four mentioned above!
