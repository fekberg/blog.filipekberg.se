---
layout: post
title: Creating a Dynamic Method that uses a Switch
date: 2011-10-18 22:32
author: fekberg
comments: true
metadescription: Creating a dynamic method can be powerful, in this article we take a look at how we can create one with a switch inside it.
categories: .NET, C#, Programming
tags: csharp, dotnet, dynamic, dynamic programming, reflection
---
We've looked at some very interesting Dynamic Method creation in the last posts and let's keep this up! We've looked at how we can compare values and then jump somewhere if the comparison is evaluates to true. Now let's take a look at how we can implement a switch!<!--excerpt-->

So I was thinking that I wanted to create the following method as a dynamic method:

    int Calculate(int a, int b, int operation)
    {
        switch(operation)
        {
            case 0:
                return a + b;
            case 1:
                return a * b;
            case 2:
                return a / b;
            case 3:
                return a - b;
            default:
                return 0;
        }
    }

Basically it takes three integers, the first two integers are the ones that I do the mathematical operation on and the last argument tells the switch statement which of the operation to run. We already know how to do almost everything that we are about to look at, these are the following operation codes that we've seen before that we're going to see again in this post:

<ul>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarg_0.aspx">`OpCodes.Ldarg_0`</a></li>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarg_1.aspx">`OpCodes.Ldarg_1`</a></li>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarg_2.aspx">`OpCodes.Ldarg_2`</a></li>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldc_i4.aspx">`OpCodes.Ldc_I4`</a></li>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.mul(v=vs.80).aspx">`OpCodes.Mul`</a></li>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.div.aspx">`OpCodes.Div`</a></li>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.add.aspx">`OpCodes.Add`</a></li>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.sub.aspx">`OpCodes.Sub`</a></li>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ret.aspx">`OpCodes.Ret`</a></li>
</ul>

There are just two operations that we haven't looked at yet that we are going to use here and that is <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.switch.aspx">`OpCodes.Switch`</a> and <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.br_s.aspx">`OpCodes.Br_S`</a>, we'll see how these are used a bit further down.

But first off let's take a look at how we get started, as we've done before we create our <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.dynamicmethod.aspx">`DynamicMethod`</a> instance:

    Type[] methodArguments = { 
        typeof(int),
        typeof(int),
        typeof(int)
    };

    var calculateMethod = new DynamicMethod(
            "Calculate",
            typeof(int),
            methodArguments,
            typeof(Program).Module);

The method will have three arguments and a return type of integer and we're going to call it "Calculate". Next up get the IL-generator:

    var il = calculateMethod.GetILGenerator();

<strong>Let's start emitting some IL!</strong>

However, before we do that, we need to define a couple of targets for our switch to jump to, if you've read the previous post you might remember that an if-statement evaluates something and if it's true, it jumps into it's context. It's the same with a switch-statement.

You provide a value that the switch statement bases it's evaluation on and then you give it entry points to where it can jump. By looking at the method we are trying to convert we have 4 different labels to where we want to jump and one default label.

So first of all we create our 5 labels like this:

    var defaultCase = il.DefineLabel();
    var endOfMethod = il.DefineLabel();
    Label[] jumpTable = new [] {    il.DefineLabel(),
    					            il.DefineLabel(),
    					            il.DefineLabel(),
    					            il.DefineLabel() };

Now we've prepared the jump table, so we can start look at the beginning of the method. And the first thing we want to do in the method is to perform a switch on our third argument, so what we need to do is to add the third argument to the evaluation stack and call the switch operation:

    // Perform switch
    il.Emit(OpCodes.Ldarg_2);
    il.Emit(OpCodes.Switch, jumpTable);

The next thing we need to do is, if the switch didn't jump anywhere, we need to define the default case and that is done like this:

    il.Emit(OpCodes.Br_S, defaultCase);

We just emit the call because if it goes pass the Switch-operation, it didn't find what it was looking for! Now next up is four almost identical operations. What we do is that we first of all mark a label saying where the current case is and then we load our two first arguments on to the evaluation stack and then we perform the mathematical operation and jump to the end of the method, it will look something like this:

    // Case 0 - Perform Add on Ldarg_0 and Ldarg_1
    il.MarkLabel(jumpTable[0]);
    il.Emit(OpCodes.Ldarg_0);
    il.Emit(OpCodes.Ldarg_1);
    il.Emit(OpCodes.Add);
    il.Emit(OpCodes.Br_S, endOfMethod);

<strong>Can you guess what the next case will look like?</strong>

Actually I am just going to give you the next three math operations!

    // Case 1 - Perform Mul on Ldarg_0 and Ldarg_1
    il.MarkLabel(jumpTable[1]);
    il.Emit(OpCodes.Ldarg_0);
    il.Emit(OpCodes.Ldarg_1);
    il.Emit(OpCodes.Mul);
    il.Emit(OpCodes.Br_S, endOfMethod);

    // Case 2 - Perform Div on Ldarg_0 and Ldarg_1
    il.MarkLabel(jumpTable[2]);
    il.Emit(OpCodes.Ldarg_0);
    il.Emit(OpCodes.Ldarg_1);
    il.Emit(OpCodes.Div);
    il.Emit(OpCodes.Br_S, endOfMethod);

    // Case 3 - Perform Sub on Ldarg_0 and Ldarg_1
    il.MarkLabel(jumpTable[3]);
    il.Emit(OpCodes.Ldarg_0);
    il.Emit(OpCodes.Ldarg_1);
    il.Emit(OpCodes.Sub);
    il.Emit(OpCodes.Br_S, endOfMethod);

As you can see, the only difference is the operation for the math operation and the label that we mark! Now we've almost reached the end of the method, so we need to define what happens if it was a default value or not and then return our value, since all the above operations have put the value on the evaluation stack, we are good to go!

    il.MarkLabel(defaultCase);
    il.Emit(OpCodes.Ldc_I4, 0);

    il.MarkLabel(endOfMethod);

    il.Emit(OpCodes.Ret);

If it's the default case, all we do is add a 4 byte integer to the evaluation stack with the value 0 and then return from the method!

<strong>Let's try it out!</strong>

    var calculate = 
        (Func<int, int, int, int>)calculateMethod.CreateDelegate(typeof(Func<int, int, int, int>));
    var result = calculate(1, 2, 0); // 3
    result     = calculate(1, 2, 1); // 2
    result     = calculate(1, 2, 2); // 0
    result     = calculate(1, 2, 3); // -1

Here's the entire code that I used above:

    Type[] methodArguments = { 
    	typeof(int),
        typeof(int),
        typeof(int)
    };

    var calculateMethod = new DynamicMethod(
    		"Calculate",
    		typeof(int),
    		methodArguments,
    		typeof(Program).Module);

    var il = calculateMethod.GetILGenerator();

    var defaultCase = il.DefineLabel();
    var endOfMethod = il.DefineLabel();
    Label[] jumpTable = new [] {    il.DefineLabel(),
    								il.DefineLabel(),
    								il.DefineLabel(),
    								il.DefineLabel() };

    // Perform switch
    il.Emit(OpCodes.Ldarg_2);
    il.Emit(OpCodes.Switch, jumpTable);

    // Default case
    il.Emit(OpCodes.Br_S, defaultCase);

    // Case 0 - Perform Add on Ldarg_0 and Ldarg_1
    il.MarkLabel(jumpTable[0]);
    il.Emit(OpCodes.Ldarg_0);
    il.Emit(OpCodes.Ldarg_1);
    il.Emit(OpCodes.Add);
    il.Emit(OpCodes.Br_S, endOfMethod);

    // Case 1 - Perform Mul on Ldarg_0 and Ldarg_1
    il.MarkLabel(jumpTable[1]);
    il.Emit(OpCodes.Ldarg_0);
    il.Emit(OpCodes.Ldarg_1);
    il.Emit(OpCodes.Mul);
    il.Emit(OpCodes.Br_S, endOfMethod);

    // Case 2 - Perform Div on Ldarg_0 and Ldarg_1
    il.MarkLabel(jumpTable[2]);
    il.Emit(OpCodes.Ldarg_0);
    il.Emit(OpCodes.Ldarg_1);
    il.Emit(OpCodes.Div);
    il.Emit(OpCodes.Br_S, endOfMethod);

    // Case 3 - Perform Sub on Ldarg_0 and Ldarg_1
    il.MarkLabel(jumpTable[3]);
    il.Emit(OpCodes.Ldarg_0);
    il.Emit(OpCodes.Ldarg_1);
    il.Emit(OpCodes.Sub);
    il.Emit(OpCodes.Br_S, endOfMethod);

    il.MarkLabel(defaultCase);
    il.Emit(OpCodes.Ldc_I4, 0);
                    
    il.MarkLabel(endOfMethod);

    il.Emit(OpCodes.Ret);

    var calculate = 
        (Func<int, int, int, int>)calculateMethod.CreateDelegate(typeof(Func<int, int, int, int>));

    var result = calculate(1, 2, 3);


I hope you found this interesting because I had a lot of fun writing it and if you have any thoughts please leave a comment below!
