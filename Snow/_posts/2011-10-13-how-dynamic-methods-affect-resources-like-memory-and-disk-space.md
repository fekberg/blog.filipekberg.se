---
layout: post
title: How Dynamic Methods affect resources like memory and disk space
date: 2011-10-13 23:39
author: fekberg
comments: true
metadescription: How Dynamic Methods affect resources like memory and disk space
categories: .NET, C#, Programming
tags: csharp, dotnet, reflection
---
We've seen how we can create static methods at runtime and one of the benefits that I've been talking about is that the methods will be disposed when they don't have a reference anymore. This can be crucial if you work in an environment where memory resources are limited. So what I will do is I will allocate a couple of million methods and see what happens with my memory usage!<!--excerpt-->

To do this I've changed a couple of things in `MyMethodCreator` so that I can get a list of math operations that I want to run, this is the entire class that I will be using:

    public class MyMethodCreator
    {
        public ICollection<MathInvoker> MathOperations { get; private set; }

        public MathInvoker CreateInvoker(OpCode operation)
        {
            Type[] methodArguments = { 
                typeof(int), 
                typeof(int)
            };

            DynamicMethod mathOperation = new DynamicMethod(
                    "MathOperation",
                    typeof(double),
                    methodArguments,
                    typeof(MyMethodCreator).Module);

            ILGenerator il = mathOperation.GetILGenerator();
            il.Emit(OpCodes.Ldarg_0);
            il.Emit(OpCodes.Ldarg_1);
            il.Emit(operation);
            il.Emit(OpCodes.Ret);

            var divideIt = (MathInvoker)mathOperation.CreateDelegate(typeof(MathInvoker));

            return divideIt;
        }
        public IEnumerable<MathInvoker> GenerateOperations(int count)
        {

            MathOperations = new List<MathInvoker>();
            MathOperations.Add(CreateInvoker(OpCodes.Div));

            for (var i = 0; i < count; i++)
                MathOperations.Add(CreateInvoker(OpCodes.Mul));

            return MathOperations;
        }

    }

As you can see, all that I am doing is replacing the operation code for what type of math operation that I will be running, then I create this dynamic method and add it to a list inside my class. The idea here is that I want to see if I get almost all memory back when disposing the list of methods, this is interesting because we will most certainly notice a difference in initial / end size in memory if we compare it to a statically written application where all the millions of methods would be defined.

We could of course refactor the above a little bit in order to reduce the overhead when creating the dynamic methods, but let's not bother with that at the moment. I've been doing some tests here to try these two scenarios:

1. I have an application that dynamically creates ~35 000 methods attached as an instance method. The only thing know at runtime is the method that creates this dynamically.

2. I have an application that has ~35 000 methods defined in a class, like any normal method would be. Everything is known at runtime.

Then the common part is that in both cases, I've added ~35 000 delegates to a list and then disposed that list, to see what happens with the data. Initially I expected that when I dynamically create ~35 000 methods I would get almost all the memory back once I dispose it and that this would be false for the second scenario above.

This is how I did the testing to see how much memory was used:

    Console.WriteLine(GC.GetTotalMemory(true).ToString());

This will print the total amount of allocated bytes, the parameter just states that it's OK for us to wait for the GC to do a correct calculation. My test for the first scenario was produced like this:

1. Create an instance of `MyMethodCreator`
2. Print the allocated bytes
3. Create the dynamic methods
4. Print the allocated bytes
5. Clear the list of delegates and Dispose `MyMethodCreator`
6. Call `GC.Collect()` and `GC.WaitForPendingFinalizers()`
7. Print the allocated bytes
8. Re-do step 1 to 7 once more

<em>Before we go any further, I just need to say that you should't ask the garbage collector to collect manually, it will solve this best by itself!</em>

So the test for the second scenario was similar except that instead of doing step 3 above, I just added each method from my `MyMethodCreator`, since in the "static method" scenario ( scenario #2 above ) had all the method as instance variables pre-defined, they were not dynamically added to the class. So I just added these as delegate types to a list, just as the "create dynamic method"-step did above.

The code for the above could look somewhat like this, for scenario #1:

    for (int i = 0; i < 2; i++)
    {
        var methodCreator = new MyMethodCreator(OpCodes.Mul);
        Console.WriteLine(GC.GetTotalMemory(true).ToString());

        methodCreator.GenerateOperations(32768);

        Console.WriteLine(GC.GetTotalMemory(true).ToString());
        
        methodCreator.Operations.Clear();
        methodCreator = null;

        GC.Collect();
        GC.WaitForPendingFinalizers();

        Console.WriteLine(GC.GetTotalMemory(true).ToString());
    }

The result from running this for me looked like this:

<img src="http://cdn.filipekberg.se/fekberg-blog/how-dynamic-methods-affect-resources-like-memory-and-disk-space/myMethodCreator_inspection.png" alt="" />

So I got the following values:

    101120
    1414064
    365484
    103140
    1414064
    365484

And when running scenario #2, I got the following values:

    21344
    1208416
    159868
    28728
    1208416
    159868

As you can see the two are pretty similar, the difference is that they have different overhead, this is most likely because the first scenario uses Dynamic Method that takes a little more resources. As I said in the beginning of this post, we could refactor `MyMethodCreator` a little bit, but would still be above scenario #2.

The important thing here isn't really that they differ a little bit, but to see that there is a pattern, the methods are disposed as we imagine they would be.

<strong>But what about the resources I want to spare?</strong> By the looks of it, you won't save any memory resources by using the dynamic method approach, at least not in the way I did it. If this scales to a lot of different and larger operations where the IL-commited is a lot more, the result might be a bit different.

However, there is one thing that differs a lot and that's the manageability and size of the actual binary. First of all, the second scenario has ~35 000 methods in it, it's impossible to maintain, who would ever write 35 000 methods? Probably no-one, but that's beside the point. Having one method that helps us create these instead is Much easier on the eyes and more maintainable.

The second thing is the binary size, now, these binaries are already pretty small, but the difference between them is pretty huge in my opinion:

<ul>
	<li>Dynamically created methods binary: <strong>7KB</strong></li>
	<li>Staically created methods binary: <strong>3MB</strong></li>
</ul>

Seeing that both these are very small numbers might not raise an eyebrow but how about when I say that the binary size increased with <strong>43886%</strong>? Might still not be a problem, but consider that you are programming a micro-controller where you have limited amount of flash-memory to install the software on, the system supports .NET and emitting code with reflection, you have more RAM than you have flash-memory. Then a variant like this could be useful to know about. I personally hoped to see that it would take up a lot less memory than having compiled before runtime.

I hope you found this interesting and if you have any thoughts please leave a comment below!
