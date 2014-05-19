---
layout: post
title: Getting all methods from a code file with Roslyn
date: 2011-10-21 15:34
author: fekberg
comments: true
metadescription: Getting all methods from a code file with Roslyn
categories: .NET, C#, Programming
tags: compiler technology, csharp, dotnet, parsing, roslyn
---
In the previous post we started looking at Roslyn and let's continue on this topic and see what else we can get out of it! I want to take a look at how we can retrieve all methods and get some information about them. I've added another method to the Person-class so it looks like this now<!--excerpt-->:

    public class Person
    {
        public string Name { get; private set; }
        public Person(string name)
        {
            Name = name;
        }
        public void Evaporate()
        {
                
        }
        public string Speak()
        {
            string str = "test";
            return string.Format("Hello! My name is{0}",
                Name);
        }
    }

We've already got the tree-structure and the root node so let's just use that. Everything is represented as a SyntaxNode so we need to get all the descending nodes that are methods, methods are declared as `MethodDeclarationSyntax`. So all methods are retrieved like this:

    IEnumerable<MethodDeclarationSyntax> methods = tree.Root
                .DescendentNodes()
                .OfType<MethodDeclarationSyntax>().ToList();

No we can just iterate over this:

    foreach(var method in methods)
    {
    }

However, you might be a bit confused as to how you print the method name, because there's not a Name-property on the object! Instead there is something called an Identifier that we can use:

    foreach(var method in methods)
    {
        Console.WriteLine(method.Identifier);
    }

This will print all methods and not including the constructors, if we want to get the constructors we ask for `ConstructorDeclarationSyntax` instead of `MethodDeclarationSyntax`. We can get a lot of interesting things from the method-object in the iterator, we can ask about the parameters, the return type and a lot of other nice things.

I hope you found this interesting, if you have any thoughts please leave a comment below!