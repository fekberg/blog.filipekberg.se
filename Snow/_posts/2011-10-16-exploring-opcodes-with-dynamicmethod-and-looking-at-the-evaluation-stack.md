---
layout: post
title: Exploring OpCodes with DynamicMethod and looking at the evaluation stack
date: 2011-10-16 00:40
author: fekberg
comments: true
metadescription: Have a look at how the Evaluation Stack behaves when you create a DynamicMethod with OpCodes
categories: .NET, C#, Programming
tags: csharp, dotnet, dynamic, dynamic programming, reflection
---
In the previous post we looked at how our `DynamicMethod` could pass a value to another method, let's take a look at something a little bit more interesting! Consider that I want to have a method that takes an integer and this integer is manipulated and then printed out by this method. In this case, the manipulation is a multiplication and the second method is just a method to print the result in a nicely formatted way.<!--excerpt-->

<strong>This is what we have</strong>, from the previous post. First of all we got the method that prints it in a formatted way, I've renamed it for clarity in this post:

	public static void PrintWithSpecificFormat(int a)
	{
	    Console.WriteLine("The value is: {0}", a);
	}

The second thing we have is the `DynamicMethod`, however, I've made two changes here, instead of taking zero parameters, I am now taking an integer parameter, secondly I've renamed it to something more understandable:

	Type[] methodArguments = { 
	                            typeof(int)
	};

	var mathOperation = new DynamicMethod(
	        "AdvanceMathOperationMethod",
	        typeof(void),
	        methodArguments,
	        typeof(Program).Module);

	ILGenerator il = mathOperation .GetILGenerator();
	var methods = typeof(Program).GetMethods();

Now let's start off by looking at the operations that we are going to emit. First of all we need to load the argument that we pass onto the evaluation stack this is done by <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarg_0.aspx">`OpCodes.Ldarg_0`</a>. Before we look at the other operations, notice that I mentioned the evaluation stack here, from now on it's important to understand a little bit about the evaluation stack. Values are pushed and popped onto the evaluation stack and certain operations except values to already be on the evaluation stack.

If you don't know what a stack is, here's a quick little intro with a bit of <a href="http://en.wikipedia.org/wiki/Stack_(abstract_data_type)">help from our friend Wikipedia</a>. First of all, this is what a stack might look like when represented on a paper:

<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Data_stack.svg/200px-Data_stack.svg.png" alt="" />

As you can see, elements that are pushed onto the stack, is "stacked" on top of the old values and when you want to pop something, you always take out the last item that was added. This is called LIFO which stands for <strong>Last In First Out</strong>.

So if we now apply this knowledge and start thinking about how the evaluation stack works and why it's important you might see that operations such as <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.mul(v=vs.80).aspx">`OpCodes.Mul`</a> expects there to be two values that it can pop from the stack then when it's popped them, the values are multiplied and the result is pushed back onto the evaluation stack for the caller to use.

<strong>This is what it looks like</strong> when we want to multiply 10 by 20

First the value 10 is pushed onto the stack
<img src="http://dl.dropbox.com/u/4396175/evaluationstack/1.png" alt="" />

Then the value 20 is pushed onto the stack
<img src="http://dl.dropbox.com/u/4396175/evaluationstack/2.png" alt="" />

Then we call <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.mul(v=vs.80).aspx">`OpCodes.Mul`</a> and it starts off by popping the first value
<img src="http://dl.dropbox.com/u/4396175/evaluationstack/3.png" alt="" />

The it pops the second value
<img src="http://dl.dropbox.com/u/4396175/evaluationstack/4.png" alt="" />

After the multiplication is done, the result is pushed onto the stack
<img src="http://dl.dropbox.com/u/4396175/evaluationstack/5.png" alt="" />

This is the general pattern used, things are pushed onto the evaluation stack and then operations pops the values they want to use and then pushes a possible result back onto the evaluation stack. So how do we proceed now?

We already got the first value on the evaluation stack, let's say that whatever we pass into our dynamic method will be multiplied by 10, since we did <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarg_0.aspx">`OpCodes.Ldarg_0`</a> we only need to emit code that adds our next value!

This is done exactly as we did in the last post:
	
	il.Emit(OpCodes.Ldc_I4, 10);

If the parameter sent to the dynamic method is 20 now, the stack will look like this:

<img src="http://dl.dropbox.com/u/4396175/evaluationstack/6.png" alt="" />

Now let's do the multiplication, this is done by emitting <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.mul(v=vs.80).aspx">`OpCodes.Mul`</a>: 

	il.Emit(OpCodes.Mul);

So what now? We want to pass the result from the multiplication operation to the `PrintWithSpecificFormat` method and how do we pass values again?

<strong>By pushing them to the evaluation stack!</strong>, but wait a minute, the result is already on the evaluation stack so we don't need to do anything! We can just call the method as we like. The complete IL-emitting looks like this:

	il.Emit(OpCodes.Ldarg_0);
	il.Emit(OpCodes.Ldc_I4, 10);
	il.Emit(OpCodes.Mul);
	il.Emit(OpCodes.Call, methods.First(x => x.Name == "PrintWithSpecificFormat"));
	il.Emit(OpCodes.Ret);

Now the last thing we are going to do is creating the delegate and invoking it, we can use `Action<T>` as we did in the last post and then we just invoke the created delegate:

	var toInvoke = (Action<int>)mathOperation.CreateDelegate(typeof(Action<int>));
	toInvoke(10);

The result should look like this:

<img src="http://dl.dropbox.com/u/4396175/evaluationstack/7.png" alt="" />

I hope you found this interesting and if you have any thoughts please leave a comment below!