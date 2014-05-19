---
layout: post
title: Invoke a dynamic object as if it were a method
date: 2011-10-03 17:10
author: fekberg
comments: true
metadescription: Invoke a dynamic object as if it were a method
categories: .NET, C#, Programming
tags: csharp, csharp 4, dotnet, dynamic, dynamic programming
---
In my previous post I talked about how you can extend the <a href="http://msdn.microsoft.com/en-us/library/system.dynamic.dynamicobject.aspx">DynamicObject</a> so that you can override TryInvokeMember and TryGetMember. However, these are not the only methods that you can override. I wanted to take a brief moment and talk about one of the other methods that you can override as well, this being <a href="http://msdn.microsoft.com/en-us/library/system.dynamic.dynamicobject.tryinvoke.aspx">TryInvoke</a>.<!--excerpt-->

According to MSDN this is the reason why you want to override <a href="http://msdn.microsoft.com/en-us/library/system.dynamic.dynamicobject.tryinvoke.aspx">TryInvoke</a>:
<blockquote>Provides the implementation for operations that invoke an object. Classes derived from the DynamicObject class can override this method to specify dynamic behavior for operations such as invoking an object or a delegate.</blockquote>
So whatever does this mean and how do you use it?

When we overrid TryInvokeMember that meant that we could call a method that actually was not implemented in our class like this: `myDynamicObject.SomeMethodToIvoke()`. In this case we assumed that `SomeMethodToInvoke` was a member of `myDynamicObject`.

So this leaves us with a method that lets us invoke something, that is not a member but an actual object, this means that we can invoke our object as if it were a method. We could pretty much write this:

    dynamic db = new Database();
    db(Operation.Refresh);

The operation-enum looks like this:

    enum Operation { FullReset, Refresh, Update };


Without changing anything in the Database-class that was created in the previous post, we will get this exception "Cannot invoke a non-delegate type" but if we add the following and compile again, everything will work out nicely!

    public override bool TryInvoke(InvokeBinder binder, object[] args, out object result)
    {
        result = null;

        return true;
    }

Exactly as I did with TryInvokeMember, I can get all information that I need out from the binder and args. In this case args will contain of one item with the value Refresh and if we add some more code here it could somewhat turn out like this:

    public override bool TryInvoke(InvokeBinder binder, object[] args, out object result)
    {
        result = null;

        switch ((Operation)args[0])
        {
            case Operation.Refresh:
                // Refresh the context
                break;
        }

        return true;
    }

Again, I am not saying this is what you should do, it's just a way to demonstrate the different options you have when working with dynamic types in .NET. 

I hope you had fun and learned something!