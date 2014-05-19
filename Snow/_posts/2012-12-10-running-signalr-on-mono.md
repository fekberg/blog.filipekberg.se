---
layout: post
title: Running SignalR on Mono
date: 2012-12-10 14:17
author: fekberg
comments: true
metadescription: This is how you get SignalR running on Mono!
categories: .NET, C#, Programming
tags: apache, aspnet, csharp, dotnet, linux, mono, SignalR
---
If you are one of those people, just like I am, that still use Linux for hosting despite that you love and only do .NET development; this is something extremely awesome. Ever since I started using SignalR I've wanted to host it on my own servers but all of them run on Linux with Mono and Apache. When David Fowler tweeted a couple of days ago that he was working on getting SignalR working on Mono; I had fireworks in my belly!

When I later told him that I actually run "real" web stuff on Linux with Mono and Apache, I was asked if I wanted to try get SignalR working on Mono! I love working on Windows so ideally I want to build and test stuff on my Windows development machine and then deploy to one of the Linux servers that uses Mono and Apache. The server that I got this running on is running <strong>Apache 2.2.14 and Mono 2.11</strong>.<!--excerpt-->

<strong>tl;dr:</strong> You just need to compile the SignalR dev branch and use those libraries. Upload to a host that already runs Mono and Apache!

<h3>Preparing SignalR</h3>
The first thing that David instructed me to do was to clone the git repository and grab the latest dev-branch. In the future I expect that this work flow will change a bit, but for now this is how you do it.

Fire up you Git Bash and write the following in order:

<ol>
	<li>clone <a href="https://github.com/SignalR/SignalR.git">https://github.com/SignalR/SignalR.git</a></li>
	<li>cd SignalR</li>
	<li>git checkout dev</li>
	<li>git submodule init</li>
	<li>git submodule update</li>
	<li>build.cmd</li>
</ol>

After a while when the project has finished building, you should see something like this:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/1.png" alt="" title="Building SignalR" width="677" height="415" class="alignright size-full wp-image-1523" />

Since this is the dev branch some things have changed from what you might have seen before. For instance <strong>Microsoft.AspNet.SignalR.Hosting.Common.dll</strong> isn't there anymore check inside `src\Microsoft.AspNet.SignalR.SystemWeb\bin\Debug` for the libraries that you will need to use. The Hosting library gave you the `RoutingExtensions` which is now moved to `SystemWeb`

<h3>Getting Persistent Connection to work</h3>
Now that SignalR is compiled and ready to be tested, we can create a new empty web project for .NET 4.0. <em>Since I tried this on Mono 2.11 I am using .NET 4.0!</em>

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/22.png" alt="" title="Creating a new Empty Web Application" width="810" class="alignright size-full wp-image-1528" />

Let's get the most basic thing working; the persistent connection. The idea here is that we want to get the broadcast demo that is available on the SignalR Wiki page working. <a href="http://www.youtube.com/watch?v=Zlm2atP8_RQ">I also showed this in my latest screencast about SignalR.</a>

First we need to add the references to the SignalR libraries that we just compiled and set them to be copied locally.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/3.png" alt="" title="Adding the references to the project" width="810" class="alignright size-full wp-image-1529" />

As you can see the references are from `src\Microsoft.AspNet.SignalR.SystemWeb\bin\Debug`.

Before we start coding, we can add the JavaScript which you can find in `src\Microsoft.AspNet.SignalR.Client.JS\bin`. Now we can do just as the <a href="https://github.com/SignalR/SignalR/wiki/QuickStart-Persistent-Connections">Wiki page </a>instructs us to do.

Add a class called `MyConnection` with the following content:

    using System.Threading.Tasks;
    using Microsoft.AspNet.SignalR;
  
    public class MyConnection : PersistentConnection 
    {
        protected override Task OnReceivedAsync(IRequest request, string connectionId, string data) 
        {
            // Broadcast data to all clients
            return Connection.Broadcast(data);
        }
    }

You will also need to add a Global.asax file with a route added:

    using System;
    using System.Web.Routing;
    using Microsoft.AspNet.SignalR;

    namespace MonoTesting
    {
        public class Global : System.Web.HttpApplication
        {
            protected void Application_Start(object sender, EventArgs e)
            {
                RouteTable.Routes.MapConnection<MyConnection>("echo", "echo/{*operation}");
            }
        }
    }

Finally we can add a HTML file with the following content:

    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title></title>
    </head>
    <body>
        <script src="http://code.jquery.com/jquery-1.7.min.js" type="text/javascript"></script>
        <script src="jquery.signalR.js"></script>
        <script type="text/javascript">
            $(function () {
                var connection = $.connection('/echo');

                connection.received(function (data) {
                    $('#messages').append('<li>' + data + '</li>');
                });

                connection.start().done(function () {
                    $("#broadcast").click(function () {
                        connection.send($('#msg').val());
                    });
                });

            });
        </script>

        <input type="text" id="msg" />
        <input type="button" id="broadcast" value="broadcast" />

        <ul id="messages">
        </ul>
    </body>
    </html>

Now we're ready to compile and run it!

<h3>Running it on Apache with Mono</h3>
I'm not going to cover how to set up Apache with Mono, there are plenty of tutorials for that out there already. However, all I did was create a new virtual host that is Mono enabled and I copied the content over to that folder and <strong>it just works!</strong>

<h3>Converting a SignalR application to run on Mono and Apache</h3>
As you might have seen in my screencast on SignalR I've created a Tic-Tac-Toe game, which is  also <a href="https://github.com/fekberg/Tic-Tac-Toe">available on github</a>. I downloaded the master and opened up the solution to make the changes needed to get it running on Mono and Apache.

First thing that needs to be done here is to change the Target framework to .NET Framework 4 instead of 4.5. This will cause some issues with the SignalR version that was grabbed from NuGet. So you will also need to remove those before proceeding.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/4.png" alt="" title="Changing the Target framework" width="810" class="alignright size-full wp-image-1532" />

Just as we did with the persistent connection, we need to add the libraries that we compiled and also add the new javascript:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/5.png" alt="" title="Adding the new files" width="482" height="755" class="alignright size-full wp-image-1533" />

Now we need to replace the SignalR script that we are using in the client HTML to the new script file that we just added to the solution. In the case of Tic-Tac-Toe we replace:

    <script src="/Scripts/jquery.signalR-1.0.0-alpha2.min.js" type="text/javascript"></script>

with

    <script src="Scripts/jquery.signalR.js"></script>

Finally if you haven't already, force long polling for the time being:

    $.connection.hub.start({ transport: 'longPolling' });

Compile and run it locally to test that it still works then upload to your favorite Mono hosting! There's a live demo available at <a href="http://signalr.fekberg.com">signal.fekberg.com</a> that looks like this (and as you can see it runs on Mono + Apache!):

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/6.png" alt="" title="Tic-Tac-Toe SignalR on Mono!" width="810" class="alignright size-full wp-image-1534" />

<h3>Need an introduction to SignalR?</h3>

<div class="video-container">
<iframe width="640" height="360" src="http://www.youtube.com/embed/Zlm2atP8_RQ" frameborder="0" allowfullscreen></iframe>
</div>
