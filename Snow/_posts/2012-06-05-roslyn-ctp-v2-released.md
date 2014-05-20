---
layout: post
title: Roslyn CTP v2 Released
date: 2012-06-05 19:22
author: fekberg
comments: true
metadescription: Roslyn CTP v2 Released and available to download
categories: .NET, C#, Programming
tags: csharp, dotnet, roslyn, visual studio, vs2012, vs2012 sdk
---
You can now <a href="http://www.microsoft.com/en-us/download/details.aspx?id=27746">download and install</a> a new version of the Roslyn CTP. The Roslyn CTP is now compatible with Visual Studio 2012 RC for this you will need to <a href="http://www.microsoft.com/en-us/download/details.aspx?id=29930">download and install Microsoft Visual Studio 2012 RC SDK</a>!<!--excerpt-->

<strong>Installing Visual Studio 2012 RC SDK</strong>
<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/06/1.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/06/1.png" alt="" title="Installing Visual Studio 2012 RC SDK" width="460" height="600" class="aligncenter size-full wp-image-862" /></a>

<strong>Installing Roslyn CTP v2</strong>
<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/06/2.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/06/2.png" alt="" title="Installing Roslyn CTP v2" width="495" height="310" class="aligncenter size-full wp-image-863" /></a>

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/06/21.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/06/21.png" alt="" title="Installation of Roslyn CTP v2 complete" width="495" height="310" class="aligncenter size-full wp-image-864" /></a>

<strong>Testing Roslyn in Visual Studio 2012 RC</strong>
When the installation has finished, you can start Visual Studio 2012 and create a Roslyn Console Application:

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/06/3.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/06/3.png" alt="" title="Creating a Roslyn Console Application" width="800" height="456" class="aligncenter size-full wp-image-865" /></a>

Then we can create a simple `ScriptEngine` that just executes a snippet:

	var engine = new ScriptEngine();
	var result = engine.Execute<bool>("var x = 10; x == 0");

	Console.WriteLine(result);

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/06/4.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/06/4.png" alt="" title="Executing a code snippet with Roslyn" width="864" height="579" class="aligncenter size-full wp-image-867" /></a>

I tried upgrading the <a href="https://github.com/fekberg/Roslyn-Hosted-Execution">code </a>from the my previous post on "<a href="http://blog.filipekberg.se/2011/12/08/hosted-execution-of-smaller-code-snippets-with-roslyn/">Hosted code execution</a>" and it seems to only be minor changes that are needed. These were the only errors:

<ul>
	<li>The constructor for `CompilationOptions` takes less parameters ( no longer a lot of optional parameters )</li>
	<li>`ParseOptions` no longer has a constructor defined, use `CompilationOptions.Default`</li>
	<li>`ObjectFormatter` no longer has a constructor defined, use `ObjectFormatter.Instance`<li></ul>

There are most likely a lot of other changes made, but these are the ones that broke the build of "<a href="http://blog.filipekberg.se/2011/12/08/hosted-execution-of-smaller-code-snippets-with-roslyn/">Hosted code execution</a>".

<a href="http://social.msdn.microsoft.com/Forums/en-US/roslyn/thread/2341e1f5-ce2e-48ff-93d6-bdd1bdbabd81">See a list of API Changes here.</a> The post also lists the new language features implemented since CTP1 (C#):

<ul>
	<li>Anonymous Types
</li>
	<li>Attributes (full support)
</li>
	<li>Base call support
</li>
	<li>Checked and unchecked expressions and blocks
</li>
	<li>Events
</li>
	<li>Finalizers</li>

	<li>Generic constraints
</li>
	<li>Implicitly-typed arrays
</li>
	<li>Indexers</li>

	<li>Iterators</li>

	<li>Lock statements
</li>
	<li>Named and optional parameters
</li>
	<li>Param array parameters
</li>
	<li>Partial methods
</li>
	<li>Operator overloading
</li>
	<li>Query expressions
</li>
	<li>Switch statements
</li>
	<li>User-defined conversions
</li>
	<li>Using statements
</li>
	<li>Volative fields</li>
</ul>