---
layout: post
title: 10 questions about Surface
date: 2012-10-17 10:10
author: fekberg
comments: true
metadescription: Microsoft is releasing the Surface on October 26th, here are 10 things you want to know about Surface!
categories: Windows 8, WinRT

---
The Microsoft Surface is due to be released October 26, 2012 and this is less than 10 days from now. There's been a lot of hype around this particular tablet and I'm very happy that the release date is in just 1½ weeks!<!--excerpt-->

<h3>Some background</h3>
If you've somehow missed what the Surface is or what the Surface looks like, below is a very nice picture of it. Basically it's a powerful and lightweight tablet that runs Windows 8.
<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/10/surface.jpg" style="display: block;   margin-left: auto;   margin-right: auto;" alt="" title="Surface" width="680"  class="alignnone size-full wp-image-1417" />

Up until today, at least I have always felt that I at least needed 3 devices. One touch optimized tablet (iPad), One laptop to bring in to meetings that I can also code on and last but not least a very powerful workstation that I can work on. With the Microsoft Surface, we're closing up with the all-in-one device -- simply bring the Surface with you to meetings, watch movies with it in the couch or work on it.

How come information about such hardware ends up on a programming blog? Because the programming model is very interesting! If you're an iOS developer or an Android developer, you're most likely familiar with the whole "store" life-cycle; which is great. This will (hopefully) lead to much more high quality applications and less bogus software.

<h3>Surface comes in two (majorly) different models</h3>
The first Surface that is released October 26 will run Windows RT on an ARM architecture. The RT version of Windows 8 is designed for limited use such as:

<ul>
	<li>Watching movies, surfing the web, chatting and all that other tabletty stuff</li>
	<li>Minor work in Office; Word, Excel, Powerpoint, etc.</li>
    <li>Only run applications from Windows Store</li>
</ul>

There's of course a little more to it, but the last point is the most interesting one. You'll only be able to run applications on the device that comes from Windows Store! Hence that you will not be able to put an application on an USB drive (yes Surface has a fully functional USB 2 port) and run it.

This might not be new information to you, but it's still pretty interesting. That's why there's another Surface version released in January, called Surface Pro. This version runs on an Intel Core i5 and used the full version of Windows 8. This lets you install any applications that you want and use it as any other computer that you are used to. <em>Plus it's still a tablet!</em>

Below is an overview of the Windows RT Architecture; The RT API is a little bit different (limited).

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/10/2626.Win8-WinRT-Architecture_610x431.png" alt="" title="Windows RT Architecture" width="610" height="431" class="alignnone size-full wp-image-1420" />

<strong>Now with a little bit of background, let's take a look at 10 questions and answers about the Surface!</strong>

<a href="http://www.reddit.com/r/IAmA/comments/11kyja/iam_panos_panay_gm_of_microsoft_surface_amaa_ask/?sort=hot">All the following information is based on information given by the SurfaceTeam on reddit.</a>

<h3>1. Why doesn't surface come with 3G/4G</h3>

<blockquote>For 3G/4G we looked at several elements when deciding on what features to include. We knew that the primary use was going to be in the home, we looked at tablet sales data 2/3 WiFi, 1/3 Mobile Broadband. Of the 1/3 sold, 1/2 were activated. Phone hotspot / tethering use was also a consideration.</blockquote>

<h3>2. Will Surface be available in any other countries than listed at the moment on the release date?</h3>

<strong>Unfortunately, no.</strong>

<blockquote>Of the primary launch Markets we are launching in, we have keyboards specific to those languages
We are not announcing any new markets beyond what we said today. However, we will for sure be expanding to more markets in the future.</blockquote>

<h3>3. Why is there no USB3 port, only USB2?</h3>
Currently there's no ARM SoCs that have an USB 3 controller and Surface is based on ARM, which means no USB 3.

<blockquote>USB 2.0 based on capability of the ARM SoCs during our development timeframe.</blockquote>

<h3>4. How much will it cost?</h4>
There are a couple of different options available (USD prices only).
<ul>
	<li>Surface with 64GB Storage and TouchCover - <strong>699 USD</strong></li>
	<li>Surface with 32GB Storage and TouchCover - <strong>599 USD</strong></li>
	<li>Surface with 32GB Storage without TouchCover - <strong>499 USD</strong></li>
</ul>

<h3>5. Is there any NFC or GPS on Surface?</h3>

<blockquote>There isn't a NFC feature in Surface RT; We use Wi-Fi based location services, the device doesn't have a physical GPS sensor.</blockquote>

<h3>6. Why is the kickstand angled as it is?</h3>

<blockquote>We wanted the screen to be normal to the face. Voila, you then have a 22 degree angle.
Seriously we did a ton of studies around lighting, reflection, ergonomics, table height, etc.... and then made sure it looked perfect and felt perfectly balanced.</blockquote>


<h3>7. Will Surface support bluetooth headsets?</h3>

<blockquote>Yes, Surface supports Bluetooth 4.0 and will work with Bluetooth headsets.</blockquote>

<h3>8. What happens when I flip the touch cover to the back of the device, will there be accidental keystrokes?</h3>

<blockquote>Both TouchCover and TypeCover have sensors that understand orientation relative to Surface… in fact the Type and Touch Covers talk to Surface to figure out their relative position no matter the orientation of gravity of the device (pretty neat!). There are 3 positions modes: Closed (keys and mouse are off), Open to 180 degrees (keyboard and mousepad on), beyond 180 degrees to the back (keys and mouse off). That way you can flip back the covers and feel secure you are not pressing keys by mistake.</blockquote>

<h3>9. How does the TouchCover work?</h3>

<blockquote>Touch Cover has a very special digitizer that we invented.. it senses the impact force of your key presses. We designed super-fast electronics and smart algorithm in the keyboard so that Touch Cover can profile your key press down to a 1ms (1000 times a second). Using that information Touch Cover can infer if the user meant to press the key or not.. It is a smart key. So even though there is no key travel, the user can rest their hands on top of the keyboard and find home position without accidentally triggering keys.. pretty cool! The first time I typed on a full working version of Touch Cover, I typed just as fast as I do on a normal keyboard. I am confident you will be able to type significantly faster on Touch Cover than an onscreen keyboard. And with a little practice you will even do better (maybe even faster!) For folks who really love and really need keys that have travel, then Type Cover is one of the best keyboards I have ever used (desktop or other). It has a super awesome snappy key mechanism that feels great (has a strong hysteresis curve)</blockquote>

<h3>10. So there's no NFC, why?</h3>

<blockquote>For the product design experience we were aiming for with Surface, the Mg metal enclosure, including the back case, was critical. This made good antenna design for NFC a trade-off in our development process.</blockquote>

To learn more about Surface, check out the video below!

<div class="video-container">
<iframe width="560" height="315" src="http://www.youtube.com/embed/yswUFCD1x0A" frameborder="0" allowfullscreen></iframe>
</div>

Personally I can say that I am very excited about the Surface products, both RT and Pro. 

<strong>How excited are you?</strong>