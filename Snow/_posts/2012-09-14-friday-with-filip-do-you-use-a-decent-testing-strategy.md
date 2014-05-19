---
layout: post
title: Friday with Filip - Do you use a decent testing strategy?
date: 2012-09-14 15:02
author: fekberg
comments: true
metadescription: On Fridays, Filip shares interesting thoughts and experience that hopefully will lead to interesting discussions. Enjoy Friday with Filip!
categories: Friday with Filip, Programming
tags: csharp, dotnet, friday with filip, Programming
---
<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/FridayWithFili.png" style="display: block;   margin-left: auto;   margin-right: auto;" alt="" title="Friday with Filip" width="342" height="194" class="aligncenter size-full wp-image-1016" />

<h3>Welcome to Friday with Filip!</h3>
Wow, am I excited or what! I was out on a "developer lunch" in Gothenburg with some very nice people and we started talking about blogging, teaching and other fun stuff like that. We started discussing how I usually have what we call "CodeStar" at work; each Friday I teach my co-workers about something exciting for an hour or two. I'm not Always the guy doing the presentations, but mostly.<!--excerpt-->

Anyways, we college who was also with me on this lunch referred to it as "Friday with Filip" and this started to grow on me. So with some great input from my college , <a href="http://irisclasson.com">Iris</a> and <a href="http://www.twitter.com/Anton_sjoberg">Anton</a>, I decided to create a blog series called <strong>Friday with Filip</strong>!

The idea is pretty simple, I want to give my point of view on a subject and then hopefully teach you something and start a discussion around it. Feel free to leave a comment or drop me an e-mail on <em>mail [at] filipekberg [dot] se</em>! All feedback is welcome!

If you like the idea, please share it with your friends by clicking the share button below. 

<h3>Do you use a decent testing strategy?</h3>
I'm currently working on some very large projects with my company and it's all very interesting. What I've found most exciting about these larger projects is that the testing strategies are much more important when it comes to these larger systems. Personally I think that testing is <strong>Always</strong> important and should be prioritized.

If we look at it all from the customer perspective, how can they be ensured that things work accordingly if there is no documentation to back it up?

I don't know about you, but I've heard the following excuse to why test reports are sometimes neglected:

<blockquote>We don't need to do any advance testing, this system isn't going to be that big.</blockquote>

<strong>Stop all these excuses!</strong> In my book I talk about how we can use unit testing to ensure that certain parts in a system work correctly, but this is just a fraction of everything that needs to be tested. Many things that we do, we test manually. If we wrote a couple of lines of text each time we did a test, it would surely take a couple of more minutes on each requirement, but it's going to be worth it in the end!

You don't really need to put so much effort into making a nice test document. Open up word and just add the information that you think would be valuable if you were looking on the system from the outside.

When you deliver your product, don't you want to feel like you have a large pile of documents backing up your quality?

Here's what I would want to have in a perfect programming world:

<ul>
	<li>Write unit tests whenever it is suitable</li>
	<li>Automate as many manual UI tests as possible</li>
	<li>Document the tests and <strong>not leaving out anything even if it fails!</strong></li>
</ul>

I recently set up a fairly simple test report document that just includes this:

<ul>
	<li>Test name</li>
	<li>A reference to the Use case / Requirement (of available)</li>
	<li>Description of the test</li>
	<li>Expected result</li>
	<li>Actual result</li>
	<li>Actions needed to mark the test as complete</li>
</ul>

When you assemble all these in a large document and give to your customer with a sprint delivery, you can surely feel better about yourself! <a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/TestCaseReportTemplate.docx">Here </a>is a word document that I put together for this, you can use it as you please. Let me know if you like it.

<strong>What is your testing strategy, if you have any? If you don't, how would you like it to be?</strong>


<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/quality.jpg" alt="" title="quality" width="450" style="display: block;   margin-left: auto;   margin-right: auto;" height="397" style="margin: 0 auto;" class="aligncenter size-full wp-image-1024" />


Don't forget to leave a comment or drop me an e-mail, thanks for reading the first <strong>Friday with Filip</strong>!
