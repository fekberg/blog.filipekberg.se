---
layout: post
title: What language features do you miss in C#?
date: 2013-03-01 14:07
author: fekberg
comments: true
metadescription: Imagine you could be a part of the C# language design team, what features would you like to add?
categories: .NET, C#, Programming
tags: csharp, Programming
---
<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/03/35563491-300x225.jpg" alt="35563491" width="300" height="225" class="alignright size-medium wp-image-1808" style="float: right; padding: 15px;" />Every now and then I hear people shout <em>"I really wish C# would have X and Y, it would make my life so much easier"</em>. This makes me think about what features I'd like to see supported in the language. There are multiple factors to take into consideration when thinking about what should be a language feature and not.<br/><br/>If C# would be completely open source and driven by the community we would probably see a lot of pull-requests for new language features. But I'd imagine that many of these features were implemented by someone that felt like the problem solved some in their opinion generic case. This might not actually be the case though. When adding a new language feature, to any language, you need to take into consideration that a big part of the community should benefit from it.<!--excerpt-->

A good example is how language features for asynchronous programming were added in .NET 4.5. But asynchronous programming was possible before this. "All" it really does is adding a nice state-machine and does all the heavy lifting for us. This is something that developers doing asynchronous programming would have to implement over and over again thus making it a perfect candidate to become a language feature.

Mindscape has an article about what <a href="http://www.mindscapehq.com/blog/index.php/2012/03/27/5-12-f-features-every-c-programmer-should-lust-after/">F# features every C# developer should lust after</a> which brings up some interesting language features such as:

<ul>
	<li>Pattern matching</li>
	<li>Immutability</li>
	<li>Object expressions</li>
</ul>

<strong>What language features do you miss in C# and why?</strong>  Keep in mind that a language feature should target a broad audience! Maybe you're happy with what is in the language right now?

<a href="http://blog.filipekberg.se/2013/02/26/c-smorgasbord-ebook-limited-time-offer-now-only-e4-99/" target="_blank">C# Smorgasbord ebook limited-time offer now only €4.99!</a>
