---
layout: post
title: Making code more readable with anonymous functions
date: 2011-10-05 19:34
author: fekberg
comments: true
metadescription: Readable code is very important for maintainability, using anonymous functions will help you improve readability in your C# applications.
categories: .NET, C#, Programming
tags: csharp, csharp 4, dotnet
---
If you come from a world filled with JavaScript you might be used to seeing the click handler logic defined at the same place as where you defined the click handler itself. For instance, look at this code:

	$("#submit").click(function(){
	    performPostAndRedirect();
	});

I think it's safe to say that this kind of code is very usual and that it's nothing wrong with it, in fact, it's easy to read and easy to understand and for me readability is something that is very important.<!--excerpt-->

So how does this apply to C# development?

Look at the following code from a WPF-application:

	var button = new Button();

	button.Click += new RoutedEventHandler(button_Click);

This can be simplified a little bit, you actually don't need to write the "newRoutedEventHandler"-part and nowdays you can just write:

	button.Click += button_Click

Now this indicates that we have a method called button_Click that looks somewhat like this:

	void button_Click(object sender, RoutedEventArgs e)
	{
	    throw new NotImplementedException();
	}

In most of the cases that I've seen, you don't want to do any actual logic inside the event-handler anyways, you might just want to fire off a method that starts off some task for you, or validate data. But this is rarely done inside the event handler itself, at least it shouldn't be.

So, how can we make this easier on the eyes and just navigate to the Click event assignment and get a feeling of what is happening?

By using anonymous functions!

First of all you can write something like this:

	button.Click += (object sender, RoutedEventArgs e) => { ValidateInput(); };

This can be simplified though and end up like this:

	button.Click += (sender, e) => { ValidateInput(); };

Even if you do more than one method-call in the event handler (when using anonymous functions) I think this is a pretty nice approach, it's less lines and you get an idea of what actually happens by just looking at that line of code. You don't have to navigate down to the event-handler itself to see what's going on.

This isn't the only way you can use anonymous functions though, I use it frequently when I create new tasks like this:

	Task.Factory.StartNew(() =>
	                            {
	                                PerformTimeConsumingOperation();
	                                ValidateOperation();
	                            });
	                            
Again, I think it would be redundant to do otherwise, to have a separate method that you call to actually start the real work, this is less code and more readable! At least in my eyes.

I hope you found this interesting and if you have any thoughts please leave a comment below!
