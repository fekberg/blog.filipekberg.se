---
layout: post
title: Let's write better software
date: 2012-09-27 13:50
author: fekberg
comments: true
metadescription: Let's write better software together!
categories: Architecture, Programming
tags: architecture, productivity, Programming, quality, tdd, testing, unit testing
---
<h3>Bugs are an expectation instead of an exception</h3>
Technology have been a big part of my life ever since I was a kid. If it wasn't a console it was a computer and later came the mobile phone. All these <em>things</em> running on electricity have always interested me. My first mobile phone was a <strong>Nokia 5110</strong>, which is the only phone that actually <strong>never broke</strong>.<img class="alignnone size-full wp-image-1295" style="float: right; padding-left: 20px;" title="Nokia 5110" src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/nokia5110.gif" alt="" height="229" />There's a joke around the net that the old Nokia phones never broke and that's very true; however they didn't do much more than calls, sms and snake.<br/><br/>When the phones with color displays appeared the mobile vendors noticed that people wanted to switch phones often; <em>as soon as a new feature was released everyone had to have it.</em> The vendors immediately started pushing out more and more phones, a lot more phones than were actually needed on the market. With this overwhelming amount of mobile phones and rapid development came a lot of more bugs.<!--excerpt-->

Since I swapped from my first Nokia phone, I haven't had a single phone for more than 1 - 2 years. This isn't because I really needed to get a new phone but because after a long period of time it started feeling slow, less responsive and lacked all the cool features the new phones had. If the consumers want to buy new phones every second year, why should the vendors make phones that work for more than 2 years?

<strong>This has gotten too far</strong>, I'm not talking about the mobile phones but technology in general; the consumers are expected to change their behavior and their hardware/software often (every 1-2 years). What's scary about this is that I've caught myself saying:
<blockquote>Oh, you've got the 2 year old version/model. That program/accessory doesn't work on that version/model. You need to upgrade.</blockquote>
As consumers have somewhat adapted to this and expect rapid updates for software's. The vendors no longer need to spend as much time on finding bugs as they did before. A very good example of this is the launch of Diablo 3 where Blizzard needed to push Diablo 3 to the customers without it being completely finished. If you played Diablo 3 when it first arrived and play it today, it's almost as you play 2 completely different games; the story the same, but other things have changed.

It is not rare that vendors have open-betas of their in-development software or hardware. In Office 2013, Microsoft added an "instant feedback button" and this is Great! However, I've seen a lot of software's where they "forgot" to remove the "report a bug"-button in the RTM (release to manufacturing). Of course it should be easy to report a bug once you find it, but nowadays it's pretty much like the vendors expect the users to find bugs and that they need rapid ways to report these.

We no longer see bugs as exceptions, but it's rather expected and when we do find a bug we immediately think <strong><em>"this will be fixed in the next version sometime this week"</em></strong>.

<h3>Stop delivering less than awesome software</h3>
We've seen that consumers are not scared of changing their behavior, as that's what we do; we adapt. <strong>Vendors need to start delivering better software and hardware!</strong>

As a software engineer, I know what I can do to ensure that each piece in the software that I create is high quality. If you don't feel that you've done an awesome job, something is wrong; we need to be proud of the software that we deliver!

<em>It's quite often that bugs derive from "quick fixes", but a quick fix can turn into a quickly evolving bug.</em>

Here's what I suggest we do to ensure quality of things we deliver:
<ul>
	<li><span style="color: red;">Test</span>, <span style="color: red;">test</span> and <span style="color: green;font-weight: bold;">TEST!</span></li>
	<li>Refactor your code according to the programming guidelines of the language your using</li>
	<li>Write documentation (even if short!) about your methods, flow and functionality</li>
	<li>Write test documents which includes both manual and automated tests</li>
	<li>Create automated UI tests</li>
	<li>Run complexity analysis tools such as NDepend on the code base to find too complex areas</li>
	<li>Don't deliver if you're not happy with the outcome</li>
	<li>Write readable code</li>
	<li>Don't try to optimize better than your compile can by writing complex and un-readable code</li>
	<li><strong>Drink a cup of coffee before you deploy</strong></li>
</ul>

<strong>Let's make better software, together!</strong>

<strong><em>What's your suggestion on ensuring that we deliver high quality?</em></strong>
