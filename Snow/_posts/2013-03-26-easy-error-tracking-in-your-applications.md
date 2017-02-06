---
layout: post
title: Easy error tracking in your applications
date: 2013-03-26 11:17
author: fekberg
comments: true
metadescription: Easy error tracking in your applications using Raygun from Mindscape!
categories: .NET, C#, Programming, WinRT
tags: csharp, error tracking, mindscape, raygun
---
Over and over again I see developers re-implementing error tracking, I've been there myself. One of the reasons to this I think is because many of the tracking tools out there add too much noise and are just cumbersome to use. In many cases the biggest problem is that you need error logging too late, meaning that you want the logging once the error has already occurred. It's of course cleaver to say that you should always think about potential errors from the start, because let's face it we all write applications that may have unexpected exceptions.<!--excerpt-->

<img src="http://raygun.io/images/assets/raygun.png" alt="" style="float: right; padding-left: 10px; padding-bottom: 10px;" height="120">Another problem is that if we do decide to log errors in our applications, where do we store them and how do we collect the logs? Luckily there's tools out there that can help us on the way. One that I most recently came across called <a href="http://raygun.io/" target="_blank">Raygun</a>. <a href="http://raygun.io/" target="_blank">Raygun </a>is a product from the company <a href="http://www.mindscapehq.com" target="_blank">Mindscape </a>that have some very interesting products in their family.

<blockquote>Error handling just got awesome!</blockquote>

The punch line of <a href="http://raygun.io/" target="_blank">Raygun</a> is quoted above, a tool that makes error handling awesome. Let's clear something up right before we take a look at <a href="http://raygun.io/" target="_blank">Raygun </a>, there are multiple providers supplied for Raygun: <strong>JavaScript</strong>, <strong>.NET</strong>, <strong>Java</strong>, <strong>PHP </strong>and <strong>Cold Fusion</strong>. Didn't find the language you work with? Don't worry, there's a REST API for you RESTafarians!

<em>So there are providers for Raygun, but what does it actually do?</em>

<img src="http://raygun.io/images/robots/homeRobot_right.png" alt="" style="float: left; padding-right: 10px; padding-bottom: 10px;" width="120" />Imagine that you have your web application written in PHP, ASP.NET or just something that is using JavaScript. Now you want some centralized place where you can store errors in either of these applications, be it severe exceptions or just notices about something unexpected.<br/><br/>If you've found yourself writing an error tracker where you just dump the Stack Trace and the exception message into a database, then this is certainly something for you. Imagine that if your customer calls up and says that he recently got the yellow screen of death but don't know what he was doing or really exactly what time it was.<br/><br/>Now imagine that you were to access your centralized error tracker and you'd have all of the information that you would need to find the error in the code base including:

<ul>
	<li>Time of error</li>
	<li>How many times the current error have occurred</li>
	<li>Information about the system the user is using</li>
	<li>The exception message</li>
	<li>A Stack Trace</li>
</ul>

<strong>That is Raygun!</strong> A way to track your errors in a very easy way and the presentation is just beautiful.

The information you'll get out of each error report of course depends on the data that you supply Raygun with. Take a look at the <a href="http://raygun.io/raygun-providers/rest-json-api" target="_blank">REST API</a> to get an idea of all the data that you possibly could supply Raygun with.

Enough with what, let's look at the how! <strong>Let's look at some code!</strong>

For this demo I'm going to setup 2 things an ASP.NET MVC 4 Application and a Class Library that will simulate a data store where I can search for people. The web front will allow me to search for people inside my collection and when I wrote this example Raygun actually helped me detect one of the errors I were getting, let's call this "TrackCeption".

First of all let's look at the library. There's a very easy class that represents the person, it simply has a property called "Name" inside it.

    public class Person
    {
        public string Name { get; set; }
    }

Secondly there's a class that handles the search requests, I call this `RequestHandler`. To set this up we need to create a new list of people, in this case it's just going to be a static collection of people as you can see here:

    private static IEnumerable<Person> _people;
    public RequestHandler()
    {
        _people = new Person[] {  
                new Person { Name = "Filip" },
                new Person { Name = "Sofie" },
                new Person { Name = "Johan" },
                new Person { Name = "Anna" },
            };
    }

Now we need a way to retrieve all these people and I like creating asynchronous methods where the operations might be time consuming and in this case I know that it will take 2 seconds to retrieve the list of people:

    public Task<IEnumerable<Person>> GetPeopleAsync()
    {
        return Task<IEnumerable<Person>>.Factory.StartNew(() => {

            Thread.Sleep(2000);

            return _people;
        });
    }

This leaves us with implementing a method that lets us search for people in the collection. So far we don't care if the list has been empty or not but when we search we want to report an error when there's no people in the list. Let's just assume that this is an exception in the application and the end user will always search for people that are in the list.

<strong>Let's install Raygun!</strong>

Installing Raygun is as easy as saying "I'll soon blast all my errors with this Raygun!"; simply bring up the NuGet package manager and write the following:

    PM> Install-Package Mindscape.Raygun4Net

This will install Raygun into your class library! There's a couple of more things that we need to do in order to get Raygun up and running:

<ul>
	<li>Create an account and an application at <a href="http://app.raygun.io" target="_blank">Raygun.io</a></li>
	<li>Add the API Key to your application</li>
</ul>

Creating a Raygun account is free for 30 days and you'll need to do it in order to start tracking your errors. Once you've setup an application on Raygun you can retrieve the API Key from the "Application Settings" menu like you can see in the following image:

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/03/RaygunAPIKey.png" alt="RaygunAPIKey" width="586" height="616" class="alignright size-full wp-image-1879" />

We don't need to add the API Key just yet, we'll add that in the application configuration file of the project that will use our library later on (in this case the MVC 4 project).

Now, bringing in Raygun into our application using NuGet will allow us to write the following:

    new RaygunClient().Send(new Exception(string.Format("People with name `{0}` not found", name)));

That will create a Raygun client and send a new exception with the message you can see to the Raygun servers and passing it the API Key that we will provide later on. So let's take a look at how the method that will find people in the colleciton will look like. This one also takes 2 seconds to execute so we will have this one asynchronous as well, we don't need to do it but I take every chance I got to play with asynchronous programming.

    public Task<IEnumerable<Person>> FindPeopleAsync(string name)
    {
        return Task<IEnumerable<Person>>.Factory.StartNew(() =>
        {
            Thread.Sleep(2000);

            var people = _people.Where(x => x.Name.Contains(name)).ToList();

            if (people == null || !people.Any())
            {
                new RaygunClient().Send(new Exception(string.Format("People with name `{0}` not found", name)));
            }

            return people;
        });
    }

The method will look for people with the name of the value that we passed to the method and if there's no people found it will send this notice to Raygun. You might think to yourself that this isn't really a good exception at all, but for the purpose of the demo, let's just look pass that. Also a bird whispered into my ears that Mindscape is working on adding other message types than exceptions to Raygun, but that's in the future.

This leaves us with a structure looking like the following:

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/03/RaygunDemoLibrary.png" alt="RaygunDemoLibrary" width="436" height="243" />

<strong>We are now ready to use our library!</strong>

Create a new ASP.NET MVC 4 Application, I named mine RaygunDemo. The first thing that we are going to do is to add Raygun to this project as well, install it into the ASP.NET MVC 4 project using NuGet as we did before and open up web.config once this is done.

In order for us to get Raygun working we need to add our API Key. To do this we first need to add an element inside `<configSections>`:

    <section name="RaygunSettings" type="Mindscape.Raygun4Net.RaygunSettings, Mindscape.Raygun4Net"/>

This will allow us to add a configuration like this:

    <RaygunSettings apikey="YOUR_API_KEY_HERE" />

It should look something like this in your web.config, with a lot of extra stuff as well of course:

    <?xml version="1.0" encoding="utf-8"?>
    <configuration>
      <configSections>
        <section name="RaygunSettings" type="Mindscape.Raygun4Net.RaygunSettings, Mindscape.Raygun4Net"/>
      </configSections>
      <RaygunSettings apikey="YOUR_API_KEY_HERE" />
    </configuration>

Remember I said that Raygun helped me find an exception in my application when setting up the demo application? This is because I told Raygun to submit all the application errors. In the ASP.NET MVC 4 project, open up Global.asax and add the following method, this one will be run every time there's an error in the application:

    protected void Application_Error()
    {
        var exception = Server.GetLastError();
        new RaygunClient().Send(exception);
    }

This means that every time that we get an application error Raygun will be noticed of this and the entire Stack Trace, Computer info and such will be passed into Raygun!

All there's left to add now is the Home controller and the view, the Home controller consists of two asynchronous actions that will use the library we just created. One will return a view and the other will return a Json result:

    public async Task<ActionResult> Index()
    {
        var requestHandler = new RequestHandler();
        var people = await requestHandler.GetPeopleAsync();

        return View(people);
    }
    public async Task<JsonResult> Search(string search)
    {
        var requestHandler = new RequestHandler();
        var people = await requestHandler.FindPeopleAsync(search);
                
        return Json(people);
    }

The view is equally simple, it only has a text box that allows us to search for names and then it has a list that shows all the people. Once a key is pressed inside the text box an event is fired that requests the people that have a name containing that part:

    @model IEnumerable<RaygunDemoLibrary.Person>

    <div>
        <span>Search: </span>
        <span><input id="search" type="search" /></span>
    </div>
    <h2>People</h2>
    <div id="people">
        @foreach (var person in Model)
        {
            <div class="person">
                <span>@person.Name</span>
            </div>
        }
    </div>

    @section scripts{
        <script>
            $("#search").keyup(function () {
                searchValue = $("#search").val();
                $.post("/Home/Search", { search:  searchValue}, function (data) {
                    var peopleDiv = $("#people");
                    peopleDiv.html("");
                    data.forEach(function (person) {
                        name = person.Name.replace(searchValue, "<strong>" + searchValue + "</strong>");
                        peopleDiv.append("<div class='person'><span>" + name + "</span></div>");
                    });
                });
            });
        </script>
    }

If I start this and search for a name that exists and one that doesn't it will look like the following:

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/03/RaygunReportError.png" alt="RaygunReportError" width="716" height="306" class="alignright size-full wp-image-1885" />

Funny thing is that we didn't actually notice anything when we searched for something that didn't exist. So how do we know that this worked?

Raygun comes with an Amazing dashboard that will give you an overview of everything including all the recent errors, how many errors/ignored errors you have and much more like you see in this image (click to enlarge):

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/03/RaygunReport.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/03/RaygunReport-171x300.png" alt="RaygunReport" width="171" height="300" class="alignright size-medium wp-image-1886" /></a>

Finally this is what it looks like when you go into details about an exception, you'll have a graph over how many times and when it occurred and then you have very much details that will help you Raygun the errors!

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/03/RaygunStackTrace.png" alt="RaygunStackTrace" width="810" class="alignright size-full wp-image-1888" />

If you're unable to add code to your current website you can simply add a HTTP Module and a config value! Which means you could simply add this in your web.config provided you have the dll as well of course!

    <httpModules>
      <add name="RaygunErrorModule" type="Mindscape.Raygun4Net.RaygunHttpModule"/>
    </httpModules>

<strong>I really recommend giving Raygun a try!</strong> Let me know what you think of it and if you have any alternatives that are equally awesome!
