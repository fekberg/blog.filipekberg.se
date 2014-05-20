---
layout: post
title: Creating a Windows 8 Store Game with MonoGame (XAML) and SignalR
date: 2012-12-21 15:36
author: fekberg
comments: true
metadescription: Creating a Windows 8 Store Game with MonoGame (XAML) and SignalR
categories: .NET, C#, Programming
tags: apache, aspnet, csharp, dotnet, linux, mono, MonoGame, SignalR, WP8, XAML
---
In previous posts we've looked at how we could create a cross-platform game that relied on HTML and JavaScript. What we also did was moving the server-side code over to a server that runs on Linux and uses Apache and Mono with SignalR! Now let's take this a step further and convert this game client to a Windows 8 Store application using MonoGame with XAML!<!--excerpt-->

<h3>Prerequisite; what you'll need to install first</h3>
Before we can dig into the coding part we need to have some tooling installed first. I am going to use Visual Studio 2012 for this. There are however a lot of resources around that tells you how to use MonoGame with <a href="http://monodevelop.com/">MonoDevelop</a> on for instance a Mac.

All you really need to install if you already have Visual Studio 2012 installed is MonoGame. You can grab the latest version (3.0 Beta) over at the <a href="http://monogame.codeplex.com/">MonoGame CodePlex site</a>.

After installing this you should be able to see the MonoGame (XAML) project template in the "New Project" dialog as seen in the image below.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/12.png" alt="" title="Creating the MonoGame project" width="800" class="alignright size-full wp-image-1549" />

For those of you that don't have a clue what MonoGame is, here's a quote from their CodePlex site:

<blockquote>MonoGame is an Open Source implementation of the Microsoft XNA 4 Framework. Our goal is to allow XNA developers on Xbox 360, Windows & Windows Phone to port their games to the iOS, Android, Mac OS X, Linux and Windows 8 Metro.  PlayStation Mobile development is currently in progress.</blockquote>

<strong>Amazing, isn't it?</strong>

Even more Amazing is that they're currently working on getting this to work with Windows Phone 8, which this post was initially going to be about but as the support isn't in the stable release yet, we'll take a look at that some other time. <a href="http://twitter.com/tomspilman">Tom Spilman</a> tweeted a while back that he got MonoGame working on Windows Phone 8!

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/23.png" alt="" title="Tom Spilman tweets about WP8 Support for MonoGame" width="590" class="alignright size-full wp-image-1546" />

There's actually one more thing that we will need to have installed and this is the <a href="http://www.microsoft.com/en-us/download/details.aspx?id=23714">XNA Game Studio</a>. This is because we want to be able to add content (Textures and such) to the game. In order to create a Content project we need to create a Dummy XNA project (there might be a much easier way, then please enlighten me!).

Go to File -> New Project -> XNA Game Studio 4.0 and create a new Windows Phone Game. This will create a projected called `WindowsPhoneGame1Content` inside the solution. Rename this to `TicTacToeContent` and add the images you'd like to have in the game (You can download all the resources below). After doing so you will need to edit the <strong>Dummy XNA</strong> project (not the content project and <strong>NOT</strong> the MonoGame project). This requires you to first unload the project by right clicking the project and then selecting unload. After that right click it again and select to Edit the csproj file.

Add the following right after the Project node:

    <Import Project="$(MSBuildExtensionsPath)\MonoGame\v3.0\MonoGame.ContentPipeline.targets" />
    <PropertyGroup>
      <ProjectGuid>{2CAE49BD-8B39-42BE-A010-D3E62657000E}</ProjectGuid>
      <ProjectTypeGuids>{6D335F3A-9D43-41b4-9D22-F6F17C4BE596};{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}</ProjectTypeGuids>
      <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
      <Platform Condition=" '$(Platform)' == '' ">x86</Platform>
      <MonoGamePlatform>Windows8</MonoGamePlatform>
    </PropertyGroup>

Then reload and build the solution!

Finally add a folder in the MonoGame project called Content and add the xnb files that was created when you compiled the Dummy XNA project. These are found in `bin\Windows Phone\Debug\Content`. Select them all and go to the properties tab (Alt+Enter) and change the "Copy to Output Directory" value to "Copy if newer". Before closing the property window you'll also need to change the Build Action to Content!

<h3>Let's get some code running!</h3>
In order to stay consistent with the code that I previously wrote for the <a href="https://github.com/fekberg/Tic-Tac-Toe">Tic-Tac-Toe demo</a> we can start by renaming Game1.cs to something more suitable such as `TicTacToeGame`. The first thing we can do is to try and get the Logo in place, I added the following images as Content (xnb):

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/41.png" alt="" title="The Textures" width="522" class="alignright size-full wp-image-1551" />

This means that we will have the following xnb's and thus be able to load them by their names:

<ul>
	<li>board (board.png) - This is the game board</li>
	<li>logo (logo.png) - This is the game logotype</li>
	<li>TicTacToeO (TicTacToeO.png) - This is the marker for a Circle</li>
	<li>TicTacToeX (TicTacToeX.png) - This is the marker for a Cross</li>
</ul>

<h4>Adding a texture</h4>
The first thing that we can try out to ensure that the content works properly is to load a 2D Texture. Add a private variable that we can access from our `Draw` method:

    private Texture2D _logoTexture;

Then inside the method `LoadContent` we can load the texture like this:

    _logoTexture = Content.Load<Texture2D>("logo");

In order to actually draw something on the screen we use the sprite batch and we need to tell the sprite batch when to being and when to end. Then we can draw a texture in a rectangle that defines the size and the position like this:

    protected override void Draw(GameTime gameTime)
    {
        GraphicsDevice.Clear(Color.CornflowerBlue);
                
        _spriteBatch.Begin(SpriteSortMode.Immediate, null, null, null, null, null);

        _spriteBatch.Draw(_logoTexture, new Rectangle { X = 100, Y = 100, Height = _logoTexture.Height, Width = _logoTexture .Width}, new Color(255, 255, 2555));
                
        _spriteBatch.End();

        base.Draw(gameTime);
    }

Running this in the simulator will make it look something like this:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/51.png" alt="" title="Seeing the Logotype added as a 2D Texture" width="810" class="alignright size-full wp-image-1553" />

Now we're ready to start with the fun! Let's install SignalR into the project, we can simply do this by getting it from NuGet!

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/61.png" alt="" title="Install SignalR via NuGet" width="745" height="72" class="alignright size-full wp-image-1556" />

There's a known bug in the RC version of SignalR which effects the fallback to long polling. This means that we manually need to define that we are in fact using long polling. After SignalR is installed into the project through NuGet we can connect to the Tic-Tac-Toe server and create a proxy.

First define two private read-only fields in the `GamePage` class, this is the code behind for the XAML file that was created for us by MonoGame:

    private readonly HubConnection _connection;
    private readonly IHubProxy _proxy;

You'll also need to add the reference to the following namespaces:

    using Microsoft.AspNet.SignalR.Client.Hubs;
    using Microsoft.AspNet.SignalR.Client.Transports;

Now, go down to the constructor of the `GamePage` class and add this to the bottom of it:

    _connection = new HubConnection("http://signalr.fekberg.com/");
    _proxy = _connection.CreateHubProxy("game");

If you recall from <a href="http://blog.filipekberg.se/2012/12/10/running-signalr-on-mono/">previous posts about SignalR</a> we need to hock up the events before we start the connection. This is pretty much equal to what we saw in the WinRT with HTML and JavaScript demo. Here's what I have to hook it up with the Tic-Tac-Toe server, to make it a bit more fluent we are going to send the request to start a game as soon as the name is registered:

    _proxy.On("registerComplete", () =>
    {
        AddMessage("Registration complete, ready to look for a game!");

        Dispatcher.RunAsync(Windows.UI.Core.CoreDispatcherPriority.Normal, () =>
        {
            _username = Username.Text;
            StartGame.Visibility = Windows.UI.Xaml.Visibility.Collapsed;
        });

        _proxy.Invoke("findOpponent");
    });

I would recommend to hook these up somewhere else than in the constructor, since the proxy is a member variable. There are two new things in this anonymous function. First we have the function `AddMessage` that takes a string. Then we have the dispatcher invocation. The method for adding a message is purely for debugging purposes, to understand what I am going with this, take a look at the following XAML for this game page:

    <SwapChainBackgroundPanel
        x:Class="TicTacToe.Windows8.GamePage"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:local="using:TicTacToe.Windows8"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        mc:Ignorable="d">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="200" />
                <RowDefinition Height="*" />
            </Grid.RowDefinitions>
            <ListBox x:Name="Messages" Width="400" HorizontalAlignment="Right" />

            <StackPanel x:Name="StartGame" Background="Black" Grid.Row="1">
                <StackPanel Orientation="Horizontal" Height="50" Margin="10,20,0,0">
                    <TextBlock FontSize="30" Margin="0, 10, 0, 0">Enter your name:</TextBlock>
                    <TextBox x:Name="Username" FontSize="30"></TextBox>
                </StackPanel>
                <Button Height="50" Margin="10,0,0,0" Click="Register">Start game</Button>
            </StackPanel>
        </Grid>
    </SwapChainBackgroundPanel>

This adds a surrounding grid to our view, this view is where we will mix the DirectX graphics and the XAML elements. Worth knowing here is that the XAML elements are always going to be topmost! The surrounding grid will have an empty area to the top left, this is where we will align the logotype that we added before. Then to the right of that we have a list box where we can add some debug messages.

Then finally we have the area where we can register the current player. This is just a simple button and some text fields. The result looks like this when running in the simulator:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/7.png" alt="" title="Running the MonoGame Game in the Simulator" width="810" class="alignright size-full wp-image-1564" />

As you can see in the top right corner there are some messages added, these are added from the events that we hooked up earlier, but what you didn't see was when we connected to the server. This is exactly as you are used to when it comes to SignalR, except for the small thing that we are forcing long polling at the time being. This will hopefully be fixed in the next RC.

    _connection.Start(new LongPollingTransport()).ContinueWith((t) =>
    {
        AddMessage("Connected to server!");
    });

Other than the method for adding a message we have seen that we have an event handler on the button. This following code sample shows how these two are implemented:

    private void AddMessage(string message)
    {
        Dispatcher.RunAsync(Windows.UI.Core.CoreDispatcherPriority.Normal, () => { Messages.Items.Add(message); });
    }
    private void Register(object sender, RoutedEventArgs e)
    {
        _proxy.Invoke("registerClient", Username.Text);
    }

Notice that `Dispatcher.RunAsync` is showing up again, this is just like the `Dispatcher` that you might be used to from WPF. We use it to run things on the GUI thread. In this case we want to add something to a GUI element and we can't do that from another thread than the GUI thread.

I would also not recommend to hook up the events to the buttons like in this demo, but for the purpose of keeping it focused on what is interesting here, you can go ahead and check out MVVM and Commands later on! 

The game page which we've been working on almost solely so far is pretty much complete, in the below longer code snippet you can  see the complete implementation of this class. As you can see much of the code isn't implemented such as what is going to happen when the game ends, you're free to add that on your own later. Now we can start looking at the MonoGame and Touch code!

    using Windows.UI.Xaml;
    using Windows.UI.Xaml.Controls;
    using MonoGame.Framework;
    using Microsoft.AspNet.SignalR.Client.Hubs;
    using Microsoft.AspNet.SignalR.Client.Transports;

    namespace TicTacToe.Windows8
    {
        public sealed partial class GamePage : SwapChainBackgroundPanel
        {
            TicTacToeGame _game;
            private readonly HubConnection _connection;
            private readonly IHubProxy _proxy;
            private string _username;
            public GamePage(string launchArguments)
            {
                this.InitializeComponent();

                _game = XamlGame<TicTacToeGame>.Create(launchArguments, Window.Current.CoreWindow, this);

                _connection = new HubConnection("http://signalr.fekberg.com/");

                _proxy = _connection.CreateHubProxy("game");

                _proxy.On("registerComplete", () =>
                {
                    AddMessage("Registration complete, ready to look for a game!");

                    Dispatcher.RunAsync(Windows.UI.Core.CoreDispatcherPriority.Normal, () =>
                    {
                        _username = Username.Text;
                        StartGame.Visibility = Windows.UI.Xaml.Visibility.Collapsed;
                    });

                    _proxy.Invoke("findOpponent");
                });
                _proxy.On("waitingForOpponent", () =>
                {
                    AddMessage("waitingForOpponent");
                });
                _proxy.On("waitingForMarkerPlacement", () =>
                {
                    AddMessage("waitingForMarkerPlacement");
                });
                _proxy.On("foundOpponent", () =>
                {
                    AddMessage("foundOpponent");

                    _game.ResetGame();
                });
                _proxy.On("noOpponents", () =>
                {
                    AddMessage("noOpponents");
                });

                _proxy.On("addMarkerPlacement", (message) =>
                {
                    AddMessage("addMarkerPlacement");

                    _game.AddMarkerPlacement((int)message.MarkerPosition, message.OpponentName == _username ? 1 : 0);
                });
                _proxy.On("opponentDisconnected", () =>
                {
                    AddMessage("opponentDisconnected");

                    _game.EndGame();
                });
                _proxy.On("refreshAmountOfPlayers", () =>
                {
                    AddMessage("refreshAmountOfPlayers");
                });
                _proxy.On("gameOver", () =>
                {
                    AddMessage("gameOver");

                    _game.EndGame();
                });

                _connection.Start(new LongPollingTransport()).ContinueWith((t) =>
                {
                    AddMessage("Connected to server!");
                });

                _game.MarkerAdded = (position) =>
                {
                    _proxy.Invoke("play", position);
                };
            }

            private void AddMessage(string message)
            {
                Dispatcher.RunAsync(Windows.UI.Core.CoreDispatcherPriority.Normal, () => { Messages.Items.Add(message); });
            }
            private void Register(object sender, RoutedEventArgs e)
            {
                _proxy.Invoke("registerClient", Username.Text);
            }
        }
    }

<h3>Adding the board, graphics and handling touch</h3>
Since this Tic-Tac-Toe game isn't really that complex, the graphics and game code is going to be quite simple. The game class itself is going to consist of a couple of private fields which we will use a lot throughout the class. These are used to handle the textures that we have loaded, just as we did with the logo before and for handling the game state and the board!

These are the member variables in the game class:

    GraphicsDeviceManager _graphics;
    SpriteBatch _spriteBatch;
    private Texture2D _logoTexture;
    private Texture2D _board;
    private Texture2D _markerX;
    private Texture2D _markerO;
    private bool _isGameStarted;
    private int[] _boardPlacements;

There's actually one more member to this class which you might have glanced upon in the longer code sample from the game page, which is the action we use to place a marker. This action will just work as a handler for the touch events. So when we touch the screen it tries to send a marker placement to the server. This might of course not be ideal since bandwidth and messages might cost in an enterprise application, but let's keep it simple.

    public Action<int> MarkerAdded { get; set; }

In case you don't want to scroll up and see how this is used from the game page, here's how it's being used:

    _game.MarkerAdded = (position) =>
    {
        _proxy.Invoke("play", position);
    };

Now, there are actually just a couple of methods in the game class that we are using. From the beginning, this class which is called `TicTacToeGame` is generated and has a set of methods overridden from its base class. Some of these methods are used when content is loading and unloading or when the state is updated. It is also used when we want to draw something on the screen. It's a good idea to split this up into different "scenes" if your project grows. However, let's keep it simple!

The easiest method we can start with is the one that doesn't rely on anything else, resetting the game and the game board. This following method resets the game board by creating an integer array with 9 positions where each integer starts at the value -1.

The code that is commented out is used to test if the board is possible to fill with different markers:

    public void ResetGame()
    {
        _boardPlacements = new int[9]; // [] {0,1,0,1,0,1,0,1,0};
        for (var i = 0; i < 9; i++)
        {
            _boardPlacements[i] = -1;
        }

        _isGameStarted = true;
    }

We also have two other methods that don't rely on anything else and these are for ending the game and for adding marker placements:

    public void EndGame()
    {
        _isGameStarted = false;
    }
    public void AddMarkerPlacement(int position, int marker)
    {
        _boardPlacements[position] = marker;
    }

The following method is a bit more complex, it's the method that we use to draw the board. This will use the board placement array to find out where to place the marker in x and y coordinates and then draw it on top of the board. As you can see we use the same methods for drawing the textures as we did with the logotype:

    public void DrawBoard()
    {
        if (!_isGameStarted) return;

        _spriteBatch.Draw(_board, 
            new Rectangle { 
                X = 10, Y = 150, 
                Height = 400, 
                Width =  400}, 
            new Color(255, 255, 255));

        for (var i = 0; i < 9; i++)
        {
            if (_boardPlacements[i] == -1) continue;

            if (_boardPlacements[i] == 0)
            {
                _spriteBatch.Draw(
                    _markerO,
                    new Rectangle
                    {
                        X = 20 + ((i % 3) * 140),
                        Y = 180 + ((i / 3) * 120),
                        Height = 100,
                        Width = 100
                    },
                    new Color(255, 255, 255));
            }
            else
            {
                _spriteBatch.Draw(
                    _markerX,
                    new Rectangle
                    {
                        X = 20 + ((i % 3) * 140),
                        Y = 180 + ((i / 3) * 120),
                        Height = 100,
                        Width = 100
                    },
                    new Color(255, 255, 255));
            }
        }
    }

In order to actually draw something on the screen we need to implement the `Draw` method. This method will actually use the method we just looked at for drawing the board, just so that we don't have too much code in one method:

    protected override void Draw(GameTime gameTime)
    {
        GraphicsDevice.Clear(Color.White);

        _spriteBatch.Begin(SpriteSortMode.Immediate, null, null, null, null, null);

        _spriteBatch.Draw(_logoTexture, new Rectangle { X = 10, Y = 10, Height = _logoTexture.Height, Width = _logoTexture.Width }, new Color(255, 255, 255));

        DrawBoard();

        _spriteBatch.End();

        base.Draw(gameTime);
    }

One final method that we need to implement before we can run our game is the method for updating the game state. It is also here that we handle the touch events. However, in order for us to interpret the touches at taps we need to enable that type of gesture. This is preferable done in the initialization and looks like this:

    TouchPanel.EnabledGestures = GestureType.Tap;

The gesture types are enums and are marked as flags, so you can combine different gestures like this:

    TouchPanel.EnabledGestures = GestureType.Tap | GestureType.Pinch | GestureType.HorizontalDrag;

We can stay with just allowing tap for this demo though. Now let us take a look at how we handle the touches. The touches will be added to a collection and we can keep track of when there's no longer any touches on the screen. When we have a touch collection we can see if the current touch (the first touch) is within the bounds of our game board.

Then we can calculate where on the game board the touch is and thus finding out the position:

    protected bool Touching { get; set; }
    protected override void Update(GameTime gameTime)
    {
        var touches = TouchPanel.GetState();

        if (!Touching)
        {
            if (touches.Count <= 0) return;

            if (touches[0].Position.Y < 150 || touches[0].Position.Y > 650) return;
            if (touches[0].Position.X < 10 || touches[0].Position.X > 410) return;

            var column = (int)Math.Floor(touches[0].Position.X / 150);
            var row = (int)Math.Floor(touches[0].Position.Y / 150) - 1;

            var index = column + row * 3;

            MarkerAdded(index);

            Debug.WriteLine("Row: {0}, Column {1}", row, column);
        }

        if (touches.Count == 0) Touching = false;

        base.Update(gameTime);
    }

<h3>Remote debugging on Surface</h3>
I want to try this on my ARM device, so what I first need to do is to change the Platform target to Any CPU as you can see in the image below.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/8.png" alt="" title="Platform target Any CPU" width="810" class="alignright size-full wp-image-1567" />

Now verify that you are building against any platform by pressing the arrow next to "Debug" and go to "Configuration Manager". It should look like this:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/9.png" alt="" title="Configuraiton Manager" width="716" class="alignright size-full wp-image-1568" />

Next you need to install and run the application "Remote Debugging" which is <a href="http://www.microsoft.com/visualstudio/eng/downloads#remote-tools">available here</a>. You'll need to scroll down to "Remote tools for Visual Studio 2012". This should be installed on the Surface (or whatever computer you want to remote debug on!), not the development machine. <a href="http://timheuer.com/blog/archive/2012/10/26/remote-debugging-windows-store-apps-on-surface-arm-devices.aspx" target="_blank">There's a great post describing this in details that I suggest you check out.</a>

Finally run the Remote Debugging application on the Surface and set Visual Studio to run on your Surface:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/10.png" alt="" title="Remote Debugging" width="710" class="alignright size-full wp-image-1569" />

<h3>Playing against myself</h3>
Now that this is running on the Surface I can bring another instance up in the Simulator and try to play against myself. This is what that will look like:

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/WP_20121220_013.jpg" alt="" title="MonoGame on Surface!" width="810" class="alignright size-full wp-image-1571" />

<h3>Recap</h3>
This post has gone through a lot of interesting topics and just scratched the surface on many of them. But the idea was to wrap up all the cool things that we've looked at with SignalR and Windows 8 for the last couple of months. This post is far to long to fit in a tl;dr but here is a bullet list of the awesome things used in this post:

<ul>
	<li>Getting started with MonoGame</li>
	<li>Adding basic textures with MonoGame</li>
	<li>Understanding how to add basic images such as PNGs as XNBs with the annoying work-around</li>
	<li>Creating a basic application that uses both XAML and DirectX</li>
	<li>Running MonoGame on Surface</li>
	<li>Communicating with a server using SignalR which runs on Mono, Apache and Linux!</li>
	<li>Wrapping it all together and porting the Tic-Tac-Toe client to a Windows 8 "XNA" Game that runs on Surface!</li>
</ul>

I probably forgot one or two things in the list above, but you get the point! We looked at some very interesting things and I think that you can take it from here and make some amazing cross platform games and not be limited by what server software you are running (read: this works on linux with Mono and Apache!).

<h3>Where can I get the code?</h3>
Don't worry, you can download the entire solution that I worked on <a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/12/TicTacToe.Windows8.MonoGame.zip">here</a>. Remember that a lot of the code is based on the other SignalR posts that I've done:

<ul>
<li>
<a href="http://blog.filipekberg.se/2012/11/29/introduction-to-signalr-creating-a-cross-platform-game/">Introduction to SignalR – Creating a Cross-Platform game</a>
</li>
<li>
<a href="http://blog.filipekberg.se/2012/12/10/running-signalr-on-mono/">Running SignalR on Mono</a>
</li>
</ul>

Don't forget to check out my screencast on SignalR, here it is again so you don't forget:

<div class="video-container">
<iframe width="640" height="360" src="http://www.youtube.com/embed/Zlm2atP8_RQ" frameborder="0" allowfullscreen></iframe>
</div>

I really hope that you enjoyed this post, I had a lot of fun writing it and if you have any questions, leave a comment, ping me on twitter, send me an e-mail or poke me on JabbR.
