---
layout: post
title: Friday with Filip – Dealing with Code Complexity
date: 2012-10-12 09:54
author: fekberg
comments: true
metadescription: On Fridays, Filip shares interesting thoughts and experience that hopefully will lead to interesting discussions. Enjoy Friday with Filip!
categories: .NET, C#, Friday with Filip, Programming
tags: .NET, code complexity, complexity, csharp, cyclomatic complexity, dotnet, friday with filip, ndepend, nunit, visual studio 2012, vs2012
---
<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/FridayWithFili.png" alt="" title="Friday with Filip" style="display: block;   margin-left: auto;   margin-right: auto;" width="342" height="194" class="aligncenter size-full wp-image-1016" />

<h3>Welcome to this week's Friday with Filip!</h3>
Yet another interesting week has passed with lots of things to discuss. Before we dig into this week's subject, I just want to take a brief moment to share something interesting that I found (it was recommended by someone I know from IRC). There's a hosting company called EDIS based in Austria that is now providing a very neat service; <strong>Raspberry Pi Colocation!</strong><!--excerpt--> As soon as I saw this I shared it with <a href="http://news.ycombinator.com/item?id=4636374">HackerNews</a> and got a response from EDIS on twitter:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/10/edis.png" style="display: block;   margin-left: auto;   margin-right: auto;" alt="" title="EDIS Tweet" class="alignnone size-full wp-image-1394" />

<em>It's worth just thinking about this for a second, let's say that 1000 RPi's could host some websites, instead of 1000 1U rack servers; imagine the power that would be saved (and the space).</em>

<strong>Now to this week's subject!</strong>

Last week we discussed how we could join new projects and do that efficiently and I got some great tips & tricks from a lot of you (in different channels). This week we are going to follow in those footsteps and see how we can actually find complex code in our applications. While finding complex code is important for all different programming environments; we're going to look at this by using C#, Visual Studio 2012 and NDepend.

<h3>It's a little bit different this week..</h3>
I recently recorded the first episode of a webinar series with Patrick Smacchia, the founder of NDepend and who better to talk about Code Quality and Code Complexity than with him? So this week, I'm happy to announce that you can watch the first video in this webinar series!

It's a 30 minute webinar where Patrick and I talk about Code Quality, Code Complexity (CyclomaticComplexity) and other things around this subject.

<div class="video-container">
<iframe src="http://player.vimeo.com/video/51204579?title=1&amp;byline=1&amp;portrait=1" width="500" height="281" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe> <p><a href="http://vimeo.com/51204579">How to Inspect Code Quality & Code Complexity with NDepend</a> from <a href="http://vimeo.com/codequality">CodeQuality</a> on <a href="http://vimeo.com">Vimeo</a>.</p>
</div>

<strong>After watching the video, please tell me and Patrick what you thought about the video and tell me what your tips are to find complexity in your code or projects!</strong>

P.S. <a href="http://filipekberg.se/2012/11/20/c-smorgasbord-sale/">Today is the last day to get a 35%
discount on C# Smorgasbord! </a>
