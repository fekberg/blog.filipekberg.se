---
layout: post
title: Introducing the ASP.NET Web API
date: 2012-03-19 15:02
author: fekberg
comments: true
metadescription: Using the ASP.NET Web API is really easy and allows you to expose data in many different formats such as XML or JSOJN.
categories: .NET, C#, Programming
tags: aspnet, csharp, ef4, entity-framework, mvc4, webapi
---
In the new version of ASP.NET you can use something called ASP.NET Web API. This allows you to expose your data in many different formats, such as XML or JSON. The idea is to provide a REST API where you use HTTP for real. Meaning that you use GET/POST/PUT/DELETE.<!--excerpt--> These work pretty straight forward:

<ul>
	<li>GET - Retrieve all or one item</li>
	<li>POST - Add an item</li>
	<li>PUT - Update an item</li>
	<li>DELETE - Remove an item</li>
</ul>

As mentioned above, you can retrieve data in different formats such as XML or JSON. The type of data that will be in the response is determened by the HTTP header Accept. By default(built-in) you can use the two following accept headers:

<ul>
	<li>application/json</li>
	<li>applicaiton/xml</li>
</ul>

In order to try this out, I will be using <a href="http://curl.haxx.se/download.html">curl </a>to make the web requests, because this will allow me to specify the headers manually.

Start off by creating a new <a href="http://www.asp.net/mvc/mvc4">ASP.NET MVC 4 Web Applicaiton</a> in <a href="https://www.filipekberg.se/2012/03/01/visual-studio-11-beta/">Visual Studio 11 Beta</a>:

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/03/11.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/03/11.png" alt="" title="Creating a new ASP.NET MVC 4 Web Application" width="640" class="aligncenter size-full wp-image-645" /></a>

Then you will be presented with what kind of <a href="http://www.asp.net/mvc/mvc4">ASP.NET MVC 4</a> project that you want to create, select to create a new <a href="http://www.asp.net/web-api">Web API</a> project:

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/03/21.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/03/21.png" alt="" title="Create a ASP.NET MVC 4 Web API Project" width="640" class="aligncenter size-full wp-image-645" /></a>

When the project is created, you'll have some new things that you haven't seen before in a normal ASP.NET MVC application. It does look a lot like a normal ASP.NET MVC applications, but with some minor add-ons.

The first thing that we are presented with is the `ValuesController` and this controller inherits from the `ApiController`. The `ApiController` is what you will inherit from when you are creating API specific controllers. It will help you map the HTTP requests GET/POST/PUT/DELETE to the methods with the corresponding names.

The second thing that is added is inside the global.asax.cs, a new route to specify where we retrieve the API specific controllers:

    routes.MapHttpRoute(
        name: "DefaultApi",
        routeTemplate: "api/{controller}/{id}",
        defaults: new { id = RouteParameter.Optional }
    );

This just help us distinguish between our API calls and non-API calls. If you just start the web application and navigate to /api/values/ you will see a list like this:

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/03/31.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/03/31.png" alt="" title="View the Values in Chrome" width="640" class="aligncenter size-full wp-image-645"/></a>

If we open this in Internet Explorer 10 instead, it will request a JSON result instead of XML and if we open that up in notepad, it looks like this:

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/03/41.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/03/41.png" alt="" title="Open up the Values result as JSON from Internet Explorer" width="640" class="aligncenter size-full wp-image-645" /></a>

We can verify that this works by testing it out with curl.

<strong>Get JSON using curl</strong>

    curl -H "Accept: application/json" -H "Content-Type: application/json" -X GET "http://localhost:13938/api/values"

JSON Result:

    ["value1","value2"]

<strong>Get XML using curl</strong>

    curl -H "Accept: application/xml" -H "Content-Type: application/xml" -X GET "http://localhost:13938/api/values"

XML Result:

    <?xml version="1.0" encoding="utf-8"?>
    <ArrayOfString xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <string>value1</string>
        <string>value2</string>
    </ArrayOfString>

This is good and all, but we might want to be able to specify what kind of format that we expect with a query string. To do this, we can register a formatter for a certain query string mapping. Go back to global.asax.cs and add the following at the end of `Application_Start`:

    GlobalConfiguration.Configuration.Formatters.JsonFormatter.MediaTypeMappings.Add(
        new QueryStringMapping("type", "json", new MediaTypeHeaderValue("application/json")));

    GlobalConfiguration.Configuration.Formatters.XmlFormatter.MediaTypeMappings.Add(
        new QueryStringMapping("type", "xml", new MediaTypeHeaderValue("application/xml")));

This will allow you to add `?type=json` or `?type=xml` to request a certain output format:

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/03/51.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/03/51.png" alt="" title="Specify the output format of the data requested" width="640" class="aligncenter size-full wp-image-645" /></a>

If you want to retrieve a specific item, you can simply do `/api/values/1`.

This has been a short introduction to get you started with the ASP.NET Web API. If you found this interesting, stay tuned for the <a href="https://www.filipekberg.se/2012/03/17/dont-miss-me-coding-on-stage-for-2-days-at-webbdagarna/">live stream that I will do from Webbdagarna</a> (if the Internet connection allows) and also stay tuned for upcoming posts where we hook up with Entity Framework to make this API more alive.
