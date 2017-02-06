---
layout: post
title: Using the C# Interactive Window that comes with Roslyn
date: 2011-11-14 19:43
author: fekberg
comments: true
metadescription: What can we do with the Roslyn Interactive Window? A C# REPL can help you explore language features without a big fuss.
categories: .NET, C#, Programming
tags: csharp, dotnet, productivity, roslyn
---
I often find myself wanting to explore new options and see what is possible to do and what is not, at other times I might really need to test something fast just to see if my concept will work. In the past I've either created a test for this, mocking the stuff that I need and then finding myself debugging the test. Or I just write a method and use my test-extension to invoke the method that I right click ( cool feature from TestDriven.NET ).<!--excerpt-->

While both of these tend to work out very well and the first one might even be a good approach, since we all want 100% code coverage! But, what about the times when you just want to explore something or just test something out? If you're an F# developer you might have seen the F# Interactive Window that looks like this:

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/fsharp_interactive_1.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/fsharp_interactive_1.png" alt="" title="fsharp_interactive_1" width="683" height="486" class="alignnone size-full wp-image-460" /></a>

With this we can explore F# and write code that is evaluated directly, this is called REPL which is short for <a href="http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop">Read-eval-print loop</a>. This means that we can create statements like this

	let x = 10;;

And then it will print:

	val x : int = 10

Which means it will look somewhat like this in your F# Interactive Window:

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/fsharp_interactive_2.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/fsharp_interactive_2.png" alt="" title="fsharp_interactive_2" width="683" height="486" class="alignnone size-full wp-image-462" /></a>

I can tell you, this is very, very, very(!) useful at some times, I found myself wanting to test a regex in a couple of different ways and having an Interactive Window like this is very helpful. The above is for F# and is built into Visual Studio, but what about a C# Interactive Window?

Out of the box, there is none. But if you install Roslyn ( which is a CTP at the moment ) you'll get one! You'll find it just below the F# Interactive Window in:

	View -> Other Windows -> C# Interactive Window

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_1.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_1.png" alt="" title="csharp_interactive_1" width="800" height="745" class="alignnone size-full wp-image-464" /></a>

The C# Interactive Window looks very much like the F# one:

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_2.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_2.png" alt="" title="csharp_interactive_2" width="721" height="486" class="alignnone size-full wp-image-465" /></a>

You might have notice that I haven't said that you need to create a new project, this is because you don't have to, you can just fire up Visual Studio and start playing around in the C# Interactive Window! Now let's see what this baby can do!

We can start off by checking the help, you do this by writing #help and pressing enter, notice while you write that you have intellisense here!

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_3.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_3.png" alt="" title="csharp_interactive_3" width="720" height="488" class="alignnone size-full wp-image-466" /></a>

The help-text isn't that long, read through it and understand the different key-shortcuts for executing segments of code. There is another built in command that you might find useful and that is "cls" which for all you none-DOS-aware people is short for "clear screen". All the built in commands are executed by writing a leading "#" so to clear the screen, simply write the following and press enter:

	#cls

Now let's see if we can download the contents for this blog using a WebClient, if you start off by just writing

	var client = new WebClient()

You'll see that `WebClient` isn't known where and we get a underscore below the W which indicates that we can press ctrl+dot and import the namespace!

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_4.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_4.png" alt="" title="csharp_interactive_4" width="719" height="198" class="alignnone size-full wp-image-467" /></a>

Once it is imported, it will look like this:

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_5.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_5.png" alt="" title="csharp_interactive_5" width="721" height="178" class="alignnone size-full wp-image-468" /></a>

Now let's download some data! Add the following on the next line:

	var data = client.DownloadString("https://www.filipekberg.se");

When you press enter, the statement will be executed and this might take a couple of seconds. Notice that nothing has been printed out or evaluated yet and by that I mean, in the F# Interactive Window after each statement you got some data printed out about what the last statement generated, that's not the case in the C# Interactive Window, but! If you write the name of the variable we just created, you'll see something pretty cool!

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_6.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_6.png" alt="" title="csharp_interactive_6" width="721" height="284" class="alignnone size-full wp-image-469" /></a>

Here's a final example of what you can do:

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_7.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/11/csharp_interactive_7.png" alt="" title="csharp_interactive_7" width="721" height="284" class="alignnone size-full wp-image-475" /></a>

I think this is a very nice tool to use when you just want to try stuff out, I found myself wanting to try some different regexes so I fired up the C# Interactive Window and started testing and the easiness of just dumping out what stuff is, it's pretty neat!

I hope you found this interesting, if you have any thoughts please leave a comment below!