---
layout: post
title: Friday with Filip – Joining new projects
date: 2012-10-05 11:05
author: fekberg
comments: true
metadescription: On Fridays, Filip shares interesting thoughts and experience that hopefully will lead to interesting discussions. Enjoy Friday with Filip!
categories: .NET, Friday with Filip, Programming
tags: .NET, csharp, dotnet, friday with filip, ndepend, Programming, testing, unit testing
---
<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/FridayWithFili.png" alt="" title="Friday with Filip" style="display: block;   margin-left: auto;   margin-right: auto;" width="342" height="194" class="aligncenter size-full wp-image-1016" />

<h3>Welcome to this week's Friday with Filip!</h3>
The last three Fridays we've looked at how to <a href="http://filipekberg.se/2012/09/28/friday-with-filip-being-productive/">become more productive</a>, how to <a href="http://filipekberg.se/2012/09/21/friday-with-filip-do-you-care-about-web-security/">increase security in your web applications</a> and how to <a href="http://filipekberg.se/2012/09/14/friday-with-filip-do-you-use-a-decent-testing-strategy/">adapt to a real testing strategy</a>. This week I want to talk about how I get deep into the new projects that I join, fast. The projects that I'm referring to are those that have been developed on before. The customer never really wants to pay for you to spend too much time learning the code base and the actual project, so you'll have to use tools that will help you do so fast.<!--excerpt-->

<h3>What I do when I first get the project on my table</h3>
The first thing that I obviously try to do, is get the project running or get all the tests to give me green lights. This assumes of course that there are tests written for the system! Just imagine that you need to join a project that has been developed for hundreds or thousands of hours and there's no tests and no documentation; this is much more common than you might think. <a href="http://c2.com/cgi/wiki?CodeForTheMaintainer">That's why the following quote is what everyone should be feeling when writing code.</a>

<blockquote>Always code as if the person who ends up maintaining your code is a violent psychopath who knows where you live.</blockquote>

As soon as I've gotten the project running, or the tests are all OK. I can move on to understanding the code base. Normally when you get a project on your hands, there's something that is needed to be done, let's say that you need to implement a feature.

The first thing that I try to do, is get an overview of the complexity and what is depending on what. To do this, I'm using <a href="http://filipekberg.se/2012/05/31/ndepend-v4-has-finally-arrived/">NDepend</a> (which I've written about in <a href="http://amazon.com/C-Smorgasbord-Filip-Ekberg/dp/1468152106/">C# Smorgasbord</a>). NDepend will give you great reports and help you find complexity in many forms. Here's an overview that shows what is connected to what and the size of the boxes indicate the complexity:

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/05/NDepend1.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/05/NDepend1-1024x723.png" alt="" title="NDepend analyze of ASP.NET Web Stack" width="761" class="aligncenter size-large wp-image-838" /></a>

When I find something that I think is too complex, I try to identify if there's a test for that by analyzing the code coverage. If the code coverage is bad, I try to start writing some tests, this will help me get custom to the project. I don't worry too much if the tests fail; this means that I need to debug the tests which will force me to step into the complex parts of the system and analyze them further.

To get a great overview of my testing, I use the built in (not in VS2010 Express versions, but in VS2012!) MS Test tooling.

<h3>Break & Fix the code</h3>
When I've come as far as starting to write tests for complex parts that are already in the system; I try to refactor small parts, break stuff to understand the business logic. This all helps me get a great idea of what the particular parts do.

In order to help me get an idea of what is covered by tests and not when browsing around the code, I use <a href="http://www.ncrunch.net/">NCrunch</a>. NCrunch is great, I configure it to add black dots everywhere to indicate statements that are not covered by tests. Then when they are tested, the dots go green and this is updated in real time!

At this time I can normally start looking at the actual task that I need to perform. Depending on how large the project is and how complex it is, the above process might be short or long. But at least for me, it's a great way to get my head in a new project.

<h3>tl;dr</h3>
So you've got a new project that you need to implement features in, here's what I recommend:
<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/10/fixit.jpg" alt="" title="fixit" width="200" style="float: right;"  class="alignnone size-full wp-image-1354" />
<ul>
	<li>Analyze the complexity of the code with tools such as NDepend</li>
	<li>Write tests for un-covered code to understand the flow of the application</li>
	<li>Use NCrunch to annoy yourself with black dots so that you'll write more tests and get a better knowledge of the code base</li>
	<li>Break the code and fix it again -- then refactor!</li>
</ul>

<strong>What are you doing to spend less time understanding a system and more time actually fixing the problems?</strong>
