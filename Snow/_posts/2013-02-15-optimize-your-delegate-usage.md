---
layout: post
title: Optimize your delegate usage
date: 2013-02-15 14:35
author: fekberg
comments: true
metadescription: Optimize your delegate usage, avoid this pitfall!
categories: .NET, C#, Programming
tags: csharp, Programming
---
<em>Kudos to <a href="https://twitter.com/davidfowl" target="_blank">David Fowler</a> for spotting this!</em> We had a chat on <a href="https://jabbr.net/#/rooms/general-chat" target="_blank">JabbR</a> and David pointed out something quite odd about delegates which he had discovered while optimizing some code.<!--excerpt-->

Let's assume that we have the following code that declares a delegate and a method that uses it:

    public delegate void TestDelegate();

    public void Bar(TestDelegate test)
    {
        test();
    }

Now consider that you want to run this method and pass a method for it to execute that corresponds with the delegate. The process of running this will be in a loop that runs for 10 000 iterations.

The method we want to run is called `Foo` and looks like the following:

    public void Foo() { }

Everything is set up, so what is it that we need to optimize when calling this 10 000 times? Well we have two different ways of using the method with a delegate.

<strong>Option 1</strong>
The first option is that we can use an anonymous method to call this method looking like the following:

    for (var i = 0; i < 10000; i++)
    {
        Bar(() => Foo());
    }

If we compile this and open it up in Reflector to see what is generated, there's also some other stuff generated behind the scenes but this is the important part:


    TestDelegate test = null;
    for (int i = 0; i < 0x2710; i++)
    {
        if (test == null)
        {
            test = () => this.Foo();
        }
        this.Bar(test);
    }

Looks good so far, right? Let's take a look at Option 2 and compare.

<strong>Option 2</strong>
The second option that we have is just writing the method name to tell it to use this like you can see here:


    for (var i = 0; i < 10000; i++)
    {
        Bar(Foo);
    }

This one is quite common and I've seen it used a lot, but what happens behind the scenes here?

If we open this up in Reflector we can see that the following code was generated:

    for (int i = 0; i < 0x2710; i++)
    {
        this.Bar(new TestDelegate(this.Foo));
    }

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/02/UmpOi.gif" alt="UmpOi" width="200" height="200" class="alignright size-full wp-image-1757" />

This is significantly different from the lambda one! Is your mind blown yet?

Ok let me break it down, it's quite simple. What happens with option 2 is that it will create 10 000 instances of `TestDelegate` and thus using a lot more memory. The lambda version was optimized but the "normal" one wasn't?

Let's just verify that it actually does use a lot more memory! I've set the solution to compile in Release mode with Optimization turned on and I'm using the following code to test it:

    public class Program
    {
        public delegate void TestDelegate();

        public void Bar(TestDelegate test)
        {
            test();
        }
        public void Foo()
        { }

        public static void Main()
        {
            var program = new Program();
            GC.WaitForFullGCComplete(100000);
            Console.WriteLine("Memory usage before Lambda version:\t{0}", GC.GetTotalMemory(false));

            program.LambdaVersion();
            Console.WriteLine("Memory usage After Lambda version:\t{0}", GC.GetTotalMemory(false));

            GC.WaitForFullGCComplete(100000);
            Console.WriteLine("Memory usage before Normal version:\t{0}", GC.GetTotalMemory(false));

            program.NormalVersion();
            Console.WriteLine("Memory usage After Normal version:\t{0}", GC.GetTotalMemory(false));

        }
        public void LambdaVersion()
        {
            for (var i = 0; i < 10000; i++)
            {
                Bar(() => Foo());
            }
        }

        public void NormalVersion()
        {
            for (var i = 0; i < 10000; i++)
            {
                Bar(Foo);
            }
        }
    }

Here's the result from that operation:

    Memory usage before Lambda version:     29460
    Memory usage After Lambda version:      37652
    Memory usage before Normal version:     37652
    Memory usage After Normal version:      357140

<h3>Conclusion</h3>
If we use delegates "wrong" or don't think what code is actually generated this can leave us with large memory imprints. Of course you always need to think about the code you write but in some cases you might not really know what the compiler ends up doing.

By using the lambda version instead in this case we've avoided to create a lot of new delegate instances and thus minimized the memory imprint. 

Fun fact: If we compile the "normal version" using MonoDevelop and Mono (2.10.9) it results in the same output. Which leads me to think that this is by design. The only difference is when we compile the lambda version but nothing significant that changes the behavior at all.

<em>Do you say this is a bug or a feature? Did you know it behaved like this?</em>
