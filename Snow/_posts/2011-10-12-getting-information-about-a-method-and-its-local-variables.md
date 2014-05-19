---
layout: post
title: Getting information about a method and its local variables
date: 2011-10-12 23:38
author: fekberg
comments: true
metadescription: Getting information about a method and its local variables
categories: .NET, C#, Programming
tags: csharp, dotnet, dynamic, dynamic programming, reflection
---
Sometimes it can be useful to get information about a method such as getting all the local variables. We've looked at how we can retrieve information about known types and setting / getting their values. Now let's take a look at how we can get information about a method and it's local variables in runtime!<!--excerpt-->

I am going to use almost the same code as in the last example, except that I've changed it a little bit. I refactored everything out to a separate class to make it easier to follow me along the way, the class that creates my dynamic method now looks like this:

    public delegate double DivideInvoker(int a, int b);
    public class MyMethodCreator
    {
       
        public DivideInvoker CreateInvoker()
        {
            Type[] methodArguments = { 
                        typeof(int), 
                        typeof(int)
                    };

            DynamicMethod division = new DynamicMethod(
                    "Division",
                    typeof(double),
                    methodArguments,
                    typeof(MyMethodCreator));

            ILGenerator il = division.GetILGenerator();
            il.Emit(OpCodes.Ldarg_0);
            il.Emit(OpCodes.Ldarg_1);
            il.Emit(OpCodes.Div);
            il.Emit(OpCodes.Ret);

            var divideIt = (DivideInvoker)division.CreateDelegate(typeof(DivideInvoker));

            return divideIt;
        }
    }

If you want to know more about what it does, be sure to <a href="http://cdn.filipekberg.se/2011/10/11/creating-static-methods-at-runtime/">check out my previous blog post</a>! It's a bit easier to create my dynamic method now and invoke it:

    var methodCreator = new MyMethodCreator();
    DivideInvoker divideIt = methodCreator.CreateInvoker();

    double result = divideIt(4, 0);

Now we've come to the interesting part, I want to get information about the local variables inside my method that actually runs the above code. What I expect to get is information about my `MyMethodCreator` instance, my dynamic method and my result variable. All the information regarding this is stored inside something called a <a href="http://msdn.microsoft.com/en-us/library/system.diagnostics.stackframe.aspx">StackFrame</a>, more commonly known as a call stack.

Let's briefly take a look at what Wikipedia has to say about what a call stack is:

<blockquote>In computer science, a call stack is a stack data structure that stores information about the active subroutines of a computer program. This kind of stack is also known as an execution stack, control stack, run-time stack, or machine stack, and is often shortened to just "the stack". Although maintenance of the call stack is important for the proper functioning of most software, the details are normally hidden and automatic in high-level programming languages.</blockquote>

This means that we can get information from the stack frame! Worth knowing is that there's one StackFrame for each method, just as the above code says, each subroutine(method) has it's own call stack! So we don't just want to get the current call stack/stack frame, we want to get all of them!

In order to do this, we need to create an instance of a <a href="http://msdn.microsoft.com/en-us/library/yhs34xdh(v=VS.100).aspx">`StackTrace`</a> object and then call it's member function <a href="http://msdn.microsoft.com/en-us/library/system.diagnostics.stacktrace.getframes.aspx">`GetFrames()`</a>, this will give us all the frames that the stack trace can find.

So what I've done here is that I've created a method that I want to use to dump the all the stack frames and all information about the local variables.

    void DumpStackFrames()
    {
    }

And the first thing that I am going to do is to create a new stack trace and fetch all the frames so I can iterate over them:

    StackTrace trace = new StackTrace();
    foreach (StackFrame frame in trace.GetFrames())
    {
    }

You can get some more information out of the frame-instance but I am just interested in getting the actual method, so in order to do that I call `GetMethod()` which will give me a <a href="http://msdn.microsoft.com/en-us/library/system.reflection.methodbase.aspx">`MethodBase`</a>, which is a parent to <a href="http://msdn.microsoft.com/en-us/library/system.reflection.methodinfo.aspx">`MethodInfo`</a>:

    MethodBase method = frame.GetMethod();

Now we've got information about the method itself, what we want now is the actual body of the method where all the goodies are, this is fairly straight forward, there's a <a href="http://msdn.microsoft.com/en-us/library/system.reflection.methodbase.getmethodbody.aspx">`GetMethodBody()`</a> function we can use on the method-instance! Let's print out the method name as well to the console so that we will see exactly what we're dealing with. This is what we've come up with so far:

    void DumpStackFrames()
    {
        StackTrace trace = new StackTrace();
        foreach (StackFrame frame in trace.GetFrames())
        {
            MethodBase method = frame.GetMethod();
            MethodBody body = method.GetMethodBody();
            Console.WriteLine("Method: {0}", method.Name);
        }
    }

Now when we've got the body for each stack frames method, we can ask for all the local variables, these are retrieved through the collection `LocalVariables` and since we want to iterate over them we can do it like this:

    foreach (LocalVariableInfo variableInfo in body.LocalVariables)
    {
    }

<a href="http://msdn.microsoft.com/en-us/library/system.reflection.localvariableinfo.aspx">`LocalVariableInfo`</a> will give us all information that we need about the variable, we can among a lot of other things:
<ul>
	<li>Get the variable name</li>
	<li>Get all properties (<a href="http://msdn.microsoft.com/en-us/library/system.reflection.propertyinfo.aspx">`PropertyInfo`</a>)</li>
</ul>

Both of the above is interesting to us, we want to print out the variable type and then go through all the properties on the variable and print the names of those as well.

We start off by printing the variable name like this: 

    Console.WriteLine("\tVariable: {0}", variableInfo.ToString());

In order for us to get all the properties, we need to access that through the `LocalType` variable which will give us a `Type` instance:

    foreach (PropertyInfo property in variableInfo.LocalType.GetProperties())
    {
        Console.WriteLine("\t\tProperty: {0}", property.Name);
    }

As you can see we just use the property information as we've seen in earlier blog posts. So what will the result look like? The entire method looks like this:

    void DumpStackFrames()
    {
        StackTrace trace = new StackTrace();
        foreach (StackFrame frame in trace.GetFrames())
        {
            MethodBase method = frame.GetMethod();
            MethodBody body = method.GetMethodBody();
            Console.WriteLine("Method: {0}", method.Name);
            foreach (LocalVariableInfo variableInfo in body.LocalVariables)
            {
                Console.WriteLine("\tVariable: {0}", variableInfo.ToString());
                foreach (PropertyInfo property in variableInfo.LocalType.GetProperties())
                {
                    Console.WriteLine("\t\tProperty: {0}", property.Name);
                }
            }
            Console.WriteLine();
        }
    }

And when I run it I will get the following information ( more text after the picture! ):

<img src="http://dl.dropbox.com/u/4396175/DumpStackFrames.png" alt="" />

As you can see the dynamic method has a pretty odd type as opposed to what it would look like if we used a lambda expression like this instead:

    DivideInvoker divideIt = (a,b) => a / b;

This would output the following:

    Variable: Reflection.DivideInvoker (1)
            Property: Method
            Property: Target

Compared to:

    Variable: Reflection.MyMethodCreator+DivideInvoker (1)
            Property: Method
            Property: Target

As you can see it's a bit different when you use a dynamic method, as you might expect as well! By getting the local variable information and fetching the type, you can explore the dynamic method even more.

I hope you found this interesting and if you have any thoughts please leave a comment below!
