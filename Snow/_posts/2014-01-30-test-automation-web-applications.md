---
layout: post
title: Test Automation for Web Applications
date: 2014-01-30 13:36
author: fekberg
comments: true
metadescription: Test Automation for Web Applications with Selenium in ASP.NET MVC
categories: .NET, C#, Programming
tags: ASP.NET, ASP.NET MVC, csharp, MS Test, MVC, Programming, Selenium, Test Automation, testing, Web
---
If you're a web developer, I am sure you can relate to the feeling where you over and over again start up your web application, navigate to the local instance and try the same feature over and over again where you just thought you had fixed all the bugs. I'm sorry to tell you this, but you'll most likely be starting it up and navigating to that same page a couple of more times. Both in my book and countless times on this blog I've said: If you do something over and over again – automate it!<!--excerpt-->

Sometimes it is easier said than done, when it comes to the case of UI it's not that easy to test everything and the investment you have to make to get everything automated might seem larger than the return of investment. I've tried a couple of different ones. One of the most recent ones is Sikuli – which is not the one I'm going to talk about here. I'll mention one thing about Sikuli though, it can test any GUI, not just websites. However it relies on screenshots and other magic which makes it easy to break, hence there's more work involved in maintaining the UI tests.

This brings us to the tool that I have in mind; <strong><a href="http://docs.seleniumhq.org/" target="_blank">Selenium</a></strong>.

Their punch-line is pretty simple, they automate browsers. Which in my eyes looks exactly like what I want when automating my tests for web applications. Selenium isn't specific to C# or .NET, in fact there's a large support for different languages such as Java, Perl, PHP, Python, Ruby <a href="http://docs.seleniumhq.org/about/platforms.jsp#programming-languages" target="_blank">and more</a>. However, if it's not obvious by now C# is my language of choice so I'll show how to set this up with a ASP.NET MVC solution.
<h3>Prerequisite</h3>
There are a couple of different things that you need before you can get started. Actually there is sort of just one thing – a web browser that corresponds with the web driver of your choice.

Selenium offers a set of web drivers, these drivers interact with browsers like Firefox, Internet Explorer, Chrome, Safari and others. This is pretty great, so you can write your browser tests and have it run against the browsers your customer requires!

I'm going to use Firefox, so all I did was installed the latest version of Firefox.

<h3>Getting started with Selenium</h3>
Open up, or create The Next Big Thing that you have in mind, I'm going to create a Test project for my ASP.NET MVC application because that is where I want my UI test to go.

<img title="1" alt="1" src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2014/01/1.png" width="770" border="0" />

This will work with a lot of different testing frameworks, so don't worry about that for now. If you have any extremely specific testing framework, just head over to their website and <a href="http://docs.seleniumhq.org/about/platforms.jsp" target="_blank">have a look if it supports that.</a>

I want to write a test that verifies that the registration process works, that I can logout and then log back in with the same username and password. As opposed to unit tests where there can be 5 unit tests per function, I want 1 UI test for 5 functions. This might seem odd at first, but UI tests are more expensive to execute, they will take longer than normal unit tests. That isn't the only reason though, I want to imitate the real end users behaviour when writing my UI tests.

Let's start now by adding a new test class to the test project, let's add this in a folder called UI just to group them nicely. My test class is called `RegistrationTest` which contains just one test method for now which I'll call `Can_Create_Account_And_Login`. This name is pretty descriptive of what is going to happen, sure you can be even more verbose but for the sake of your eyes I'll stick to something simple.

<img title="2" alt="2" src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2014/01/2.png" width="810" border="0" />

There's not much to it yet, we just have the standard template MVC project, with a test project and a empty test which we are going to use for our first UI test.
<h3>Installing Selenium via NuGet</h3>
As any other great library, you can <a href="http://www.nuget.org/packages/Selenium.WebDriver">install Selenium via NuGet</a> like this:

    Install-Package Selenium.WebDriver

Just make sure that you set it to install the package into the test project.

    PM> Install-Package Selenium.WebDriver
    'Selenium.WebDriver 2.39.0' already installed.
    Adding 'Selenium.WebDriver 2.39.0' to TheNextBigThing.Tests.
    Successfully added 'Selenium.WebDriver 2.39.0' to TheNextBigThing.Tests.

Now that the Selenium Web Drivers are installed, we can start writing our tests!
<h3>Writing the first test</h3>
How do you imagine that we will find elements on the web page? How would you find elements if you were using, for instance, jQuery? You're guessing right, we can use the selectors that we are use to! There are 5 elements that we want to retrieve these elements exist on the following pages:
<ul>
	<li>Login</li>
	<li>Register</li>
	<li>_LoginPartial</li>
</ul>
The test we want to write will create a user by first navigating to the URL that our website is located on, I will just hard code this into the tests but I'd recommend storing this in a configuration file. When arrived at the page, we want to click the Register link, enter the username, password, password confirmation and finally press submit. When that is done a user should have been created and we can verify that by looking for the “Hello [Name goes here]”.

<img title="3" alt="3" src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2014/01/3.png" width="810" border="0" />

Of course after we've registered the user and automatically been redirected to the private area of the website we want to logout and verify that the data is still persisted, so we are going to somewhat do the same process but via the registration page instead.

It's pretty funny that the tests themselves are so much less text than what it takes to explain it. So let's start looking at that shall we?

I decided to go with the Firefox driver and you can create an instance of this:

    FirefoxDriver _firefox = new FirefoxDriver();

I'll store this as a `private readonly` field in my test class. The driver lets me do things like navigating, finding elements on the current page, submitting and things like you would expect to be able to do with a browser. It also allows you to take screenshots!

Creating screenshots is easy, we're getting a bit side-tracked when talking about that, but go and play with `_firefox.GetScreenshot().SaveAsFile()`!

The first thing that we need to tell the driver to do is to navigate to the page where it is all located, then perform the other steps we talked about above. You easily navigate to a page by doing the following:

    _firefox.Navigate().GoToUrl(<a href="http://localhost:1164/">http://localhost:1164/</a>);

As you see the API is pretty straight forward so far, so how do you imagine we get elements on the page? Well, let's say that we want to find the register link and click that, that's easy. As soon as the navigation is done, I'll be performing the click event on the registration link by doing the following:

    _firefox.FindElementById("registerLink").Click();

The best part here is that you don't have to wait for the previous execution to finish, it won't try to click anything until the navigation is done, or any other previous operation that is. I won't bother you will explaining every single line of code in the rest of the test class, so let's just have a look at the helper method I created to create the user:

    private void CreateUser(string username, string password)
    {
        _firefox.Navigate().GoToUrl("http://localhost:1164/");
        _firefox.FindElementById("registerLink").Click();
        _firefox.FindElementById("UserName").SendKeys(username);
        _firefox.FindElementById("Password").SendKeys(password);
        _firefox.FindElementById("ConfirmPassword").SendKeys(password);
        _firefox.FindElementByCssSelector(".btn.btn-default").Click();

        var userWasCreated =
            _firefox.FindElementByCssSelector(".nav.navbar-nav.navbar-right").Text.Contains(username);
        Assert.IsTrue(userWasCreated);

        _firefox.FindElementById("logoutForm").Submit();
    }

Pretty straight forward right?

The helper method to login a user is equally simple:

    private void LoginUser(string username, string password)
    {
        _firefox.Navigate().GoToUrl("http://localhost:1164/");
        _firefox.FindElementById("loginLink").Click();
        _firefox.FindElementById("UserName").SendKeys(username);
        _firefox.FindElementById("Password").SendKeys(password);
        _firefox.FindElementByCssSelector(".btn.btn-default").Click();
                
        var userWasCreated =
            _firefox.FindElementByCssSelector(".nav.navbar-nav.navbar-right").Text.Contains(username);
        Assert.IsTrue(userWasCreated);

        _firefox.FindElementById("logoutForm").Submit();
    }

These two together makes up for the first test for our website, they might seem pretty simple. The funny part is that when I wrote the tests I found rules about the registration process that I didn't know (because I hadn't dug into the code). So not only am I writing tests to ensure that the behaviour is the same in the future, but I also learned about my current project.

I want to be able to run this test over and over again, so I made some small tweaks to my test method and here's a complete implementation of the test class:

    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using OpenQA.Selenium.Firefox;

    namespace TheNextBigThing.Tests.UI
    {
        [TestClass]
        public class RegistrationTests
        {
            private readonly FirefoxDriver _firefox = new FirefoxDriver();
            [TestMethod]
            public void Can_Create_Account_And_Login()
            {
                var username =
                    string.Join("", Guid.NewGuid()
                    .ToString()
                    .Take(5));
                var password =
                    string.Join("", Guid.NewGuid()
                    .ToString()
                    .Take(6));

                CreateUser(username, password);
                LoginUser(username, password);

            }
            private void CreateUser(string username, string password)
            {
                _firefox.Navigate().GoToUrl("http://localhost:1164/");
                _firefox.FindElementById("registerLink").Click();
                _firefox.FindElementById("UserName").SendKeys(username);
                _firefox.FindElementById("Password").SendKeys(password);
                _firefox.FindElementById("ConfirmPassword").SendKeys(password);
                _firefox.FindElementByCssSelector(".btn.btn-default").Click();

                var userWasCreated =
                    _firefox.FindElementByCssSelector(".nav.navbar-nav.navbar-right").Text.Contains(username);
                Assert.IsTrue(userWasCreated);

                _firefox.FindElementById("logoutForm").Submit();
            }
            private void LoginUser(string username, string password)
            {
                _firefox.Navigate().GoToUrl("http://localhost:1164/");
                _firefox.FindElementById("loginLink").Click();
                _firefox.FindElementById("UserName").SendKeys(username);
                _firefox.FindElementById("Password").SendKeys(password);
                _firefox.FindElementByCssSelector(".btn.btn-default").Click();

                var userWasCreated =
                    _firefox.FindElementByCssSelector(".nav.navbar-nav.navbar-right").Text.Contains(username);
                Assert.IsTrue(userWasCreated);

                _firefox.FindElementById("logoutForm").Submit();
            }
        }
    }

It's not really that massive or hard to get started with, this is a very simple scenario but it's going to help a lot with future development of the application. Now whenever I add something new to my web application that is visible from the user perspective, I can just run all my automated UI tests  and verify that the application is intact. If you have lots of them, it's going to get a bit slow, so think about having a CI server that runs these heavy tests for you so you're not blocked in your development.

This is what it will look like when you run it, one thing, make sure that the web application is already up and running, if the tests can't reach it they'll fail! Notice that in the end of the test run, all the tests turn green and you can go on to testing the next thing.

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2014/01/TestAutomationforWebApplications.gif" alt="TestAutomationforWebApplications" width="800" class="alignnone size-full wp-image-2206" />

Of course there are a couple of things that could come back and bite you if you're not careful, as always that is. One of the things to keep in mind is that when you use the selectors for your items, what happens if you have the same css selector for multiple items? What happens if you remove the class? There are a bunch of cases like that which you need to have in mind, but at the end of the day, this will surely help you ensure the application works better than if there were no tests!

I hope you found this article helpful, please leave a comment about your experience with Test Automation for Web Applications!
