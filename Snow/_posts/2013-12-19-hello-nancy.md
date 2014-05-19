---
layout: post
title: Hello Nancy
date: 2013-12-19 01:08
author: fekberg
comments: true
metadescription: Have you tried Nancy yet? It makes life easier!
categories: C#
tags: ASP.NET, C/C++, csharp, Getting started, How-to, Nancy, Programming, Web, Web Development
---
<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/12/nancy-logo.png" alt="nancy-logo" width="70"  style="float: right; margin: 0; padding: 0; padding-left: 20px;" class="alignnone size-full wp-image-2157" />Have you had a chance to play with Nancy yet? Nancy is a way for us to experience the web in a lightweight way, without relying on ASP.NET or ASP.NET MVC. I'm not saying that Nancy is replacing any of those, but it is here as an alternative. Let's look at some examples of what a Nancy demo application might look like, to give you an idea of how easy it is.<!--excerpt-->

<blockquote>Nancy is a lightweight, low-ceremony, framework for building HTTP based services on .Net and Mono. The goal of the framework is to stay out of the way as much as possible and provide a super-duper-happy-path to all interactions.</blockquote>

As the authors of Nancy explains it, they want to stay out of the way as much as possible. Have you ever created an Emtpy Web Application and then added everything that you need to get ASP.NET MVC running? It might be trivial, it might not be, depends on how much knowledge you have about what happens when you create a new ASP.NET MVC Web Application using the template.

I figured I wanted to give Nancy a try, I've seen it being used all over the place and people are praising it as it is really lightweight and not in your way; I really like things like that! (Which is why I wrote my book using LaTeX: Focus on Content and not the Markup).

<strong>So where do you start?</strong> <a href="https://github.com/NancyFx/Nancy" target="_blank">Nancy is open source</a> and I figured I shouldn't have to pull the code from <a href="https://github.com/NancyFx/Nancy" target="_blank">Github</a> to get started, there must be a NuGet package! So let's create a new Empty Web Application and start from there.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/12/1.png" alt="1" width="800" class="alignnone size-full wp-image-2154" />

This leaves us with a pretty blank solution and we can start off by trying to install some stuff via NuGet. Bring up the Package Manager Console, write <strong>Install-Package Nancy</strong> and press Tab. This will show you a huge amount of interesting packages that we might need to get this running.

Since we created an empty web application, we're going to use the "ASP.NET Host", there's a package that helps us configure all that called <strong>Nancy.Hosting.Aspnet</strong>, we're also going to want the Nancy base package and the package that lets use Razor as a view engine. So let's bring the following packages into our solution:

    Install-Package Nancy
    Install-Package Nancy.Hosting.Aspnet
    Install-Package Nancy.Viewengines.Razor

These packages have dependencies on Nancy so we probably wouldn't need to bring in the base package itself as they would have done that. Alright, now we have a set of references in our project and it most likely did some changes in the web.config, let's not care about that for now. There's not really much in our solution, we just have the references, packages config and the web config!

<strong>How do we create a web page?</strong>

I haven't dug deep enough in the history of Nancy or why they call things what they do, but in order to create "something" that serves us data (or lets us receive data) is called " `Modules`". These modules inherit from a class called `NancyModule`.

In the constructor of the module we could define the routes for the current module. If you're an ASP.NET MVC developer you know that our routes are setup in the Global.asax.cs file, here the module is in charge of setting up its routes.

These routes are setup using something called `Get` (for Get that is!), there's also Post, Put, Delete, Patch and what other Http Verbs there might be. This is fairly straight forward, we can define a route by assigning a function to a pattern, this pattern can be a complex regex or it can be a simple string.

Let us say that I want to return a string when I navigate to `/` on my website, I could simple setup the following route in my modules constructor:

    Get["/"] = _ => 
        "Welcome to my Nancy Demo Site!";

When the application is launched and you navigate to `/` it will now simply display that text, if you view the source, it is only that text, no wrapping HTML or anything like that.

The entire code for making that work is the following:

    using Nancy;

    namespace NancyDemo
    {
        public class NancyDemoModule : NancyModule
        {
            public NancyDemoModule()
            {
                Get["/"] = _ => 
                    "Welcome to my Nancy Demo Site!";
            }
        }
    }

<strong>Simple enough right?</strong>

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/12/3.png" alt="3" width="800" class="alignnone size-full wp-image-2156" />

The solution is so clean and we can focus on what is important: <strong>The functionality of the application!</strong>

We don't really want all our HTML inlined in our code though, so how about if we move this to a Razor view instead? Remember from before, we pulled in `Nancy.Viewengines.Razor` from NuGet this allows us to use Razor views! It does a lot of magic in the Web.config but let us not worry about that too much, it still keeps the solution clean for us.

I setup a directory structure that I am happy about, I moved my Nancy module to a folder called Controllers then I created another folder called Views where I want to add all my views. There are multiple different View Engines that you can use with Nancy, but I am most familiar with Razor so I am going to stick with that.

Instead of returning a string in the function that we associate with the Get route, we can simply return a View like this:

    Get["/Demo"] = _ => View["Demo"];

This will look for the view "Demo" in the Views folder, Nancy uses some magic to find the correct view, just as it uses some magic to determine which route to use if routes are similar.

I added a Layout.cshtml file in the Views\Shared folder, the funny thing is that Nancy seem to reference these layout files a bit different from how I've done it in ASP.NET MVC, not entirely different, but different enough that it will crash if you don't do it right.

Normally when setting which layout file to use we do the following:

    Layout = "~/Views/Shared/_Layout.cshtml";

However, with Nancy we must remove the leading "~/" otherwise it will throw an exception on us. My view  does thus look like this:

    @{
        Layout = "Views/Shared/_Layout.cshtml";
    }

    Hello from my Nancy Demo!

Easily enough I can press F5 to debug the application and it shows me my two beautiful pages.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/12/Nancy-Browsing-Website.png" alt="4" width="800" class="alignnone size-full wp-image-2156" />

There's much more to Nancy than this demo application, but with just some easy steps we've created something we can work with and we don't have so much in the application that it's messy with lots of files.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/12/5.png" alt="5" width="800" class="alignnone size-full wp-image-2156" />

The <a href="https://github.com/NancyFx/Nancy/wiki/Documentation" target="_blank">Nancy documentation page</a> is full with lots of interesting information about what you can do with Nancy and <strong>I'd love to hear if you used Nancy in a larger production web site!</strong> If you get hooked on Nancy or want to read more about it, <a href="http://www.philliphaydon.com/category/nancyfx/" target="_blank">Philip Haydon has a lot of interesting articles on his blog</a>!

