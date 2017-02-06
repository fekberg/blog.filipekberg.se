---
layout: post
title: What does async & await generate?
date: 2013-01-16 15:03
author: fekberg
comments: true
metadescription: Have you ever wondered what happens behind the scenes when using Async & Await in .NET 4.5? Here's the answer!
categories: .NET, C#
tags: async, await, csharp
---
Do you ever get the feeling that you want to know exactly what happens behind the scenes? I do, quite a lot actually. Which is one of the many reasons that I've written about IL, Reflection and ways to prove how certain code behaves and works using tools such as Reflector. If you've read my book C# Smorgasbord, you might have come across the chapter about async & await which are two very handy additions to .NET 4.5. I've done some screencasts and articles about that in the past, but let's take a look at something that we haven't looked at before; what happens behind the scenes.<!--excerpt-->

As you might know, when you use async and await in .NET 4.5 an internal state machine is created to keep track of the current state. Jon Skeet had a brilliant talk on NDC 2010 where he talked about how `goto` is truly awesome, in the essence of async & await that is. Without it async & await would be hard to implement accordingly.

This won't be one of my lengthy posts, this time I'll leave some of the investigation to you and we might re-visit the topic in the future. Leave a comment about what you think of it all below!

I created a very simple .NET 4.5 console application in Visual Studio 2012 which I named AsyncDemoProject. In this application which you can see below I just created a very simple async operation which I want to inspect further.

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/01/Async1.png" alt="Creating an Async &amp; Await project" width="810" class="alignright size-full wp-image-1624" />

The most simple application that I could think of creating was one that simply creates a task that sleeps for a while then returns a string. What my application then does is simply awaiting this and setting a property to a value that indicates that the operation is done.

This ended up looking like the following:

    class AsyncDemo
    {
        public bool IsLoading { get; set; }
        public async Task GetStringAsync()
        {
            IsLoading = true;

            var result = await GetStringTask();

            IsLoading = false;
            Console.WriteLine(result);
        }

        public Task<string> GetStringTask()
        {
            return Task<string>.Factory.StartNew(() =>
            {
                Thread.Sleep(2000);

                return "Hello World";
            });
        }
    }

This can be used as simple as this:

    static void Main(string[] args)
    {
        var demo = new AsyncDemo();
        demo.GetStringAsync();

        while (demo.IsLoading)
        {
            Console.WriteLine("Async is Amazing no?!!!");
        }
        
        Console.ReadLine();
    }

What happens when we run this is that a console will be opened and after about two seconds we will see a message telling us "Hello World" of course the console will be filled up with the text "Async is Amazing no?!!!" until that message is shown and that loop is exited due to the condition being met.

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/01/Async2.png" alt="Console Application running" width="677" height="343" class="alignright size-full wp-image-1625" />

If you have a tool installed such as Reflector or IL Spy, open up the compiled executable in that and let's inspect what happened when we compiled this solution. This did generate some interesting things, normally when you compile an application and open it up in reflector, you will be able to see something pretty much alike what you programmed in the first place. But when adding async and await we have some generated code that needs to be there in order for the state machine to work properly.

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/01/AsyncDemoInReflector.png" alt="The project opened in reflector" width="810" class="alignright size-full wp-image-1627" />

Notice that we have a struct generated for us, it even has the attribute `CompilerGenerated`! This struct keeps track of the state and has methods to help us with that. In reflector we can expand the methods to see the implementations, if we do so, this is what we will see:

    internal class AsyncDemo
    {
        // Methods
        public async Task GetStringAsync()
        {
            bool <>t__doFinallyBodies = true;
            this.IsLoading = true;
            TaskAwaiter<string> CS$0$0001 = this.GetStringTask().GetAwaiter();
            if (!CS$0$0001.IsCompleted)
            {
                this.<>u__$awaiter2 = CS$0$0001;
                AsyncTaskMethodBuilder.Create().AwaitUnsafeOnCompleted<TaskAwaiter<string>, <GetStringAsync>d__0>(ref CS$0$0001, ref (<GetStringAsync>d__0) ref this);
                <>t__doFinallyBodies = false;
                return;
                CS$0$0001 = this.<>u__$awaiter2;
            }
            string introduced6 = CS$0$0001.GetResult();
            CS$0$0001 = new TaskAwaiter<string>();
            string CS$0$0003 = introduced6;
            string result = CS$0$0003;
            this.IsLoading = false;
            Console.WriteLine(result);
        }

        public Task<string> GetStringTask()
        {
            return Task<string>.Factory.StartNew(delegate {
                Thread.Sleep(0x7d0);
                return "Hello World";
            });
        }

        // Properties
        public bool IsLoading { get; set; }

        // Nested Types
        [CompilerGenerated]
        private struct <GetStringAsync>d__0 : IAsyncStateMachine
        {
            // Fields
            public int <>1__state;
            public AsyncDemo <>4__this;
            public AsyncTaskMethodBuilder <>t__builder;
            private object <>t__stack;
            private TaskAwaiter<string> <>u__$awaiter2;
            public string <result>5__1;

            // Methods
            private void MoveNext()
            {
                try
                {
                    TaskAwaiter<string> CS$0$0001;
                    bool <>t__doFinallyBodies = true;
                    switch (this.<>1__state)
                    {
                        case -3:
                            goto Label_00D0;

                        case 0:
                            break;

                        default:
                            this.<>4__this.IsLoading = true;
                            CS$0$0001 = this.<>4__this.GetStringTask().GetAwaiter();
                            if (CS$0$0001.IsCompleted)
                            {
                                goto Label_0084;
                            }
                            this.<>1__state = 0;
                            this.<>u__$awaiter2 = CS$0$0001;
                            this.<>t__builder.AwaitUnsafeOnCompleted<TaskAwaiter<string>, AsyncDemo.<GetStringAsync>d__0>(ref CS$0$0001, ref this);
                            <>t__doFinallyBodies = false;
                            return;
                    }
                    CS$0$0001 = this.<>u__$awaiter2;
                    this.<>u__$awaiter2 = new TaskAwaiter<string>();
                    this.<>1__state = -1;
                Label_0084:
                    string introduced6 = CS$0$0001.GetResult();
                    CS$0$0001 = new TaskAwaiter<string>();
                    string CS$0$0003 = introduced6;
                    this.<result>5__1 = CS$0$0003;
                    this.<>4__this.IsLoading = false;
                    Console.WriteLine(this.<result>5__1);
                }
                catch (Exception <>t__ex)
                {
                    this.<>1__state = -2;
                    this.<>t__builder.SetException(<>t__ex);
                    return;
                }
            Label_00D0:
                this.<>1__state = -2;
                this.<>t__builder.SetResult();
            }

            [DebuggerHidden]
            private void SetStateMachine(IAsyncStateMachine param0)
            {
                this.<>t__builder.SetStateMachine(param0);
            }
        }
    }

Notice the use of `label` and `goto`? You might recall the use of label when we jumped around with IL in some of the previous posts on this blog. As you can see the code isn't really "exactly" as you might imagine from the use of some simple keywords. There's a lot of magic that happens and above in the code example you can see how the state machine is implemented and how it is used.

Quite interesting right? Let me know what "chocked" you the most about the code generated from asyc and await.