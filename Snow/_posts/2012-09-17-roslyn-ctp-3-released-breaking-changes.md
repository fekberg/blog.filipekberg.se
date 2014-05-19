---
layout: post
title: Roslyn CTP 3 released -- breaking changes
date: 2012-09-17 22:08
author: fekberg
comments: true
metadescription: The next version of the Roslyn CTP, Roslyn CTP3, has been released and it has some breaking changes!
categories: .NET, C#, Programming
tags: breaking changes, c# smorgasbord, roslyn, roslyn ctp, roslyn ctp3
---
<div style="width: 259px; margin: 0 auto;"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/09/breakingchains.jpg" alt="" title="breakingchains" width="259" height="194" class="aligncenter size-full wp-image-1095" /></div>

Microsoft has released yet another CTP version of Roslyn and this doesn't come as a big surprise. Since the previous CTP (CTP2) does not work very well with Visul Studio 2012. Now with Roslyn CTP3, we have Visual Studio 2012 support! However, this upgrade does come with a price, there are some breaking changes in the third version of the Roslyn CTP.<!--excerpt-->

<a href="http://www.microsoft.com/en-us/download/details.aspx?id=34685">You can download the latest Roslyn CTP3 here.</a>

This unfortunately breaks some code samples in my book C# Smorgasbord, but not to worry. The changes are pretty easy to figure out and I've put together an Errata that covers all the code samples that are affected by the breaking changes.

<a href="http://books.filipekberg.se/Errata">You can find the Errata here.</a>

If you're using Visual Studio and you have intellisense enabled, it's going to be pretty easy to figure out what has changed. Below is a short list of what I've found and what is in the Errata.

<h3>No longer possible to run Scripts through ScriptEngine directly</h3>
To execute a snippet you need to create a session first, like this:

	var engine = new ScriptEngine();
	var session = engine.CreateSession();
	var result = session.Execute("var x = 10; x");

	Console.WriteLine(result);

<h3>ParseCompilationUnit is removed</h3>
You can now use `ParseText` and `ParseFile` instead.

<h3>The auto generated GetIssue method has changes.</h3> 
When creating a Code Issue project, the generated file is changed a bit. Instead of `GetText()` on the token, you now use `ToString()` and instead of `CodeIssue.Severity.Warning` you use `CodeIssueKind.Warning`.

<h3>Method AnalyzeStatementDataFlow is renamed</h3>
The method `AnalyzeStatementDataFlow` on `SemanticModel` has been renamed to `AnalyzeDataFlow()`.

There are probably a lot more changes to Roslyn than the ones listed above.

If you have any questions regarding the code samples in C# Smorgasbord or if you want to chat about Roslyn, leave me a comment or an e-mail. Even though these are breaking changes, it does not ruin the reading expreience of C# Smorgasbord!