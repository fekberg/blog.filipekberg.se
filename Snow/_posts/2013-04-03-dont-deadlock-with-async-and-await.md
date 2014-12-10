---
layout: post
title: Don't deadlock with async and await
date: 2013-04-03 15:32
author: fekberg
comments: true
metadescription: Avoid deadlocking your applications when using async and await.
categories: .NET, C#
tags: async, await, csharp, deadlock, Programming
---
Deadlocking is really something you need to avoid and in case you don't know what a deadlock is here's a great illustration of a "real life deadlock":

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/04/deadlock.png" alt="deadlock" width="263" height="262" class="alignright size-full wp-image-1896" />

Basically what has happened here is that all the roads are full with cars and all the cars try to cross the road at the same time. Let's translate this into computer terms; the cars in this case are the threads and the cross-over is the "thing" that handles these threads. In the illustration above all the cars have driven into the cross-over at the same time and they can't really back up, hence there's a deadlock and there's no way to go.<!--excerpt-->

What happens in a computer program when you get a deadlock is that it freezes and there's no where to go because all paths are occupied or waiting for something to finish. Let's say that process X waits for process Y and process Y waits for process X and both of these lock up the GUI thread, this means that the application will die. Hence deadlocking is something you want to avoid.

Normally you solve this by introducing locking and semaphores. As discussed in the article linked above (where I got the very nice illustration) a semaphore can be seen as a traffic light which handles how the cross-over is loaded with cars.

A while back I wrote an article called <a href="http://filipekberg.se/2012/09/20/avoid-shooting-yourself-in-the-foot-with-tasks-and-async/" target="_blank">"Avoid shooting yourself in the foot with Tasks and Async"</a>, I suggest that you should always return a `Task` from your asynchronous methods and you really should. What I am about to tell you below though is what you should avoid when doing this.

When a method is marked as asynchronous and the await-part is reached, the method will "exit" and return the "awaiting `Task`", which means it's not the `Task` that runs inside the method but in fact a `Task` that keeps track of the status of the asynchronous operation. 

Let's look at a basic code sample!

Consider that you have the following basic asynchronous method, all it does is that it waits for 2 seconds and then prints something to the debug window:

	private async Task RunAsync()
	{
	    var run = Task.Factory.StartNew(() => {
	        Thread.Sleep(2000);
	    });

	    await run;

	    Debug.WriteLine("Execution done!");
	}

Once `await` is reached, what will happen? A `Task` will be returned, but which one? Not the one named `run`! A `Task` that keeps track on the state machine will be returned.

Now what happens if we call this method on the GUI thread and asks to wait for it to finish? Calling `Wait` freezes the current thread and since we are on the GUI thread this will freeze the GUI thread, but for how long? When is `Wait` happy enough to proceed? In fact it will wait for the asynchronous task that handles the state machine to give it a signal that it's now ready.

However that `Task` can never be marked as done until the entire method has been completed. Which means that it needs to access the GUI thread again, since we're back on the calling thread (GUI thread in this case) after `await`!

This means that all we have to do in order to deadlock is this:

	RunAsync().Wait();

I hope that makes sense to you and gives you an insight into what really happens when you use async and await. As with everything: use it wisely and know what it is that you're doing.

I'd love to hear about your deadlocking stories!
