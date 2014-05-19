---
layout: post
title: A work around to the memory leaks in NSXMLParser
date: 2010-11-30 15:22
author: fekberg
comments: true
metadescription: A work around to the memory leaks in NSXMLParser
categories: Objective-C, Programming
tags: ios, ios 4, iphone sdk, Memory leaks, NSXMLParser, objective-c
---
Lately I've experimenting a bit with parsing XML in Objective-C and discovered something that I'd like to share with you all.

First of all, consider the following "standard" way of downloading an XML and parsing it<!--excerpt-->

	NSXMLParser *parser = [[NSXMLParser alloc] 
				initWithContentsOfURL: [NSURL 
				URLWithString:@"http://some-xml-url.com/my.xml"]];

You would think that this line of code is Solid, all it's supposed to do is download the content, release the temporary resources for fetching data and store the final content for the parsing later on. However somewhere in the process there's a resource that isn't cleaned up properly and you will get a memory warning the "Build and Analyze" method wont find it but when you run the application with a Performance tool looking for leaks you will end up getting something like this:

<strong>Leaked Object</strong>
Malloc 512 Bytes

<strong> Responsible Frame</strong>
allocateCollectableUnscannedStorage<strong> </strong>

<strong>Leaked Object</strong>
NSConcreteMapTable<strong> </strong>

<strong>Responsible Frame</strong>
+[NSMapTable alloc]<strong> </strong>


I tried a lot of suggestions to fix this issue some of them being to set the sharedURLCache to 0 like this:

	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];

These alone did not solve the problem, so on the quest to find a proper work around I came up with this <strong>solution:</strong>

	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];

	NSData *xml = [NSData 
			dataWithContentsOfURL: [NSURL 
			URLWithString:@"http://some-xml-url.com/my.xml"]];

	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xml];;

And that did it, after this I no longer received any memory warnings.
