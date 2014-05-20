---
layout: post
title: NDepend v4 has finally arrived
date: 2012-05-31 10:10
author: fekberg
comments: true
metadescription: NDepend v4 has finally arrived
categories: .NET, Architecture, C#, Programming
tags: code analysis, code complexity, csharp, ndepend
---
It is truly a great pleasure to finally be able to spread the word about <a href="http://www.ndepend.com">NDepend</a> version 4. For those of you that do not know what NDepend is, you have truly missed out on something great. But not to worry, you can catch up in an instant!<!--excerpt-->

<a href="http://www.ndepend.com">NDepend</a> is a complexity analysis tool that integrates into Visual Studio 2011, 2010 and 2008. It also comes with a standalone component for analyzing your projects.

I have been using <a href="http://www.ndepend.com">NDepend</a> v4 for a while now and I liked it so much that it gets a place <a href="http://blog.filipekberg.se/2012/03/27/video-trailer-for-a-c-smorgasbord/" title="A C# Smorgasbord">in my upcoming book</a>.

What makes <a href="http://www.ndepend.com">NDepend</a> so powerful is that you can customize the analysis to adapt to your own set of restrictions and you do this with what is called <a href="http://www.ndepend.com/Features.aspx#CQL">Code Query LINQ(CQLinq)</a>. This is one of the biggest changes in version 4 and it really takes the tool to another level, prior to version 4 you used another way to customize your queries.

Here is an example<a href="http://www.ndepend.com/Features.aspx">(example taken from  NDepend Features page)</a> of a CQLinq statement that looks for methods that do not have enough comments:

	from m in Application.Methods 
	where m.CyclomaticComplexity >  15 && m.PercentageComment <  10
	select new { m, m.CyclomaticComplexity, m.PercentageComment }

I made an analyze of the <a href="http://aspnetwebstack.codeplex.com/">ASP.NET Web Stack project</a> and this is what the report look like in the stand alone program called Visual NDepend:

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/05/NDepend1.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/05/NDepend1-1024x723.png" alt="" title="NDepend analyse of ASP.NET Web Stack" width="761" class="aligncenter size-large wp-image-838" /></a>

In the image above it shows the dependency graph you have a lot of other views that you can use to find complexity in your solution. You can also see a list of the different CQLinq results such as:

<ul>
	<li>Types that are too big</li>
	<li>Methods that are too complex</li>
	<li>Methods that takes too many parameters</li>
</ul>

When composing this analysis you also get an HTML Report that looks like this:

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/05/NDepend2.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/05/NDepend2-1024x736.png" alt="" title="NDepend HTML Report" width="761" class="aligncenter size-large wp-image-839" /></a>

It essentially contains the same information as you would get from Visual NDepend, but it is very handy to be able to pass this report on to fellow co-workers.

Another Very powerful thing is that you can integrate NDepend with for instance <a href="http://www.cruisecontrolnet.org/">CruiseControl.NET</a>, which is a build server. This means that every time the build server builds your project, it can also analyze the solution and compare how your complexity increases or decreases.

<a href="http://www.ndepend.com/NDependDownload.aspx">You can get a 14 day trial</a>, I really suggest you do, you do not want to miss out on this! There will also be much more content regarding NDepend in the book I am currently writing, stay tuned for more information about that.