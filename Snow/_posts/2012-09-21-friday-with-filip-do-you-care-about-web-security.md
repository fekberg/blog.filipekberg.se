---
layout: post
title: Do you care about web security?
date: 2012-09-21 07:00
author: fekberg
comments: true
metadescription: On Fridays, Filip shares interesting thoughts and experience that hopefully will lead to interesting discussions. Enjoy Friday with Filip!
categories: Friday with Filip, Programming
tags: csharp, dotnet, friday with filip, Programming
---
<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/FridayWithFili.png" alt="" title="Friday with Filip" style="float: left;" width="342" height="194" class="aligncenter size-full wp-image-1016" />I was once put in a project where a lot of the architecture and development was already in place. Immediately when I started working with the project I gave the other team members my thoughts on improvements, some of them regarding testing and some of the regarding security. Last week we focused on the testing, so this week, let us talk a little bit about security.<!--excerpt-->

One of the biggest concerns I had about this project was that usernames and passwords were stored in clear text; <strong>this gave me the shivers</strong>. I talked to my team members and everyone agreed that this was Very bad. I have no idea why someone would design a login system with username and password where the information is stored in clear text. Or even in a way where passwords where stored in anything else than a hash.

But before I could change this, I had to get a go from the customer to put a couple of hours on changing everything in the system. When doing so, something scary happened. I got this response from our customer:

<blockquote>Don't put any time on security, we're going to get hacked anyways and that means free media.</blockquote>

When you hear something like that, it's obvious the person does not know a lot about IT security or marketing in general. Assuming that the system would get a lot of media slots because of a major leak, the cost to get your reputation up again would be much greater than what it would have been if you just invested in security to start with.

<strong>Have you ever experienced something like this as well?</strong>

A lot of systems get hacked quite often, but when they do get hacked, it's pretty darn important that customer data is intact and not easily accessible. 

<strong>Design your system assuming that you will be attacked by hackers</strong>. I think this is quite important, don't assume that hackers won't care about you. I would even advise paying a good hacker to test your security to find vulnerabilities.

<h3>Revise your web security</h3>
Always take time to think about security, do it rather sooner than later. When you do think about security, it can be quite nice to fall back on some best practices or rather a check-list of common things that developers do wrong.

To help us all out with this, there's a project called "<strong><a href="https://www.owasp.org/index.php/Main_Page">The Open Web Application Security Project</a></strong>". This project has a <a href="https://www.owasp.org/index.php/Category:OWASP_Top_Ten_Project">Top 10 list</a> of most common security problems on web sites. Here's the list:

<ol>
	<li><a href="https://www.owasp.org/index.php/Top_10_2010-A1" target="about:blank">Injection</a></li>
	<li><a href="https://www.owasp.org/index.php/Top_10_2010-A2" target="about:blank">Cross-Site Scripting (XSS)</a></li>
	<li><a href="https://www.owasp.org/index.php/Top_10_2010-A3" target="about:blank">Broken Authentication and Session Management</a></li>
	<li><a href="https://www.owasp.org/index.php/Top_10_2010-A4" target="about:blank">Insecure Direct Object References</a></li>
	<li><a href="https://www.owasp.org/index.php/Top_10_2010-A5" target="about:blank">Cross-Site Request Forgery (CSRF)</a></li>
	<li><a href="https://www.owasp.org/index.php/Top_10_2010-A6" target="about:blank">Security Misconfiguration</a></li>
	<li><a href="https://www.owasp.org/index.php/Top_10_2010-A7" target="about:blank">Insecure Cryptographic Storage</a></li>
	<li><a href="https://www.owasp.org/index.php/Top_10_2010-A8" target="about:blank">Failure to Restrict URL Access</a></li>
	<li><a href="https://www.owasp.org/index.php/Top_10_2010-A9" target="about:blank">Insufficient Transport Layer Protection</a></li>
	<li><a href="https://www.owasp.org/index.php/Top_10_2010-A10" target="about:blank">Unvalidated Redirects and Forwards</a></li>
</ol>

Follow the OWASP Top 10 list, ensure that your application is tested against each item in the list above. This is at least one step in the right direction.

Security is often a sensitive subject, but I find that most most organizations that don't want to dicuss security don't think that they have a secure enough system; transparency is key.

<strong>Is security a key when you develop applications and is your company transparent when it comes to security?</strong>

<a href="https://www.owasp.org" target="about:blank"><img style="display: block;   margin-left: auto;   margin-right: auto;" src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/owasp.jpg" alt="" title="owasp" width="240" height="240" class="aligncenter size-full wp-image-1062" /></a>

OWASP Top 10 is a good place to start, but it's just the tip of the iceberg. If you have any stories to share regarding security or any tips & trix along the way, feel free to leave a comment!
