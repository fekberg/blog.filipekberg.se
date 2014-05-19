---
layout: post
title: Calling a dynamic method from a dynamic method
date: 2011-10-16 20:32
author: fekberg
comments: true
metadescription: Calling a dynamic method from a dynamic method
categories: .NET, C#, Programming
tags: csharp, dotnet, dynamic, dynamic programming, reflection
---
Let's take a look at how we can call a method from a dynamic method. In the last post we looked at how we called a static method in our current context, but let's take a look at how we can call another dynamically created method that takes an integer parameter and then does some math operation on it and then returns it.

First off we need to create this method, we're just going to use IL that we've seen before and I am going to add the input parameter with 2. The dynamic method will look like this with the emitted IL<!--excerpt-->:

    var addMethod = new DynamicMethod(
            "AddMethod",
            typeof(int),
            methodArguments,
            typeof(Program).Module
        );
    var il = addMethod.GetILGenerator();

    il.Emit(OpCodes.Ldarg_0);
    il.Emit(OpCodes.Ldc_I4, 2);
    il.Emit(OpCodes.Add);
    il.Emit(OpCodes.Ret);

So we load the first argument onto the evaluation stack, then we add a 4 byte integer with the value of 2 onto the evaluation stack and last we call <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.add.aspx">`OpCodes.Add`</a>.

I don't know if you've noticed this before, but Dynamic Method derives from <a href="http://msdn.microsoft.com/en-us/library/system.reflection.methodinfo.aspx">`MethodInfo`</a>, which means that we can just call this method!

We've got the following code from the last blog post:

    var mathOperation = new DynamicMethod(
            "AdvanceMathOperationMethod",
            typeof(void),
            methodArguments,
            typeof(Program).Module);

    il = mathOperation.GetILGenerator();
    var methods = typeof(Program).GetMethods();

In both these dynamic methods, we use the variable methodArguments that we've also seen before:

    Type[] methodArguments = { 
                    typeof(int)
    };

It just says that we expect an integer parameter sent to the method. Let's take a look at the IL we're going to emit, first of all we want to load the argument onto the evaluation stack then we want to add the value 10 and multiply these and pass the result as a parameter to the add method.

So this code is the same from the last blog post:

    il.Emit(OpCodes.Ldarg_0);
    il.Emit(OpCodes.Ldc_I4, 10);
    il.Emit(OpCodes.Mul);

So now we're prepared to call the dynamic add method we've created and since it derives from <a href="http://msdn.microsoft.com/en-us/library/system.reflection.methodinfo.aspx">`MethodInfo`</a> we can just do this:

    il.Emit(OpCodes.Call, addMethod);

Since the result from the multiplication is already on the evaluation stack it's also the first argument that this method gets!

The Add method in the dynamic add method we've created will also have it's value on the evaluation stack, so let's print it with our static method from the last blog post:

    il.Emit(OpCodes.Call, methods.First(x => x.Name == "PrintWithSpecificFormat"));
    il.Emit(OpCodes.Ret);

And now if we invoke this:

    var toInvoke = (Action<int>)mathOperation.CreateDelegate(typeof(Action<int>));
    toInvoke(10);

we should see this printed:

`The value is: 102`

I hope you found this interesting and if you have any thoughts please leave a comment below!