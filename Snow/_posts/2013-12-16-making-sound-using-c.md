---
layout: post
title: Making sound using C#
date: 2013-12-16 03:03
author: fekberg
comments: true
metadescription: Making sound using C# using BEEP and Voice
categories: C#
tags: C# Speak, C# Voice, C/C++, csharp, Programming, Sound, SpeechSynthesizer
---
Back in the mid-90s when I first was introduced to the concept of programming the only thing that I could really do that I found funny was to have the computer BEEP at me. At this time of course I didn't have anything as fancy as Visual Studio or C# to work with, it was just me and my QBasic editor. Basically an application back then looked something like this (syntax may or may not be correct)<!--excerpt-->:

    CLS
    PRINT "Hahaha"
    BEEP
    BEEP
    BEEP
    BEEP

Why not use loops? Come on, I was what? 8 years old? I barely understood the concept of how to eat properly with a fork and knife so don't expect anything fancier than that from an 8 year old! Joking aside, I can't really recall all the funny moments I had with QBasic, but I do remember playing with BEEP, INPUT and PRINT no matter how primitive it might seem.

The years have passed and I haven't thought about BEEP sine recently, I came across something, I can't really remember where and I saw that you can do `Console.Beep()` in C#! For me, this was like seeing one of those cartoons or eating something that you loved as a kid, it brings back those memories of when you first played with and "built" something using a computer.

Of course I just had to do some research and look for ways to do fun stuff with this, guess what I found on <a href="http://www.reddit.com/r/csharp/comments/1k8mxd/i_accidently_the_whole_application/" target="_blank">reddit</a>? Someone had done the Super Mario theme using `Console.Beep()` because `Console.Beep()` takes a frequency and a length for how long it should play. Amazing isn't it? I'm gonna save you the scrolling and not paste the code to play the super mario theme in your applications using `Console.Beep()`, just click the <a href="http://www.reddit.com/r/csharp/comments/1k8mxd/i_accidently_the_whole_application/" target="_blank">reddit</a> link and check it out!

This wasn't enough for me though, BEEPing was something I did when I was 8 years old, I need to show my parents some progress in my professional career as a software developer. Let's add some voice!

I started off by looking in to how you can make something speak using C#, did you know there is a class called `SpeechSynthesizer`? You can use this to speak words using text, I think it uses the same technology in the background as Microsoft Sam. This is really great, I came up with lots of fun ideas on what this could be used for. Don't underestimate the seriousness in `SpeechSynthesizer` though, it helps lots of people that can't see.

What can you do with BEEP and VOICE? Celine Dion!

I looked up the notes for My Heart Will Go On by Celine Dion, converted that into BEEPs using the frequency and the length (I had some help from the reddit thread) and then it hit me: How do I play a BEEP and VOICE at once? Can I do that?

Sure you can! Here's the code snippet that I came up with:

    Task.Run(() =>
    {
        Console.Beep(520, 215);
        Console.Beep(520, 265);
        Console.Beep(520, 265);
        Console.Beep(520, 215);
        Console.Beep(560, 215);
        Console.Beep(520, 215);
    });

    Task.Run(() =>
    {
        SpeechSynthesizer synth = new SpeechSynthesizer();
        synth.SelectVoiceByHints(VoiceGender.Female, VoiceAge.Senior);
        synth.SpeakAsync("Every night in my dreams");
    });

I had much fun in creating that, so much that I shared it to my friends on twitter and got a pretty fun response from David Poeschl (@dpoeschl):

<blockquote class="twitter-tweet" lang="en"><p>I&#39;m so sorry. <a href="https://t.co/fldVgI1FBZ">https://t.co/fldVgI1FBZ</a> <a href="http://t.co/3VQKY4MuUt">http://t.co/3VQKY4MuUt</a> /cc: <a href="https://twitter.com/fekberg">@fekberg</a></p>&mdash; David Poeschl (@dpoeschl) <a href="https://twitter.com/dpoeschl/statuses/411032106194591744">December 12, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<strong>What fun things can you come up with combining BEEP and VOICE?</strong>

Here's some things that you could use BEEP and VOICE for:

<ul>
	<li>Audible error alerts when something crash (Example: BEEP morse code)</li>
	<li>Feedback when developing (Example voice: "Hey, programmer, you can refactor this class!")</li>
</ul>

I write software for a living, but don't forget that you can have fun with it once in a while as well.
