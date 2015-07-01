---
layout: post
title: ASP.NET 5 and MVC 6
date: 2015-06-30 00:00
author: fekberg
comments: true
published: draft
metadescription: ASP.NET 5 and MVC 6
categories: .NET, C#
tags: .NET, C#, ASP.NET, ASP.NET vNext, ASP.NET 5, MVC 6
---
If you are a web developer, you will most definitely be happy about the coming updates to ASP.NET and MVC. It really comes hand in hand with the re-work of CoreCLR, and the amazing work Microsoft is doing in the open-source space!

As of Today, Microsoft released the (fifth beta of ASP.NET 5)[https://github.com/aspnet/announcements/issues?q=milestone%3A1.0.0-beta5], which introduces a bunch of (breaking) changes.

I have been working with ASP.NET 5 and MVC 6 for a few months now, and I can honestly say that I really like what I am seeing. One thing that I really like is the fact that there's not really a differentiation between MVC and WebAPI; you have your controllers, actions and views/content returned to the consumer. Be it a View, JSON or XML, it doesn't really matter.

Out of the box, it feels like ASP.NET 5 promotes better application design. It comes with it's own dependency injection, it's more testable, configuration improved, startup pipeline is very configurable and extendable; overall it feels lightweight if you want it to be, and it could grow in to a large enterprise application if that is the purpose.

A really important aspect of ASP.NET 5, is the promise of cross-platform. I've developed, and run, an ASP.NET 5 application on OSX and it works great! Esepcially with Visual Studio Code. Unless you want to setup the project template yourself, you can use something called (Yeoman (`yo aspnet`))[http://blogs.msdn.com/b/webdev/archive/2014/12/17/yeoman-generators-for-asp-net-vnext.aspx] to create the project template.

## The ASP.NET 5 Project
When starting a completely new ASP.NET 5 Project, be it in OSX using Yeoman, or in Visual Studio 2015 you will immediately see a lot of changes compared to what you might be used to. If this is your first encounter with ASP.NET 5, I'd recommend using the template that gives you a test site, and just remove what you don't need.

[IMAGE HERE]

As you see in the screenshot, a new project using the website template you get quite a bit of pieces to play with.

## Dependency Injection with Autofac
I really like using Autofac, thus one of the first things I do when setting up a new project is to add it to my project.

## Testing with XUnit

## Continious Integration with TeamCity

## Deploying with Octopus
