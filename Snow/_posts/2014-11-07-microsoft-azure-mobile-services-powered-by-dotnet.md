---
layout: post
title: Introducing the Azure Mobile Services .NET Backend
date: 2014-11-07 00:00
author: fekberg
published: draft
comments: true
metadescription: Introducing the Azure Mobile Services .NET Backend
categories: .NET, C#, Programming
tags:  .NET, CSharp, Programming, Mobile Services, Azure, Microsoft Azure, Microsoft Azure Mobile Services, Mobile Services .NET Backend, MongoDB
---

###Azure Mobile Services As We Know It
If you, as many others, look for an easy way to create a scalable and reliable backend Azure Mobile Services is a really viable option. Up until today we have had the capabilities of defininig the backend in Mobile Services using NodeJS. Even if you have used Mobile Services though, you might not have had to bother with the NodeJS parts because out of the box you have got a dynamic data schema that adapts with the models you define.

On-top of allowing you to easily define what the data looks like, you have been able to use NodeJS when inserting, updating or deleting data to for instance make sure that a user is authenticated. The word "mobile" comes nicely into play as developers of Mobile applications we do not want to focus too much on where we store data and how it is done; we want as low friction as possible! Thus having an extremely easy way to define, extend and scale a backend is highly valuable.
<!--excerpt-->
However, the scalability, reliablity and having an easiliy changable backend is not all that Azure Mobile Services provides us. We also get out of the box support for introducing push notifications, authentication and authorization in our mobile applications. All of these are commonly faced problems and Mobile Services makes it easier for us to work with. The authentication and authorization allows us to login to our applications using providers we all love: Twitter, Facebook, Google, Microsoft and Active Directory. I would like to emphesise active directory, you can use your on-premises AD and hook that up to Azure so that your users can login to your application using their coorporate AD account.

Moving forward we have a lot of interesting changes that have been introduced to allow for a more flexible backend. NodeJS is great, but in Azure Mobile Services it may feel a bit limiting and hard (in terms of debugging) to work with.

I'm very happy to be able to give you an introduction to the .NET powered backend in Azure Mobile Servives by using WebAPI!

#### Exploring Mobile Services .NET Backends, Offline Data support and alternative data stores
I was invited to speak on this topic at TechEd Australia 2014 and the recording, and slides, are now available on Channel 9. As always I hope you will enjoy the content and if you are left with any questions or have any feedback about Azure Mobile Services, please feel free to leave me a comment.

<div class="video-container">
<iframe src="//channel9.msdn.com/Events/TechEd/Australia/2014/WPD408/player" width="800" height="450" allowFullScreen frameBorder="0" scrolling="no"></iframe>
</div>

##### Download the resources
* [Download the code samples](https://github.com/fekberg/TechEd-2014)
* [Download the slides](http://video.ch9.ms/sessions/teched/au/2014/WPD408.pptx)
* [Download the High Quality MP4 video of the talk](http://video.ch9.ms/sessions/teched/au/2014/WPD408.mp4)

##### Errata
In the demos in the above talk I show how you can change the backend data store to MongoDB from SQL Server. What I forget to highlight and change in the `TodoItem` is that it needs to inherit from `DocumentData` instead of `EntityData`. Without making this change, certain operations like update (PATCH) will fail.

**Please do leave a comment letting me know if you find this usefull, if you use something similar in your work or if you have suggestions on how this can be improved.**