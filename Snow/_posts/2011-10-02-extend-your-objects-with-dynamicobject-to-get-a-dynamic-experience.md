---
layout: post
title: Extend your objects with DynamicObject to get a dynamic experience
date: 2011-10-02 18:43
author: fekberg
comments: true
metadescription: Extend your objects with DynamicObject to get a dynamic experience
categories: .NET, C#, Programming
tags: csharp, csharp 4, dotnet, dynamic, dynamic programming
---
If you have ever programmed in a dynamic programming language you know that you can pretty much ask for anything on any object, consider this code in any dynamic programming language:<!--excerpt-->

    var person = new Person();
    person.Name = "Filip";
    person.Location = "Gothenburg";

In the Person-structure used above, the property Location actually doesn't exist, but in a dynamic programming language this is completely valid to do even if it doesn't. You might wonder why you would ever want to be able to call on something that doesn't exist; I will get back to that a bit further down this post.

First, let us take a look at how you would achieve something like this in C#!

Consider that we already have a class that is called "Database", this class handles all communication with our data base or our data layer. To make my Database-class dynamic, I am going to extend it with <a href="http://msdn.microsoft.com/en-us/library/system.dynamic.dynamicobject.aspx">DynamicObject</a>. Extending with DynamicObject will allow me to override a lot of interesting methods, these two are the ones that are interesting to us now:

<ul>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.dynamic.dynamicobject.trygetmember.aspx">TryGetMember</a></li>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.dynamic.dynamicobject.tryinvokemember.aspx">TryInvokeMember</a></li>
</ul>

So what do these two methods actually allow us to do? `TryGetMember` will be invoked each time you try to access a member on the object, like a property or a field. `TryInvokeMember` will be invoked each time you try to invoke a method on the object.

If we take the first code sample from this post and compile it Visual Studio, we will get an error telling us that "Person does not contain a definition for Location" ( assuming that we have the same Person-structure here as well! ). 

To avoid this, we say that the object that we are instantiating is dynamic, so in our case we have the following class defined:

    class Database : DynamicObject

Our instatiation looks like this:

    dynamic db = new Database();

Let's take a look at the methods we want to override in our Database class now, both of these methods share two parameters these are:

<ul>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.dynamic.dynamicmetaobjectbinder.aspx">DynamicMetaObjectBinder </a>( <a href="http://msdn.microsoft.com/en-us/library/system.dynamic.invokememberbinder.aspx">InvokeMemberBinder </a>and <a href="http://msdn.microsoft.com/en-us/library/system.dynamic.getmemberbinder.aspx">GetMemberBinder </a>)
</li>
	<li>out object result</li>
</ul>

The first parameter is used to get information about what the caller expects such as: 
<ul>
	<li>What name was used? ( Property name, Method name )</li>
	<li>What return type is expected?</li>
	<li>How many arguments did we pass along? ( Only for InvokeMemberBinder )</li>
	<li>What are the argument names? ( Only for InvokeMemberBinder )</li>
</ul>

The second argument is used to set the return value and as for TryInvokeMember, we have another parameter as well, the actual arguments.

Both TryInvokeMember and TryGetMember returns a boolean that tell us if the operation succeeded or not. You might want to return false if you don't support the property/method that was called.

So what can you do with this? Let's take a look at some real code here!

When using the instance of our Database class I want to be able to do the following:

    var products = db.Products.All();

I will not be doing any database code here, I just want to cover how to use the DynamicObject, so let's take a look at that. First of all I override both `TryInvokeMember` and `TryGetMember`, the first method of these that will be called in the above statement is the `TryGetMember`.

In order to allow this fluent style of code I want me `TryGetMember` to look like this:

    public override bool TryGetMember(GetMemberBinder binder, out object result)
    {
        Table = binder.Name;
        result = this;
        return true;
    }

What I do here is that I have a property inside my Database class that is called "Table" which just holds the name of the current table that I am working with, then I return myself as a result and finally I return true which indicates that the call worked.

The above will allow me to write db.Products and this will return our Database class with the Table-name set to "Products".

Now the easy part is over, the next step can be as complicated as you want since you have the binder-parameter, you can get information about the Name, Arguments and Return type. What I want to do is to check if the Name of the method that I want to invoke starts with "Select" then I can ( if I want ) later on check if it is SelectAll, SelectFirst, SelectRandom and so on.

With that out of the way, all I want to do is to set the result to whatever my select returns, in this example I will just set it to null for the sake of this example.

    public override bool TryInvokeMember(InvokeMemberBinder binder, object[] args, out object result)
    {
        if (binder.Name.StartsWith("Select"))
        { 
            // SelectFirst, SelectAll, SelectAny, SelectRandom
            result = null;
        }
        else {
            result = null;
        }

        return true;
    }

By using the above code, the following compiles and runs perfectly!

    dynamic db = new Database();
    db.Products.SelectAll();

If you debug this, you see that TryGetMember is first accessed, the SelectAll is invoked on the returned object which takes us to TryInvokeMember where it checks what kind of method we tried to invoke.

As you can see, this opens up a whole new world of dynamic usage! In my last post, I mentioned Simple.Data and that they made use of dynamic very well, their ORM works pretty much like this and is very neat for smaller applications.

I am not saying that everything should be dynamic, but once in a while it might actually be a product step to take this approach. Just take a look at Simple.Data and you'll see what I mean.

Hope you had fun and learned something!
