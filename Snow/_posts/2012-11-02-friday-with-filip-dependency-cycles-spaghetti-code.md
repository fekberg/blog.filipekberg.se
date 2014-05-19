---
layout: post
title: Friday with Filip – Dependency cycles & Spaghetti code
date: 2012-11-02 19:31
author: fekberg
comments: true
metadescription: On Fridays, Filip shares interesting thoughts and experience that hopefully will lead to interesting discussions. Enjoy Friday with Filip!
categories: Friday with Filip, Programming
tags: code complexity, code quality, complexity, csharp, dependencies, dependency cycles, friday with filip, ndepend, quality, screencast, spagehtti code
---
<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/FridayWithFili.png" alt="" title="Friday with Filip" style="display: block;   margin-left: auto;   margin-right: auto;" width="342" height="194" class="aligncenter size-full wp-image-1016" />

<h3>Welcome to this week's Friday with Filip!</h3>
Last week I shared the first part in a very interesting session that I had the pleasure  to do with Patrick over at NDepend. Having readable code and manageable solutions is very important but in some cases small changes that might see, trivial to you, might not be as trivial to someone else.<!--excerpt-->

If you had to keep track of all dependencies in your head you are not going to have anything else on your mind; which is a pretty bad way to distribute your brain! Instead of keeping it all in your head, you can use a tool like NDepend to find out a lot of interesting things about your projects. If you've seen the previous posts and videos that I have done on NDepend, you know what kind of power this tool delivers.

The webinars that I have had the pleasure to do with Patrick has been very educating and I hope you like them as well, <strong>I would love to get some feedback!</strong>

So this week we are going to dig deeper with NDepend and spot dependencies, dependency cycles and spaghetti code! As we look on mscorlib, you can see that in some cases bi-directional dependencies are by design, but in other cases it might have been accidental. <em>Sit back and enjoy the two parts below!</em>
<div class="video-container">
<iframe src="http://player.vimeo.com/video/52020901?badge=0" width="500" height="281" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe> <p><a href="http://vimeo.com/52020901">How to Demystify Spaghetti Code with NDepend, Part 1</a> from <a href="http://vimeo.com/codequality">CodeQuality</a> on <a href="http://vimeo.com">Vimeo</a>.</p>
</div>

<h3>Part 2</h3>
<div class="video-container">
<iframe src="http://player.vimeo.com/video/52423676?badge=0" width="500" height="281" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe> <p><a href="http://vimeo.com/52423676">How to Demystify Spaghetti Code with NDepend, Part 2</a> from <a href="http://vimeo.com/codequality">CodeQuality</a> on <a href="http://vimeo.com">Vimeo</a>.</p></div>

Keeping our code base clean and understandable is important and as you might have seen now, there are tools that can help us along the way. 

What are your tips on the subject?