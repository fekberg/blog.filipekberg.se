---
layout: post
title: Creating static methods at runtime
date: 2011-10-11 22:27
author: fekberg
comments: true
metadescription: Creating static methods at runtime
categories: .NET, C#, Programming
tags: csharp, dotnet, reflection
---
Lately we've been looking at how we can get and set information on known structures during runtime, we've also looked at how we can invoke methods in our classes. Let's kick it up a notch and look at how we can add static methods during runtime. This means that we want to add a method with a known return value and known parameters. It's not always the case that you know the return type nor the parameter types, but in this example we will.<!--excerpt-->

Let's look at solving a simple problem, I want to create a method that takes two parameters and returns a result from a computation. The two parameters will be of type integer and the return type will be of type double thus you might have figured that I am going to do a division.

Creating a method that divides two integers for us and return a double is simple, it could look like this, without worrying about loss of fraction:

	double Divide(int a, int b)
	{
	    return a / b;
	}

However, I don't want to create the method body for it like this, the implementation for this method should be created in runtime, dynamically! We will still need to know the method signature, so we will have a delegate that defines what our division-methods should look like:

	delegate double DivideInvoker(int a, int b);

Before we continue, let go of the mouse and keyboard and just think for a bit, when would this really be useful? Consider that we are writing our own language, or creating a compiler for a known language. We need to be able to somehow create methods and invoke them, that's what we are trying to do here. So basically you can use this if you create a compiler or just for educational purposes! 

So in order for use to be able to create our method dynamically, we need to use `DynamicMethod` which lives inside this namespace `System.Reflection.Emit`. Creating methods like this will give us the following benefits according to <a href="http://msdn.microsoft.com/en-us/library/sfk2s47t.aspx">MSDN</a>:


<ul>
	<li>They have less overhead, because there is no need to generate dynamic assemblies, modules, and types to contain the methods.</li>
	<li>In long-running applications, they provide better resource utilization because the memory used by method bodies can be reclaimed when the method is no longer needed.</li>
	<li>Given sufficient security permissions, they provide the ability to associate code with an existing assembly or type, and that code can have the same visibility as internal types or private members.</li>
	<li>Given sufficient security permissions, they allow code to skip just-in-time (JIT) visibility checks and access the private and protected data of objects.</li>
</ul>

You might ask why we don't just use reflection to run `InvokeMember` on a dynamic type or something like that, <a href="http://msdn.microsoft.com/en-us/library/sfk2s47t.aspx">MSDN</a> also talks a little bit about this:

<blockquote> Executing such calls with reflection, using the InvokeMember method, does not provide good performance. Performance can be improved by using members of the System.Reflection.Emit namespace.</blockquote>

<strong>So let's look at how we implement this static method dynamically!</strong>

We will use this constructor-overload to create the dynamic method:

	public DynamicMethod(
		string name,
		Type returnType,
		Type[] parameterTypes,
		Module m
	)

The first variable name is only relevant when you are debugging your application, the second is the method return type, the third is a list of parameter types, the last one is in which module/context it should reside.

We can start off by creating a list of argument types, the easiest way I've found to do this is by doing it like this:

	Type[] methodArguments = { 
	                                typeof(int), 
	                                typeof(int)
	                            };

There top one is representing our parameter a and the second represents b in our delegate. Now we are ready to actually create the dynamic method instance and it will look somewhat like this:

	DynamicMethod division = new DynamicMethod(
	        "Division",
	        typeof(double),
	        methodArguments,
	        typeof(Program).Module);

I am just using the Module of my current executing class which is the Program class. Now we are at the stage where we are ready to actually say what this method will do, as you've seen so far we haven't said anything about what will happen when execute the dynamic method. So how do we actually do this?

<strong>We need to emit IL!</strong>

First of all we need to retrieve the IL-generator so that we actually can emit IL, emitting IL means that we are adding instructions that will run at the lowest level. We get the IL-generator like this:

	ILGenerator il = division.GetILGenerator();

We can use the il-instance now to emit our IL code by calling <a href="http://msdn.microsoft.com/en-us/library/csx7wsz2(v=vs.95).aspx">`Emit()`</a>. We will use the following overload of <a href="http://msdn.microsoft.com/en-us/library/csx7wsz2(v=vs.95).aspx">`Emit()`</a>:

	public virtual void Emit(
		OpCode opcode
	)

Now you might wonder what an OpCode is, first let's look at the <a href="http://en.wikipedia.org/wiki/Opcode">wikipedia definition</a>:

<blockquote>In computer science, an opcode (operation code) is the portion of a machine language instruction that specifies the operation to be performed.</blockquote>

<strong>Great!</strong> So this is just like ASM for those that are familiar with that! For those that are not what you need to know is that an opcode is just an instruction, you tell the machine to do one thing at a time, for instance. If you want to multiply two values, there is an opcode called <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.mul.aspx">"Mul"</a> that you can use. Also worth mentioning is that you generally do computation on values that are on the stack, for instance, if you want to multiply 2 and 4, you push(add) both of these to the stack and then emit the opcode <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.mul.aspx">"Mul"</a>, 2 and 4 are popped (take out from) the stack, then the result of this operation will be pushed to the stack.

If you look around on different opcodes and their explanation you will find a pattern on how this works!

You can find a <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes(v=VS.100).aspx">list of all opcodes that you can use in MSIL on MSDN</a>, but in order to solve our division "problem" we will need to use the following opcodes:

<ul>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarg_0.aspx">Ldarg_0</a> - Load argument 0 onto the stack</li>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarg_1.aspx">Ldarg_1</a> - Load argument 1 onto the stack</li>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.div.aspx">Div </a>- Divide the two values on the stack</li>
	<li><a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ret.aspx">Ret </a>- Return</li>
</ul>

You might ask youself why there's hardcoded <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarg_0.aspx">Ldarg_0</a>, <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarg_1.aspx">Ldarg_1</a>, <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarg_2.aspx">Ldarg_2</a>, <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarg_3.aspx">Ldarg_3</a>, but then it stops! This is because these instructions produce smaller byte code, these are one byte instructions. Then we have <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarg.aspx">Ldarg</a>, <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarga.aspx">Ldarga</a> and <a href="http://msdn.microsoft.com/en-us/library/system.reflection.emit.opcodes.ldarg_s.aspx">Ldarg_S</a> that we can use to load any index onto the stack, these take up two bytes however.

There's something called "calling convention", this defines how values are pushed/popped to the stack when you enter a method and how values on the stack are handled when you return from a method. This might not be important now, but it's worth looking into if you want to dig deeper into this!

Now all we need to do is emit the opcodes listed above to the IL-generator and then go on to the next step!

	il.Emit(OpCodes.Ldarg_0);
	il.Emit(OpCodes.Ldarg_1);
	il.Emit(OpCodes.Div);
	il.Emit(OpCodes.Ret);

Basically what happens here is that it will take my two arguments (a,b) and push(add) them to the stack, then the division-instruction will pop(take them out) from the stack and push(add) the result back on the stack and then we return from this method. We can't really invoke anything yet, but we will get to that part now!

One thing that we can use the DynamicMethod-instance for is to create a delegate in order for us to be able to actually invoke it, this method is called:

	CreateDelegate()

It takes one parameter and that is the type of the delegate that we are creating, but the method just returns the type `Delegate` so we need to type-cast it, it ended up looking like this:

	var divideIt = (DivideInvoker)division.CreateDelegate(typeof(DivideInvoker));

And there we have it! A method that we can actually invoke!

Just for the fun of it, let's see what happens if we divide by 0 like this:

	var result = divideIt(4, 0);

Result will contain of a double with the value "Infinity", so it doesn't throw any exceptions for us at this point, we got to handle that type of validation. So what happened here? What we did was that we created a `DynamicMethod` then we emitted some IL to this dynamic method and last but not least, we said that this method works with a known delegate that we have so we create a delegate and invoke it!

Here's a screenshot of me running it on my machine:

<a href="http://dl.dropbox.com/u/4396175/DivideByZero.png" target="_blank"><img src="http://dl.dropbox.com/u/4396175/DivideByZero.png" alt="" style="width: 700px;" /></a>

I hope you found this interesting and if you have any thoughts please leave a comment below!
