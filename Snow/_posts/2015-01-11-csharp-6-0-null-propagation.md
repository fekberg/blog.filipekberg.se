---
layout: post
title: C# 6.0 - Null Propagation
date: 2015-01-11 00:00
author: fekberg
comments: true
metadescription: How to use Null Propagation in C# 6.0
categories: .NET, C#
tags: C# 6.0, CSharp, Null Propagation, .NET, dotnet, CSharp 6.0, C# 6, Reflector
---
The next version of C# brings a lot of sugar to the table, which we have looked at a few times already. Although, I think it will be interesting to look into a few of the features in more detail and of course look at what tools like reflector says about the code generated. To start this off I want to look at null propagation. This is one of my favourite language features in the upcoming version of C#. I think, and I hope, that this will change the amount of Null Reference Exceptions that we experience in our applications.

Let us start by just looking at the operator itself, it's simple and elegant. The null propagation operator looks like this: `?.`<!--excerpt-->

A question mark is commonly used throughout the language for evaluation of truth. For instance, it is used in in-line if statements. We have also seen double question marks used as a shorthand syntax for asking if an expression evaluates to null and if it does, we supply a value that is given instead of null. Not unlike these two cases, the question mark in the case of null propagation indicates that we will not proceed to what is on the right hand side if what is on the left is null.

We are most certainly going to see null propagation used together with the double question marks, as they very much completes each other!

In the following method, we expect a person to be passed and since there is no way for us to guarantee that what is passed to the method is not null, we might have a problem.

	public void TellMeYourName(Person person)
	{
	    person.SayMyName();
	}

We could of course introduce a guard, a simple check to see if what is passed to this method is null or not; with even more realistic examples this gets easily bloated. With null propagation, there is an easy fix. We can simply add a question mark, to ask if person is null or not.

	public void TellMeYourName(Person person)
	{
	    person?.SayMyName();
	}

It is a simple enough fix, but it ultimately changes the behaviour of the application. To the better? That depends on what you expect the method to do. What will happen here is that the entire expression will be evaluated to null, and since there is nothing else to be done in the method, it will be exited as if nothing was wrong. However, it was wrong, `person` shouldn't have been null in the first place. At least that what's we could assume. We solved the possible Null Reference Exception, but now the application might not work as expected, so we would still need to handle the case of it being incorrect.

In the case of the example above, we just have one null check, imagine though if we had more. The following example demonstrates a bit more complex scenario, where we have methods, properties and variables that might be or might return something that is null.

	users?.GetUser("Filip")?.GetRoles()?.IsAdministrator

The above example is interesting, what would you expect this to be? `IsAdministrator` is a `bool`, but as we are using null propagation it will instead be `bool?`. This means that you can no longer use it in an if statement like the following because it is a `bool?`:

	if(users?.GetUser("Filip")?.GetRoles()?.IsAdministrator) {}

Instead, you will have to specify what the value is (even if obvious) when the entire expression evaluates to null.

	if(users?.GetUser("Filip")?.GetRoles()?.IsAdministrator ?? false) {}

The above demonstrates how you could combine the use of `?.` and `??`. Let us step back, look at a simple example again, and see what happens when methods are invoked. Consider that we have the following structure; it is a person and an address with its expected relation.

    class Person
    {
        public Address GetAddress()
        {
        	Console.WriteLine("Getting the address!");

            return null;
        }
    }

    class Address
    {
        public string StreetName { get; set; }
    }

Given that we have the following code to get a person and print the name, what do you think will happen?

	Person person = new Person();

	Console.WriteLine(person?.GetAddress()?.StreetName);

When you use `?.` it will be converted into an in-line if-statement like you've most likely seen many times before. The first check if the person is null or not will result in the following:

	(person != null) ? person.GetAddress() : null

This means if person is not null, it'll go ahead and call `GetAddress()` on that instance and in case person would be null, it'll just say that the entire expression is null. So what happens with the rest of it? If we look at the entire expression in reflector, we will see something interesting (and not necessarily true!).

	Console.WriteLine((person != null) ? ((person.GetAddress() == null) ? null : person.GetAddress().StreetName) : null);

It's a bit worrying to see that `GetAddress()` is called twice and when I did my talk at [DDD Brisbane](https://www.filipekberg.se/2014/12/10/csharp-6-0/) I was a bit stunned when I saw this as I did not expect it! As you saw in the above example with the structure of the `Address` type, you see that I added a console output so that we can see if it is in fact called twice or not. Luckily enough, running this only results in one console output!

Let us look at the IL and see what it looks like! Funnily enough, Reflector does not really show the same result when looking at the IL!

	.method private hidebysig static void Main(string[] args) cil managed
	{
	    .entrypoint
	    .maxstack 2
	    .locals init (
	        [0] class NullPropagation.Person person)
	    L_0000: nop 
	    L_0001: newobj instance void NullPropagation.Person::.ctor()
	    L_0006: stloc.0 
	    L_0007: ldloc.0 
	    L_0008: brtrue.s L_000d
	    L_000a: ldnull 
	    L_000b: br.s L_001f
	    L_000d: ldloc.0 
	    L_000e: call instance class NullPropagation.Address NullPropagation.Person::GetAddress()
	    L_0013: dup 
	    L_0014: brtrue.s L_001a
	    L_0016: pop 
	    L_0017: ldnull 
	    L_0018: br.s L_001f
	    L_001a: call instance string NullPropagation.Address::get_StreetName()
	    L_001f: call void [mscorlib]System.Console::WriteLine(string)
	    L_0024: nop 
	    L_0025: ret 
	}

You see here that there is in fact just one call to `GetAddress()` and there's only one place where it jumps to this call. I would really encourage you to read the IL a few times, it is good practice and it is interesting (at least I think so) to understand what everything means.

We have seen how powerful null propagation can be, and hopefully you have gotten some answers to how you can use it in your applications. Keep in mind, we are hiding complexity behind syntactic sugar and this is just a nice and easy way for us to easily spot errors and not bloating our code with lots of if-statements.

Use with care!

Get a complete overview of what is new in C# 6.0 in my talk here:

<div class="video-container">
<iframe width="640" height="360" src="//www.youtube.com/embed/fNTf680fTHE" frameborder="0" allowfullscreen></iframe>
</div>
