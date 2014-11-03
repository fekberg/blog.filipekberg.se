---
layout: post
title: Getting Started with Continuous Delivery
date: 2014-10-31 00:00
author: fekberg
published: draft
comments: true
metadescription: Getting Started with Continuous Delivery
categories: .NET, C#, Programming
tags:  .NET, CSharp, Programming, Agile, Scrum, Continuous Delivery, TeamCity, Octopus Deploy
---

###Working in an agile environment
While working in a high paced and agile environment, building block by block to reach the ultimate minimal viable product, stakeholders will most definitely ask more than once if they can see what you have thus far.

Agile, Scrum, continuous delivery and testing are not new concepts or buzz-words. Although they have all been around for a while they are still something well worth talking about and working on improving in your team.

Over the years I have seen countless of products being worked on where there has been no real definition of, or well-thought through direction to get to, a minimal viable product. The main problem I see derives from the customer not being able to define a subset of features that are good enough for a first product release. If we put ourselves in the shoes of a customer, we might as well have been a customer or will be in the future, imagine having a vision of a great product and someone telling you to cut it in half and choose which side you like the most. It's difficult, right?

Before we fall too deep into the rabbit hole here and go in a different direction, let me be perfectly clear on what message I want to give with the above. In a scrum environment, we work towards a goal, most likely towards a vision that a customer has. Working in an agile environment means that the customer is allowed to change their minds, more than once even! While we are working towards this goal, we know for a fact that the customer will change their minds and our processes needs to cater for this behaviour.

While on the subject of scrum, the point of a sprint is to deliver a set of features that your team has agreed on. After this sprint, or even during the sprint, wouldn't it be very handy of stakeholders could see, and work with, what you are building?

This is where continuous delivery comes into play. As we want to be transparent with our customers during the development, and we want them to be able to change their minds, being able to continuously give them a way to work with the product is key. So where does minimal viable product and choosing one side of the cake come into the picture? Before we answer that, let us define what continuous delivery is all about.

###What is Continuous Delivery?
What “Continuous Delivery” means (as a set of words) is obvious, but what it means to product development and delivery may not be. Traditionally developers work on their local machines, when they're done for the day they hopefully push that into some kind of source control (or save it on a floppy drive).

The code doesn't reach much further than that in this case though, everything that has been done that day is in the developers head, and maybe at best the developer updated the team board with information on what had been done for the day. 

Introducing continuous delivery into the mix would mean that once the source code is pushed, a second system is notified that there has been a change and a process of delivering what has been worked on the day is started. This process will build your code, run the tests and then deploy to your server(s).

Is that all there is to continuous delivery? Certainly not.

What is defined above is just what is supposed to happen when the code is pushed to the source code repository. Continuous delivery is not only about that, it is also about making sure that what is delivered is of somewhat a high quality.

Each delivery through the continuous delivery pipe should in the developers point of view be a minimal viable product. This means when you check in your code into the main repository, you should be so certain of its high quality, that there should be no code compilation failures and unit tests should all run fine. Of course, this is not to be confused with the minimal viable product that the customer defined.

Thus Continuous Delivery is a way for us to define a process for delivering features continuously and about making sure the deliverable is of high quality.

###How do we increase quality of a delivery?
How long is a string (not the data type!)? This is where it does get a bit fluffy and philosophical. You will hear developers argue for days and days on how important, or not important, unit tests are. There are a few very important things to keep in mind: you can have 90% code coverage and still have an application that doesn't work.

Hold your horses! What's this code coverage and why should I care about it? Every line of code that you write could have a unit test associated with it. If for instance all a method is doing, is printing a constant to the code, all you need to do to get a 100% code coverage (for that method) is to invoke it. Hence that there are no assertions being done in this case.

If you have an if statement in your method, in order to get 100% test coverage you need to call the method and reach both inside and outside the condition. This means that if you have tons of nested conditions the amount of tests grow pretty large.

However, testing individual pieces of code is a good start, but in the long run it would make a much bigger sense to write tests that verify end-to-end functionality.

If you are working with a ASP.NET MVC website for instance, a test that starts the website, runs a `HttpClient` call to the website and verifies that the data it gets back is proper is worth much more than a few unit tests that tests if conditions. I would argue that acceptance tests, or integration tests are in the majority of cases worth a lot more than simple unit tests.

Of course, in order to increase the quality of the delivery we need a way to ensure that the code is good and solid and that the feature we have been working on is functioning accordingly. A good way to get into the game is to start writing unit tests, get comfortable with trying to break your code and write tests that test negative scenarios.

Remember that naming your tests are crucial to their success, don't just name your tests something generic but rather follow a pattern that your team conforms to. I tend to lean towards naming my test like the following: `Given_That_Username_Is_Empty_Login_Attempt_Fails`.

###Deploying to Different Environments
<img src="http://cdn.filipekberg.se/fekberg-blog/getting-started-with-continuous-delivery/BuildLightRed.png" style="float: right; padding-left: 20px; padding-bottom: 20px; width: 80px; " />When there's changes being pushed to our source control, hopefully the developers have already run all the unit tests locally to make sure there are no obvious errors. Unit tests are fast to run, as opposed to acceptance (functional/integration) tests which can take a long time to run.<br/><br/>The idea is that our continuous delivery process runs through the following steps:

1.	Run Unit Tests
2.	Run Acceptance Tests
3.	Deploy to Test
4.	Run Acceptance Tests for Test
5.	Deploy to Production

Each step is only executed if the previous was marked as OK. I prefer to have a build light that tells me if the build fails or not!
 
The different environments could have different test data, as they do resemble different states in the deployment. The closer you get to production, the closer you should get to testing with real data.

###Recommended Tools
Continuous delivery should be on every team's radar, if you're not continuously delivering your product right now by introducing it you will most certainly blow more than one mind. Of course this is something we all want, unless we work in a traditional waterfall model where we are still swimming towards the current (although I don't think there's much of a current in a waterfall.

To achieve good continuous delivery we have a bunch of tools that can help us, here are a few highlights (and I'd love to hear about your tools of choice!):

* [TeamCity](https://www.jetbrains.com/teamcity/) is a great tool to use for Continuous Delivery/Integration. It will monitor changes in your source code repository, help you build and deploy your product 
* [Octopus Deploy](https://octopusdeploy.com/) will let you automate deployments, you could for instance deploy the product to 10 servers behind a load balancer once TeamCity marks it as OK 
* [NCrunch](http://www.ncrunch.net/) for Visual Studio is a tool that continuously runs all tests in your solution as there is a change to a file. It also provides you with metrics on code coverage and visual indications if a part of the code is untested. This tool is a great way to get started with testing and getting a better test coverage of your code
* Azure is a great platform to host your solutions on, and for my blog for instance I have incorporated continuous delivery by always deploying the blog once I have added a post to the Github repository
 
 <img src="http://cdn.filipekberg.se/fekberg-blog/getting-started-with-continuous-delivery/AzureDeploymnet.png" style="float: right; padding-left: 20px; padding-bottom: 20px;" />

###Where to go now?
We've only scratched the surface of how to work in a continuous delivery environment, I hope this gives you a taste of how to improve your deliveries within your project.

I'd love to hear from you what tools, processes and patters you and your team use!

*Thanks a lot to [Stephen Godbold](http://stevegodbold.com/) for reviewing and giving a lot of great early feedback on this article*.