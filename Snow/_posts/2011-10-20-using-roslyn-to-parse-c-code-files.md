---
layout: post
title: Using Roslyn to parse C# code files
date: 2011-10-20 23:05
author: fekberg
comments: true
metadescription: Roslyn allows you to analyse and parse C# and VB code, this is how you parse a C# Code file.
categories: .NET, C#, Programming
tags: compiler technology, csharp, dotnet, parsing, roslyn
---
A couple of days ago Microsoft released something called the Roslyn Project and it is now in it's CTP state, just as Async! But what is Roslyn and what can it be used for? In the previous post I talked about how I wrote assembler that was generated from an application that parsed some programming language, but what I didn't do was the actual parsing of code. Actually parsing code is not only relevant when you want to write a compiler, it is also useful when you want to evaluate how good a certain chunk of code is.<!--excerpt-->

There are a lot of really good software out there that will help you analyze your code, some of them analyze the code after it has been compile such as a software called <a href="http://www.ndepend.com/">NDepend</a>, which is a really good tool. Another program that is commonly used is <a href="http://www.jetbrains.com/resharper/">ReSharper</a>, from what I know, ReSharper analyzes the code structure without actually compiling it all the way down to IL.

<strong>You can call this parsing+evaluating</strong>, when you add the extra step that actually generates new code I would call it a compiler. However, let's get back to Roslyn. So the project places themselves on the market saying that before roslyn the C# and VB.NET compiler were just a black box with no integration capabilities, what roslyn does is that it opens up the black box and allowing an interface between your code and the compiler.

What this means is that you can parse a code file that haven't been compiled yet and get a nice structure out of it that you can do whatever you like with. To get started with Roslyn, this is what you need to do:

<ul>
	<li><a href="http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=21835">Install the Visual Studio 2010 SP1 SDK</a></li>
	<li><a href="http://www.microsoft.com/download/en/details.aspx?id=27746">Install the Roslyn CTP</a></li>
	<li>Run this file to install the template into Visual Studio: `C:\Program Files (x86)\Microsoft Codename Roslyn CTP\Extensions\Roslyn.VisualStudio.Setup.vsix`</li>
</ul>

When all this is installed, open up Visual Studio and create a new Roslyn C# Console Application

<img src="http://dl.dropbox.com/u/4396175/roslyn_1.png" style="width: 800px;" alt="" />

Now create a new folder called ToParse and add a class to it with some fields and methods

<img src="http://dl.dropbox.com/u/4396175/roslyn_2.png" alt="" />

So now we have this Person class that we want to parse, here's to code so you can just copy/paste it:

    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    namespace HelloWorldAnalyzer.ToParse
    {
        public class Person
        {
            public string Name { get; private set; }
            public Person(string name)
            {
                Name = name;
            }
            public string Speak()
            {
                return string.Format("Hello! My name is{0}",
                    Name);
            }
        }
    }

<strong>Now go back to the main method and let's get started with the parsin!</strong>

The first thing that I want to do is to just read the text inside the file, for the purpose of this example I'll do it like this:

    var code = new StreamReader("..\\..\\ToParse\\Person.cs").ReadToEnd();

We go back two folders ( ..\..\ ) because the application will run from the bin\Debug\ folder!

Next up we want to get something that is called a SyntaxTree from our code, here's a good illustration of what a SyntaxTree is:

<img src="http://www.math.wpi.edu/IQP/BVCalcHist/Image165.gif" alt="" />

So we get this tree by doing this:

    SyntaxTree tree = SyntaxTree.ParseCompilationUnit(code);

Now we want to retrieve the root of the tree:

    var root = (CompilationUnitSyntax)tree.Root;

Next up I want to print all the using-blocks in the class file that we just parsed on the `CompilationUnitSyntax` instance we have a property called Usings, we can use this to get a list of `UsingDirectiveSyntax`

    foreach(var usingBlock in root.Usings)
    {
        Console.WriteLine("Using block: {0}", usingBlock.Name);
    }

This will print all the using blocks and will result in something like this:

    Using block: System
    Using block: System.Collections.Generic
    Using block: System.Linq
    Using block: System.Text

Now let's do something a bit more fun, let's retrieve all the nodes in the syntax tree and look for a LiteralExpressionSyntax, which actually will be the string inside the `Speak()` method!

We do this by first getting all the descendent nodes from the root and just get the first literal expression syntax that we find:

    var personSpoke =   root.DescendentNodes()
                        .OfType<LiteralExpressionSyntax>()
                        .FirstOrDefault();

If we write this to the console as well we should see the following:

<img src="http://dl.dropbox.com/u/4396175/roslyn_3.png" alt="" />

This is just the bare surface of what you can do with Roslyn, there are some Very interesting resources to look through. <a href="http://www.microsoft.com/download/en/details.aspx?id=27745">Here's an MSDN page with a lot of documents on how you do certain things in Roslyn.</a> Be sure to check that out! So far we've just done the parsing step, but you can also do compilation with it since it exposes all the different steps of the C# and VB.NET compiler.

I hope you found this interesting because I had a lot of fun writing it and if you have any thoughts please leave a comment below!