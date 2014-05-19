---
layout: post
title: ASP.NET MVC, Web API & Web Pages released as open source on CodePlex
date: 2012-03-28 13:47
author: fekberg
comments: true
metadescription: ASP.NET MVC, Web API & Web Pages source code is now available on CodePlex! 
categories: .NET, C#, Programming
tags: aspnet, csharp, open source, web api, web pages
---
Microsoft have just released a lot of code openly on <a href="http://aspnetwebstack.codeplex.com/">CodePlex</a>. 

<strong>I don't think I need to stress how amazing this is!</strong><!--excerpt-->

The source code just released includes the following:

<ul>
	<li><a href="http://www.asp.net/mvc">ASP.NET MVC</a></li>
	<li><a href="http://www.asp.net/web-api">ASP.NET Web API</a></li>
	<li><a href="http://www.asp.net/web-pages">ASP.NET Web Pages(Razor)</a></li>
</ul>

If you head over to the <a href="http://aspnetwebstack.codeplex.com/">CodePlex</a> page called ASP.NET Web Stack. You're going to find a lot of useful information here regarding the code base. Since CodePlex now supports git, it's Very easy for a lot of us to integrate with the development process and contribute patches, yes, you heard me right: <strong>contributions</strong> by anyone!

To get started, fire up your favorite git program and clone this repository: <strong><a href="https://git01.codeplex.com/aspnetwebstack.git">https://git01.codeplex.com/aspnetwebstack.git</a></strong>.

I'm using <a href="http://www.syntevo.com/smartgit/index.html">SmartGit</a> in Windows and as you can see by the following screenshot, you've got a lot of nice information about the commits, branches, merges and fixes! Most important of all, it's alive, there are a lot of contributions made the last couple of days and I really think this will increase the quality of what is already high quality.

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/03/WebAPI_1.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/03/WebAPI_1-1024x875.png" alt="" title="SmartGit overview of ASP.NET MVC/Web API/Web Pages Source Code" width="640" height="546" class="aligncenter size-large wp-image-708" /></a>

When you've got all the code fetched from the repository, all you need to do is fetching all the NuGet packages. They've made this process pretty simple, all you need to do is open up a command prompt, go to the folder where your local repository is and write the following:

	build RestorePackages
	build

Now you're ready to contribute to ASP.NET MVC/Web API/Web Pages! There are multiple ways to how you can contribute, <a href="http://aspnetwebstack.codeplex.com/wikipage?title=Contributing&referringTitle=Home">head over to CodePlex</a> and read more about it.
