---
layout: post
title: Displaying a loading indicator for UIWebView using UIActivityIndicatorView
date: 2010-12-01 09:50
author: fekberg
comments: true
metadescription: Displaying a loading indicator for UIWebView using UIActivityIndicatorView
categories: Objective-C, Programming
tags: ajax-loader, ios, ios 4, iphone sdk, UIActivityIndicatorView, UIWebView
---
More and more apps today uses only the native application as a shell around their web-based application to get their app into App Store. A drawback with doing this is that you might get really annoying load times and you have to decide where to put the "wait for the data"-scene.<!--excerpt-->

In my opinion you have two alternatives
<ul>
	<li>Either you load all data in the App Delegate and have the Default.png shown untill all data is downloaded</li>
	<li>Or you can start the loading in the App Delegate and not wait for it to finish and display a loading indicator once the application finished loading.</li>
</ul>
I've evaluated both of these methods and find that the second one enhanced the feeling of the application, no one accepts to wait for 5 seconds before an application is somewhat interactive.

Therefore I'll show how to add a Loading indicator using the UIActivityIndicatorView.

You need to declare the `UIActivityIndicatorView` in your header file so it is accessable from all delegate methods.

	UIActivityIndicatorView *loadingIndicator;

Then you need to initiate a `UIActivityIndicatorView` like this:

	loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 190, 20,20)];
	[loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
	[loadingIndicator setHidesWhenStopped:YES];

The first line allocates the resources for a UIActivityIndicatorView and the initializes it and puts it in the center of the screen, this is in<strong> landscape mode</strong>.

After that we set the style to gray and tell it to dissapear when we stop the animation. You can choose between three different color-schemes for this indicator. Check the apple developer reference for more information about that.

Now you are ready to add the loading indicator to you web view like this:

	[webView addSubview:loadingIndicator];

I take for granted that you have a web view that's called webView and that it has `webView.delegate = self;`. So that you can use the delegate methods to start and stop the loading indicator animation.

Now we are at the final step of the journey to get a loading indicator to our web view in the `-(void)webViewDidStartLoad:(UIWebView *)webView` delegate method we add the following:

	[loadingIndicator startAnimating];

This will start the spinning loader inside the Web View, now to remove it, go to your delegate method for `-(void)webViewDidFinishLoad:(UIWebView *)webView` and add the following:

	[loadingIndicator stopAnimating];

And you are all set! Now you should have a loading animation that displays a spinning wheel as long as the data loads.
