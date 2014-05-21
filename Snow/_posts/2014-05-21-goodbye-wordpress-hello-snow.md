---
layout: post
title: Goodbye Wordpress Hello Snow
date: 2014-05-21 17:00
author: fekberg
comments: true
published: draft
metadescription: I've left Wordpress for Sandra.Snow to get reliability and speed
categories: Architecture, Programming
tags: Microsoft Azure, Wordpress
---
As per my previous post [I've moved to Azure](http://blog.filipekberg.se/2014/05/20/moving-microsoft-azure/) and this has been a really interesting experience so far. Not only did it force me to learn more about the offerings of Microsoft Azure, but I also came to the conclusion that moving away, as far as possible, from Wordpress was about time.

### Why?
After I had migrated to Microsoft Azure with my Wordpress blog I looked closely over how the average response time increased for the site, compared to what I had on my previous server. It wasn't until I published another WebSite on the same Instance that I noticed that I didn't really have to live with the long load times.

[The website where you can buy C# Smorgasbord as an ebook is written in ASP.NET and runs on that same instance.](http://books.filipekberg.se) Interestingly enough it loads in about 200-300ms, depending on where you are of course. My tests were consistent and the tools I use to monitor my websites told me the same; this site performed 600-700ms better than my blog running Wordpress.

Of course, the content is different. Does the content difference justify an additional 600-700ms to just load the first page? **I think not.**

My comments were already moved to Disqus so what else did I have on my blog that needed to be dynamic? Turned out that the only two things that I had was Search and E-mail subscribers via Wordpress. Fortunately for me, most of you read my blog by navigating directly to it or by subscribing to the [RSS](/feed/) feed. For those of you that have been subscribing to the blog via E-mail, I suggest subscribing to the RSS instead, or follow me on twitter to get updates when I post new stuff. I might setup a third-party E-mail service later on, but it is not on my radar today.

Given that I could skip the importance of E-mail subscription, I only had the search left to worry about. I went over to Google analytics to see how many of you actually use the search and guess what? Most of you don't. If you want to find something on the blog I bet you just Google for it, which is a better search engine than what I had on the blog, right?

If we remove e-mail subscribers and search, all that is left is static content. So why would I use something as heavy as Wordpress to serve that? I don't know and that is why I decided to say goodbye to Wordpress.

### Choosing a new blog engine
After a bunch of discussions on [JabbR](https://jabbr.net/#) I came to the conclusion that I wanted to go with a static file hosting plan as suggested by a lot of the frequent users I looked up [Sandra.Snow](https://github.com/Sandra/Sandra.Snow). I'll call it **Snow** for short from now on.

My only worry was that it would be hard for me to migrated from Wordpress to a new blog engine, so my first goal was to find out how much trouble I was in if I wanted to do this. Snow is inspired by Jekyll, a blog engine that relies on Markdown. When it processes the markdown files it generates static html files for you.

[Snow is open source, and available on github](https://github.com/Sandra/Sandra.Snow). This makes it easy for me to extend it if is so choose. It's also built on Nancy (Yay!).

### Converting all the content to "Markdown"

Getting all my content converted to markdown meant that I had to export everything from Wordpress. I had already gone through the trouble as you saw in my previous post to add all the images to the Azure Storage/CDN. This means that I can point to the same resources, I just need to convert all the content into files that Snow understand.

I found another tool, also open source, called [wpXml2Jekyll](https://github.com/theaob/wpXml2Jekyll). To my surprise it was written in C# which made it very easy for me to tweak it to my liking. As Wordpress handles re-writing all image sources to point to the CDN, I had to manually swap all the links out to point to that. I had also invested a lot of time in writing SEO Titles and Meta Descriptions for each post on my blog, and I wanted to persist this.

*Set out to convert my blog to markdown files, I started the convertion and it turned out great!*

The result was OK, actually better than OK, it would have taken me so much longer to extract my 150 posts manually. When writing my posts using Wordpress I had used a plugin to insert code snippets, so all my code snippets were surrounded by something looking like this:

	[cc lang="c#"]
	var x = 10;
	[/cc]

If that was all, it would have been easy. However I also had inline code in text that looks like this:

	Some text that talks about [cc lang="c#" inline="true"]dynamic[/cc]

In other cases it might be a different language than C# and the attributes might be in different order. After spending an hour or so trying to parse that with regex, I gave up and found myself tweaking all **150 files manually**, looking for those code snippets. To make it proper markdown the multiline code needs to be tabbed and the inline ones uses `. This took some time though, I spent more than a couple of hours going over all the files.

I say "markdown" because it is not proper markdown, the files still have HTML inside them so that was not converted, but that doesn't matter because it still works.

![](http://cdn.filipekberg.se/fekberg-blog/goodbye-wordpress-hello-snow/posts.png)

**All posts are now markdown, now what?**


Having all the content made it easy enough to start playing with Snow, I wanted to replicate my current blog as close to 100% as possible.

So far this is where I am at:

* All images are stored in Azure Storage and will continue to be there even after Wordpress is purged
* All posts are in markdown that renders content correctly, including linked images
* Comments already migrated to Disqus
* Sharing (ShareThis) relies on equal domain and path name

### Setting up Sandra.Snow
Now that I had everything in place all that was left was to get Snow to convert this all into proper HTML. You can get started with Snow by either forking the repository or downloading the [pre-compiled assemblies and binaries](https://github.com/Sandra/Sandra.Snow.SnowTemplate), I did the latter because I had some initial problems compiling it out of the box.

#### Folder structure
The root folder for my Snow site has two things at the moment:

* compile.snow.bat
* Snow

The second one being Snow with all its content. I have it like this because after running the compile.sno.bat I want to have a folder created called `Website` making the structure look like this:

* compile.snow.bat
* Snow
* Website

Just makes it a bit tidy. What is interesting though is the Snow folder itself, it contains 4 interesting things.

##### _compile
This folder is where all the Snow magic is stored. It contains the executable and the assemblies it relies on; such as Nancy.

Notice that we have `Nancy.ViewEngines.Razor.dll` in here. **Yes**, you guess right, you can write your theme in Razor!

##### _posts
In the `_posts` folder we put all the posts that we want to publish. This is where we directly put our markdown files as you saw in the screenshot above in this post.

##### themes
As I have my posts, all I need is to create my theme. This is where we do just that. I am a ASP.NET guy and I really enjoy working with Razor. Snow lets me do this and we can even have multiple themes! I created a theme that I call `fekberg`.

![](http://cdn.filipekberg.se/fekberg-blog/goodbye-wordpress-hello-snow/fekberg_theme.png)

As you see a bit further into the folder structur we have a `_layouts` folder, in this we put our "master page", also know as the Layout file in ASP.NET MVC.

We can also define templates for certain things, such as what a post will look like. As you might now, if you navigate to my blog from a computer using a big enough resolution you will see a sidebar. The sidebar contains an archive of all my posts.

Snow exposes data like this through the `Model` usable in our Razor views:

	<h2>Arch<span>ives</span></h2>
	<ul>
	    @foreach (var item in Model.MonthYearList)
	    {
	        <li><a href="@item.Url">@item.Title</a></li>
	    }
	</ul>

Same goes for the file, `post.cshtml` that we use to define the post template:

	@inherits Nancy.ViewEngines.Razor.NancyRazorViewBase<Snow.ViewModels.PostViewModel>
	@using System.Collections.Generic
	@{
	    Layout = "default.cshtml";
	    
	    var url = "http://blog.filipekberg.se" + @Model.Url;
	}
	
	<div class="post">
	    <h1><a href="@Model.Url">@Model.Title</a> </h1>
	    <h2>Posted by <a href="/about-filip/">Filip Ekberg</a> on @Model.PostDate.ToString("dd MMM yyyy")</h2>
	    @Html.RenderSeries()
	
	    @Html.Raw(Model.PostContent)
	    
	    <div class="post-info-bottom">
	        <span class="post-info-category">
	            @foreach (var category in Model.Categories)
	            {
	                @:| <a href="/category/@category.Url">@category.Name</a>
	        }
	        </span>
	    </div>
	    @Html.RenderDisqusComments("fekberg")
	</div>

Compare this to the PHP-file that you have to work with when developing for Wordpress.

Of course we can define pages as well, I've created `about-filip.cshtml` which is converted into `/about-filip/` after Snow has processed it.

Having showed you a bit about how I setup my template, you might wonder how Snow knows what is a new page, what template to use and how to do configurations? Well, keep on reading, that is in the `snow.config`.

##### CNAME
This is a rather simple file, it only contains the blogs CNAME which in my case is `blog.filipekberg.se`.

##### snow.config
The config is where the magic happens, this is where we define what goes where and what uses what. I can for instance set the following things:

* Blog Title
* Site URL
* Author
* Email
* Posts folder (`_post`)
* Layouts folder
* Theme name
* Output
* URL Format
* Which directories to copy from the themes folder
* Which files and how to process each file

The URL Format was important to me, I wanted everyone that linked to my blog to still be able to link to the same content. This was truly the most important part as it would otherwise break everyting.

My snow.config looks like the following:
	
	{
	  "blogTitle": "Filip Ekberg's Blog",
	  "siteUrl": "http://blog.filipekberg.se",
	  "author": "Filip Ekberg",
	  "email": "mail@filipekberg.se",
	  "posts": "_posts",
	  "layouts": "_layouts",
	  "theme": "fekberg",
	  "output": "../Website",
	  "urlFormat": "yyyy/MM/dd/slug",
	  "directoryname": "",
	  "copyDirectories": [
	    "images",
	    "uploads",
	    "js",
	    "fonts",
	    "css",
	  ],
	  "processFiles": [{
	    "file": "index.cshtml",
	    "loop": "Posts"
	  },{
	    "file": "category.cshtml",
	    "loop": "Categories"
	  },{
	    "file": "categories.cshtml => category"
	  },{
	    "file": "archive.cshtml"
	  },{
	    "file": "my-book.cshtml => my-book"
	  },{
	    "file": "about-filip.cshtml => about-filip"
	  },{
	    "file": "contact-filip.cshtml => contact-filip"
	  },{
	    "file": "rss.xml => rss",
	    "loop": "RSS"
	  },{
	    "file": "feed.xml => feed",
	    "loop": "atom"
	  }]
	}

As you see here I tell it to put `about-filip.cshtml` after it has been processed into `/about-filip/`.


#### Going for a test run
My files were clean enough so it was easy for me to extract my theme from Wordpress to the Snow template. After having done that and put all my markdown files into the `_posts` folder I executed `compile.snow.bat`.

This file contains the following:

	.\Snow\_compiler\Snow.exe config=.\Snow\ server=true

Make note of `serve=true` this will tell Snow to serve the files after it has processed the site which makes it easy to test locally. Running that showed me something like this (note that I navigate to this post as a draf! blog-ception!):

![](http://cdn.filipekberg.se/fekberg-blog/goodbye-wordpress-hello-snow/snow_test_run.PNG)

