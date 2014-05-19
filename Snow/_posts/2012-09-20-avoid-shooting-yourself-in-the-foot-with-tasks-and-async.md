---
layout: post
title: Avoid shooting yourself in the foot with Tasks and Async
date: 2012-09-20 10:03
author: fekberg
comments: true
metadescription: It can be easy to shoot yourself in the foot with async, i this post we look at how you can avoid that.
categories: .NET, C#, Programming
tags: async, await, csharp, pitfalls
---
<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/pitfalls2.jpg" alt="" title="Avoid the pitfalls" width="200" style="display: block;   margin-left: auto;   margin-right: auto;" class="aligncenter size-full wp-image-1142" />

Since the release of .NET 4.5, you've been able to use the RTM version of <strong>Async & Await</strong>. There are some things though that can lead to very weird behaviors in your applications, and a lot of confusion. Kevin (<a href="https://twitter.com/Pilchie">Pilchie</a>) over at Microsoft just gave me heads up on some of these and I thought that I would share it with the rest of you!<!--excerpt-->

<em>There was a very interesting discussion around this subject in the <strong>##roslyn</strong> channel on <a href="http://webchat.freenode.net/">freenode</a> with <a href="http://twitter.com/ermau">@ermau</a> and <a href="https://twitter.com/jrusbatch">@jrusbatch</a>.</em>

<h3>Avoid `async void`</h3>
When you're doing asynchronous methods that just return void, there is no way to track when these methods are done.

Look at the following example:

    class FooBar
    {
        public async void Biz()
        {
            await Foo();
        }
        public Task Foo()
        {
            return Task.Factory.StartNew(() =>
            {
                Task.Delay(2000);
                Console.WriteLine("Done!");
            });
        }
    }

If we create an instance of `FooBar` and call `Biz()`, there's no way for us to wait for the task to finish. Normally we would want a reference to a `Task` that we could wait for to finish, but in this case we don't! Avoid `async void` whenever you can.

Just change the method signature to `async Task` instead and you will be able to do:

    var foo = new FooBar();
    foo.Biz().Wait();

<strong>The only reason</strong> you want to use `async void` is when you have an event handler that needs to `await` something. Such as a `Click` event handler like this:

    private async void MyButton_Clicked(object sender, RoutedEventArgs e)
    {
        var task = Task<string>.Factory.StartNew(() =>
        {
            Thread.Sleep(2000);

            return string.Empty;
        });

        var data = await task;

        MessageBox.Show(data);
    }

<h3>Never getting that second exception when awaiting multiple results?</h3>
Consider that we have two asynchronous methods that both thrown an exception (almost at the same time), like these two methods here:

    public static Task<int> Foo()
    {
        return Task<int>.Factory.StartNew(() => {
            throw new Exception("From Foo!");
        });
    }
    public static Task<int> Bar()
    {
        return Task<int>.Factory.StartNew(() =>
        {
            throw new Exception("From Bar!");
        });
    }

What would happen if we called the following method?

    public static async Task<int> Caclulate()
    {
        return await Foo() + await Bar();
    }

We would indeed get an exception thrown. But we would only get <strong>One</strong> exception thrown! In fact, the only exception that we will get is the First exception being thrown.

This means that we would not see an aggregated exception list as we might expect.

<h3>Exceptions in `Tasks` don't travel back to the caller</h3>
When working with multiple threads and the thread causes a problem that is unhandled, these are thrown back at the caller.

Look at this following example for instance:

    new System.Threading.Thread(() => { throw new Exception(); }).Start();

When running this, we will see the following exception:

<blockquote>Unhandled Exception: System.Exception: Exception of type 'System.Exception' was thrown.</blockquote>

This is perfectly reasonable, it tears down the calling process!

But what about if this was a `Task` instead?

The following code spawns a new task and just throws a similar exception to what the thread example did above:

    Task.Factory.StartNew(() => { throw new Exception(); });

What happens when we run this? <strong>Nothing!</strong>

No exception were traveled back to the caller, this can cause potential confusions. This is actually by design and <a href="http://msdn.microsoft.com/en-us/library/jj160346">MSDN </a>says the following about it:

<blockquote>In the .NET Framework 4, by default, if a `Task` that has an unobserved exception is garbage collected, the finalizer throws an exception and terminates the process. The termination of the process is determined by the timing of garbage collection and finalization.

To make it easier for developers to write asynchronous code based on tasks, the .NET Framework 4.5 changes this default behavior for unobserved exceptions. Unobserved exceptions still cause the `UnobservedTaskException` event to be raised, but by default, the process does not terminate. Instead, the exception is ignored after the event is raised, regardless of whether an event handler observes the exception.</blockquote>

If we want the the .NET 4 behavior, we can re-enable the unobserved task exceptions by changing the applications app.config. Add the following to the app.config:

    <configuration> 
        <runtime>
          <ThrowUnobservedTaskExceptions enabled="true"/> 
        </runtime> 
    </configuration>

Since the exception will be thrown in the finalizer, we can test this by running the following:

    Task.Factory.StartNew(() => { throw new Exception(); });

    Thread.Sleep(100);
    GC.Collect();
    GC.WaitForPendingFinalizers();

This will tear down the process as it did in .NET 4.0.

<blockquote>Unhandled Exception: System.AggregateException: A Task's exception(s) were not observed either by Waiting on the Task or accessing its Exception property. As a result, the unobserved exception was rethrown by the finalizer thread. ---> System.Exception: Exception of type 'System.Exception' was thrown.</blockquote>

<strong>Have you ever shot yourself in the foot with Tasks or Async? Leave your horror stories in the comment field!</strong>
