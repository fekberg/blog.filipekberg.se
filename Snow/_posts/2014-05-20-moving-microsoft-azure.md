---
layout: post
title: Moving to Microsoft Azure
date: 2014-05-20 17:00
author: fekberg
comments: true
metadescription: Migrate your Wordpress blog to Microsoft Azure today!
categories: Architecture, Programming
tags: Microsoft Azure, Wordpress
---
For a very long time this blog has been running on a Swedish ISP, Glesys. I've been extremely happy with their customer service, their reliability and their speed. However, it comes with a cost, <strong>thus I've decided to move to Microsoft Azure!</strong>.<!--excerpt-->

I've been holding off on moving the blog for a long time, mostly because I'm running Wordpress and have a lot of time and energy invested in the platform, the theme and the plugins. Therefore I had a quite important <strong>must have</strong> checklist before actually moving over to Microsoft Azure:

<ul>
	<li>It needs to be fast and reliable</li>
	<li>It needs to allow me to scale, out or up</li>
	<li>It needs to supply me with an easy interface to do hot fixes of code (FTP or SSH)</li>
	<li>I need to be able to use a CDN</li>
	<li>I need to be able to migrate without any major issues and tweaks</li>
	<li>I need to be able to point my own domains to the Azure WebSite</li>
</ul>

Most importantly is the speed, this is partially handled by serving most files over a CDN. Luckily Microsoft Azure has a CDN service that you can hook into your storage. More on that later.

With the move to Windows Azure I also decided to move the commenting to Disqus, which is also something I've been holding off for a while. A lot of people are using Disqus and as this network has grown I can't resist not to use it. I'll be pulling down comments from Disqus regularly just in case they decide to end their service without notice.

My old system was a virtual machine running Ubuntu, as I was running Wordpress it made most sense to run Apache and MySQL on a linux system. I had setup my virtual machine with a cron-job that checked every half minute or so if the RAM was above 80% usage. If it was, it would just invoke the IPSs API to increase the RAM with 512MB (up to 8GB as more than that would ruin my wallet). This is something I can't really do with Azure, but what I can do is scale out instead of scaling up.

I decided to go with a Microsoft Azure WebSite, running on a Medium Instance VM. This gives me a dedicated, managed, virtual machine with 2 cores and 3.5GB RAM. I've set it to auto-scale based on CPU, I'd like to do it per RAM but I just hope this will do.

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2014/05/AzureCapacity.png" alt="AzureCapacity" width="800" class="alignnone size-full wp-image-2381" />

As you see here, I've told Azure to scale my VM when it hits 80% CPU, I've only set it to allow 2 instances otherwise this will also hit my wallet hard.

There is a huge difference in my setup though, remember I said that I am running a WebSite. I don't manage the virtual machine myself, I don't upgrade the OS and I don't install arbitrary stuff on the machine. This means: I don't host the database on the same machine! This part is important, because the database tend to eat up a bit of RAM so I might not even have the same throttle points as I had on my old virtual machine.

<strong>So where do I store the MySQL database?</strong>? Turns out, that when you tell Azure to create a new WebSite with Wordpress as you see per the screenshot below, it asks you if you want to attach it to a ClearDB MySQL database. This is a MySQL hosting provider, not owned by Microsoft. It does come with a bit of a cost but as I cache all the things, I only need (as of now) the tier 2 version. This means I pay $9/month for my database.

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2014/05/CreateNewWordpress.png" alt="CreateNewWordpress" width="800" class="alignnone size-full wp-image-2391" />

The step after this is where you select your ClearDB plan, they do have a free plan with 20MB of space which isn't really much, but to start off with your blog it's great!

<strong>I've created the Azure WebSite with Wordpress and ClearDB, now what?</strong>

If you like me, have a Wordpress site that you want to move, you can simply FTP into the Azure WebSite with the publish settings that you can download from the dashboard. Simply huh? Just remember to point the wp-config to the new ClearDB database!

<strong>Setting up Wordpress to use Azure Storage</strong>

With the Wordpress site up and running, all you need now is to install W3 Total Cache, which you should already have if you like speed. With this installed, head over to Wordpress -> Performance -> General Settings. Scroll down to the part about CDN.

There are two different kinds of CDN's that you can set up: Pull and Push. The ones using Push requires you to manually tell it to upload files, this is what Azure requires as of now. Pull works with CDNs like MaxCDN. Tell it to use Microsoft Azure Storage as your CDN.

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2014/05/WordpressCDN.png" alt="WordpressCDN" width="800" class="alignnone size-full wp-image-2411" />

After that, you'll have to head over to Wordpress -> Performance -> CDN to make the necessary settings for Windows Azure. You will have to enter the following settings:

<ul>
	<li>Storage name</li>
	<li>Primary key</li>
	<li>Container</li>
</ul>

You get these settings in Azure when you create a new Storage. Once you've entered these you can click on Create container to automatically set it up in Azure.

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2014/05/AttachAzureStorage.png" alt="AttachAzureStorage" width="800" class="alignnone size-full wp-image-2421" />

Once you've done that and applied the settings, you will see a new dialog popping up all the time saying that you need to upload your files. I recommend having this stuck to the top so you don't forget. Because remember, Azure Storage is Push! You can download an official plugin for Azure that puts it all directly in Azure Storage. However, there is a reason for me not doing that. I want to be able to quickly swap hosts if I need to and just point my domains to somewhere else and have it run without much downtime.

Notice how there is also a CNAME field that you can fill out? This is where you enter the CDN address that you can create in Azure. We've got a storage, but not a CDN so far.

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2014/05/CreateCDN.png" alt="CreateCDN" width="800"  class="alignnone size-full wp-image-2431" />

You point this CDN to the Storage you created and it will deliver the files in there to all the CDNs all over the world. Now you'll have to head back to Wordpress and setup that CDN address to make it all work. It does take a while before the CDN is up and all the files are distributed so don't panic!

<strong>Easy enough, right?</strong> It does take some time and energy to setup it all. But once it is up and running, you have the reliability of Azure behind your blog and you can sleep better at nights.

If you want to know that your blog is up and running without having to check it all the time you can use a service like Monitor.US. I've got it pointed to two different places one cached and one non-cached to know if it is up or not. If it detects something incorrect I get an SMS and an E-mail. First time that happened was on New Years Eve (Yay?).

It was an interesting experience migrating to Azure and I think it's been worth it. I've got a much better understanding of the platform and the services that Azure provides which benefits both me and the people I work with. I also strongly believe that with some small tweaks of the CDN and caching this will all perform just as well as my old blog did.

<h4>I'm leaving Wordpress</h4>
You've read this far, now you know what lengths I went through to get Wordpress performant on Azure. The problem is that I wasn't happy enough with that result. Not that there is anything wrong with Azure, I just couldn't bare 500-700ms overhead from Wordpress. For what? Search? E-mail subscribers? No.

There's a bunch of things to say about the move to Sandra.Snow, I think that makes up for it's own post sometime in the future. I'll leave you with a bit of a tease though:

<ul>
	<li>All pages are static HTML pages</li>
	<li>All pages are generated from Markdown files (yes I had to convert the Wordpress content to markdown)</li>
	<li>It's SUPER fast now that Sandra.Snow converts everything for me to static files</li>
	<li>I push a new post to github, Azure fetches it, runs Sandra.Snow, deploys files to Azure Storage and the site to where it should be</li>
</ul>

I'm Very happy that I moved to Sandra.Snow, if I hadn't started moving Wordpress to Azure from the start, I wouldn't have found out how easy the migration was to do. There's still a lot of things to tweak I think, but the easy deployments from github makes it all much more enjoyable to work with.

<strong>Welcome to this blog on Microsoft Azure powered by Sandra.Snow!</strong>

I hope you found this informative and interesting, if you do find any problems with the blog or any files that might be missing please do let me know!