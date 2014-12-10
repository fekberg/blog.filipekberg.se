---
layout: post
title: Debugging Asynchronous Code in Visual Studio 2013
date: 2013-11-15 03:16
author: fekberg
comments: true
metadescription: Debugging Asynchronous Code in Visual Studio 2013
categories: .NET, C#, Programming
tags: async, Async & Await, await, csharp, Debugging, visual studio, VS2013
---
With <a href="http://www.visualstudio.com/en-us" target="_blank">Visual Studio 2013 </a>being publicly released I think it's time I show off one nice improvements in Visual Studio 2013.tudio 2013. There are in fact a lot of nice improvements in Visual Studio 2013 and one of my favourite ones, actually two of my favourite ones are the debugging improvements of asynchronous code and the information that we are given about for instance how many references there are to our method(s).<!--excerpt-->

You've been able to see the current executing threads for a while now in previous versions of Visual Studio, but now you can see a breakdown of the current tasks that are being executed. While you are debugging your application you can go ahead and open up the new `Tasks` window. Without having to navigate yourself around the endless menus in Visual Studio, you can go up to the right corner (don't click the X!) and type `Tasks` in the search box, you should see something like the following:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/11/ShowingTasks.png" alt="ShowingTasks" width="608" height="119" class="alignnone size-full wp-image-2135" />

I put together a fairly simple code snippet to show some data in the new window that we have access to in order to get improved information about the running tasks and the sample looks something like this:

    class AmazingApi
    {
        public async Task ExecuteAsync()
        {
            var tasks = new[]
            {
                Task.Delay(600),
                Task.Delay(200),
                Task.Delay(100),
            };

            Task.Run(async () =>
                {
                    await Task.Delay(500);
                    await Task.Delay(1000);
                }
            );

            await Task.WhenAll(tasks);
        }
    }

Notice that the method doesn't really return anything but it's best practice to return a `Task` instead of `void`, <a href="http://filipekberg.se/2013/10/29/advanced-async-talk-alt-net/" target="_blank">I recently did a talk on why that is so if you want to know that go and have a look!</a> Another thing to notice is that I follow the method naming convention and appending the word `Async` to the method name.

Alright, let's go back to the window that we are looking for now, I set a breakpoint, told Visual Studio to start a new debugging instance and this is what I get now:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/11/AsyncImprovementsInVs2013.png" alt="AsyncImprovementsInVs2013" width="800" class="alignnone size-full wp-image-2136" />

The `Tasks` window gives us tons of important information such as:

<ul>
<li>Task Id</li>
<li>Status</li>
<li>Start time</li>
<li>Duration</li>
<li>Where the code is located</li>
<li>What task it is (notice the state machine for the async method)</li>
</ul>

If you find yourself writing a lot of asynchronous code, this will be really helpful! 

Do you have a favourite feature of Visual Studio 2013 yet or are you stuck at an older version of Visual Studio and miss some of the new features? I'd love to hear your comments!
