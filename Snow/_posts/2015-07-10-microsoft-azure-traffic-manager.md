---
layout: post
title: Microsoft Azure Traffic Manager
date: 2015-07-10 00:00
author: fekberg
comments: true
metadescription: Azure, Traffic Manager
categories: Azure
tags: Azure, Microsoft Azure, Traffic Manager
---
Yesterday I was notified on Twitter that the RSS feed for my blog included draft posts. Which is not really ideal since it will contain articles that aren't really ready. I have previously written about how I moved to [Sandra.Snow from Wordpress](http://www.filipekberg.se/2014/05/21/goodbye-wordpress-hello-snow/) and how much I really enjoy this transition. One of the biggest benefits is that it is open source, this means fixing this bug was rather easy and quick.

Albeit the fix might have been easy and quick, I did run in to some issues with my automatic deployment. Every time I check something in to the git repository, Azure will notice this and start deploying my website. Little did I know that there was another bug, unrelated to the RSS feed getting my drafts, in my deployment script. Luckily for me, I got Microsoft Azure Traffic Manager running on-top of my blog, which means that I load balance between different zones. 

The load balancer is configured to run in performance mode so that visitors in US are transferred to the US West location. Meanwhile, EU visitors are transitioned to the EU location and Asia to the Southeast Asia location.

To avoid down-time, I had two options when fiddling around with the fix for the bug.

1. **Clone the Website** in one of the locations and setup a staging like environment
2. **Disable one of the locations** in the load balancer and use that as a staging environment

Obviously the second option would be cheaper, but it does come at a price: users from that location will experience longer load times.<!--excerpt-->

<img src="http://cdn.filipekberg.se/fekberg-blog/microsoft-azure-traffic-manager/fekberg-websites.png"/>

As mentioned above, I have the site running in three different locations: West US, North Europe and Southeast Asia. When doing the testing, I could simply go into the sites that I did not want to affect with my testing, and disable the automatic deployments for now.

The beauty is that I can hit the websites using a handful of different URLs, externally you will visit this blog on <a href="http://www.filipekberg.se">www.filipekberg.se</a>, but it's also setup to listen at:

* filipekberg.se
* blog.filipekberg.se (legacy)
* fekberg.trafficmanager.net (azure traffic manager)

And the region specific endpoints:

* fekberg.azurewebsites.net (West US)
* fekberg-sea.azurewebsites.net (Southeast Asia)
* fekberg-eu.azurewebsites.net (Europe)

The Microsoft Azure Traffic Manager itself is super easy to setup, simply create a new one and choose the websites you want included. One gotcha though, you cannot setup a traffic manager with the Free, Shared or Basic plans. Your website needs to run on the Standard plan.

<img src="http://cdn.filipekberg.se/fekberg-blog/microsoft-azure-traffic-manager/fekberg-traffic-manager.png"/>

I decided to turn off the West US location, I probably could have used Southeast Asia instead since that is most likely closer to where I am. Either way, enabling and disabling the endpoints is as easy as just clicking `Disable` or `Enable` for the highlighted endpoint.

<img src="http://cdn.filipekberg.se/fekberg-blog/microsoft-azure-traffic-manager/fekberg-disabled-endpoint.png"/>

This meant that readers hitting <a href="http://www.filipekberg.se">www.filipekberg.se</a> would get transferred to the Europe or Southeast Asia locations, meanwhile I could work on the West US site and make sure everything worked accordingly. This workflow gave readers 0 downtime and let me run tests on one of the real sites. Sometimes it may be hard completely replicating production and it may take longer doing so rather than just "cheating" like this.

Doing it like this certainly saved me time, and it was a bit more fun than setting up a new environment! [Of course, I also got the chance to submit a PR to Sandra.Snow!](https://github.com/Sandra/Sandra.Snow/pull/139)