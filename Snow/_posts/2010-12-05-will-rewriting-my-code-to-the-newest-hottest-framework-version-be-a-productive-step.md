---
layout: post
title: Will rewriting my code to the newest hottest framework version be a productive step?
date: 2010-12-05 22:19
author: fekberg
comments: true
metadescription: Will rewriting my code to the newest hottest framework version be a productive step?
categories: Architecture, Programming
tags: productivity, Programming, rewrite, rewrite code, software architecture
---
This is by far the most asked question I've seen around the net besides the obvious questions like "How do you do X and why doesn't Y work?". There is a simple answer: If the code works and is patchable, we don't need to rewrite.

I've heard that line countless of times from both customers and PM:s when arguing about rewriting old systems and to be fair, it's not an invalid statement. Why should be re-build something when it is properly working? In my opinion there are a couple of reasons why you would need to consider rewriting code that is working.<!--excerpt-->
<ol>
	<li>The old framework has security issues that will just take to much time manage and there will be to many "fast fixes" in the code so that in the near future, it will be hard to handle.</li>
	<li>It's hard to implement new features and integrate with new systems that the customer requests.</li>
	<li>There are too many new developers on the team that do not have knowledge regarding the older framework and it will therefore be beneficial to rewrite.</li>
</ol>
One might argue that some of the above will count as "the software does not work" since it's not manageable anymore. And to be honst, to old code is hard to manage and costs more than it needs to. For instance, Microsoft recently said that they will stop supporting VB6, hello? It's 2010 and we still develop VB6 applications and manage old VB6 applications.

I am not trying to say that the VB6 code that was written is bad or that it will be cheaper right Now to rewrite but in the end I think it could somehow benefit both the developers and the customers. Visual Basic first appeared 1991 and version 6 which has been the latest Visual Basic version outside the .NET family was released as a stable release 1998. That's 12 years ago, how much really happens in 12 years?

12 years ago I got my first computer which had a Pentium 2 CPU with 350Mhz and less than 128MB RAM doesn't that say just a little bit how far we've come since 12 years ago? Today you can get a 6 core CPU with over 4Ghz and a lot of gigabytes of RAM.

Put that in the context of programming, it's been 12 years of security fixes, system updates, patches on developed systems and the biggest change of all: A bunch of new Operating System updates with a couple of major releases. Well I am not here to bash down on VB6 but to reflect a bit on if it is really worth upgrading to a newer framework.

What if you have a system written in .NET 2.0 with C# using ASP.NET ( WebForms ) will it be worth the effort and money to upgrade/convert this system into .NET 4.0 with MVC 3? I'd sayd: It depends!

First of all you need to think about how it will benefit the customer. If you have a comittment to the customer and handle all upgrades and new development, maybe you will get a lot more features for a much less cost if you use a much newer framework, because in a new framework you get a lot of help solving trivial problems.

So in a longer term you might actually help the customer reduce the administration cost, but the up-front cost might be a bit higher to just get you and your team over the cliff to a finished upgrade.

The answer to this is quite subjective and I still think that it depends a lot on the project and that you need to think about how it will benefit the customer or the development team. A while back I answered a question on StackOverflow about the current topic, the poster wanted to know if it was a productive step to rewrite from Language A to Language B and my answer was:

<blockquote>You need to take some parts into mind here,
<ol>
	<li>What will you gain from re-writing</li>
	<li>Is it an economically wise decision</li>
	<li>Will the code be easier to handle for new programmers</li>
	<li>Performance-wise, will this be a good option?</li>
</ol>
These four points is something that is important, will the work be more efficient after you re-write the code? Probably. But will it be worth the cost of re-development?<br/>One important step to follow, if you decide to re-write, make 3 documents, first Analyze the project, what needs to be done? How should everything work? Then put up a document with Requirements, what specificly do we need and how should this be done? Last but not least, the design document, where you put all your final class diagrams, the system operations and how the design and flow of the page should work.<br/>This will help a new developer, and old ones, to actually think about "do we really need to re-write?".</blockquote>
[ <a href="http://stackoverflow.com/questions/340318/is-rewriting-a-php-app-into-python-a-productive-step/340338#340338">read the entire thread here</a> ]

What I did there was what I try to do here, I answer with a follow up question:
<ul>
	<li>What is the current situation in your project?</li>
	<li>Do you Really need the features in the new framework/language?</li>
	<li>Is the language the system is built in out-dated?</li>
	<li>Will it be easier in the future to integrate to new systems if you upgrade?</li>
</ul>
If you can check at least two of the above listed points, you really should consider upgrading your system.
