---
layout: post
title: Over-engineering trivial tasks can be challenging and educating
date: 2011-06-01 13:42
author: fekberg
comments: true
metadescription: Over-engineering trivial tasks can be challenging and educating
categories: .NET, Architecture, C#
tags: .NET, .net 4.0, Programming, programming architecture
---
It's been almost six months since my last blog post here, it's not like I don't have anything to write, but the time I have over at the end of the day just doesn't end up so that I have time to write here. I'll try to get some more time to write here since I really do have a lot of interesting things that I want to share!<!--excerpt-->

Lately I've seen a bunch of questions over at StackOverflow that is quite trivial, at least trivial to us that work with these kinds of things on a day to day basis. My example here is from the question "<a href="http://stackoverflow.com/questions/6198274/how-to-read-all-the-subdirectories-in-a-given-destination-which-contain-master-fi/6198411#6198411" target="_blank">how to read all the subdirectories in a given destination..</a>" as I see it, there are a lot of different ways that you can solve this but no matter how trivial this problem is, you can always over-engineer it. So when I first saw this question I immediately started to think about interesting ways to solve this.

One of the possible solutions could be to get a directory list of the parent folder and use parallel extensions to recursively scan each folder to speed up the process a bit. The traversing method signature could also contain an action / delegate that are used when the given file you are looking for is found.

However, this does not completely solve the given task, the person asking the question wants the following requirements:
<ul>
	<li>Start looking for the ABC file in the parent directory</li>
	<li>If there is no ABC file, go on to the next subfolder</li>
	<li>If it is not in the subfolder, move on to the next one.... and so forth..</li>
	<li>Once a file is found, process the file</li>
</ul>
It is however not stated if the scanning should continue after the first file is found. Do you see where I am getting at? When you open to door to allow different interpretations of your problem, a lot of us that see interesting challenges in everything start to think about how we can effectively make this reusable and optimized.

Over-engineering a trivial problem can actually lead to something good, you might get optimized and reusable code!

One of the solutions presented was actually pretty cool, there's something called "LINQ to File System" which will let you create a query and ask for these files, and you can use the built in System.IO.DirectoryInfo directly to ask for a certain file-pattern. But neither of these lets you process the file In-Place. What I mean about In-Place is to process it once you've found it and not after you've found it.

My final solution ended up being a recursive method that just takes a path; this was to give the trivial question a trivial answer.

  void TraverseDirectory(string directory)
  {
      var currentDirectory = new DirectoryInfo(directory);

      foreach(var dir in currentDirectory.GetDirectories())
      {
             var currentPath = dir.FullName;

             TraverseDirectory(currentPath);

             var pathToMasterFile = Path.Combine(currentPath, "Master");

             if (File.Exists(pathToMasterFile))
                 DoSomethingWithMaster(pathToMasterFile);
      }
  }

Even though this problem was initially trivial, if we want to, we can make it very complex, challenging and educating. For instance, it's been a while since I created something interesting with Delegates/Actions/Tasks so why not elaborate this a bit and make the result a bit more interesting?

You can always make trivial problems into something fun, exiting, educating and challenging! You just need to put your mind into it. Mainly I just want to say to all developers out there that are stuck with trivial tasks that they find a bit boring; you can make so much more out if it!
