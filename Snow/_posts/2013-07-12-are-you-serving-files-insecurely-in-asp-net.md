---
layout: post
title: Are You Serving Files Insecurely in ASP.NET
date: 2013-07-12 10:25
author: fekberg
comments: true
metadescription: Are You Serving Files Insecurely in ASP.NET?
categories: .NET, C#, Programming
tags: aspnet, csharp, security
---
I recently came across something quite interesting when it comes to serving files from your application. In theory what will be discussed here applies to all programming languages that you use for web programming and not only ASP.NET. However the examples used below will be targeted at ASP.NET developers.<!--excerpt-->

<h3>The scenario</h3>
Let's say that you have system where customers can logon to download their invoices. We're using ASP.NET MVC and the action that retrieves our list of invoices is quite simple, it looks like this:

    public ActionResult MyInvoices()
    { 
        // Get the file names from the persistent store
        var documents = new[] { "Filip_20130712.pdf", "Filip_20130713.pdf", "Filip_20130714.pdf" };

        return View(documents);
    }

In reality we would've fetched the document names from the database, or maybe even just fetching the invoice dates and concatenating the file names ourselves. The view that shows the user the list of invoices and lets the user download them is just as simple as the code fetching the documents:

    <h2>MyInvoices</h2>
    <ul>
        @foreach (var document in Model)
        { 
            <li><a href="/Home/DownloadDocument?document=@document">Download @document</a></li>
        }
    </ul>

This gives us the following beautiful website that shows a list of our invoices:

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/07/MyInvoices.png" alt="MyInvoices" width="462" height="496" class="alignright size-full wp-image-2017" />

Now let's take a look at the implementation of the method that lets us download the invoice. Here's how I want it to work:

<ul>
<li>Verify that the document requested exists on the server</li>
<li>Feed the document to the client</li>
</ul>

<strong>Simple enough, right?</strong>

Simply enough we can use `Server.MapPath` to get the current directory of our application and then use `Path.Combine` to ask for the document in our Invoices folder.

    public ActionResult DownloadDocument(string document)
    {
        var documentPath = Server.MapPath(Path.Combine("Invoices", document));

        if (!System.IO.File.Exists(documentPath))
        {
            return null;
        }

        return File(documentPath, "application/pdf", document);
    }

Now, if we run this application and navigate to <strong>/Home/MyInvoices</strong> we're going to see the list that we saw in the screenshot above. If we click the first document and request it and at the same time debug the application, we're going to see that it requests a file from  <strong>\Home\Invoices\</strong>. So far so good, right?

<h3>Security?</h3>
You might have already figured out that there's a huge security risk with the above demo, let's try something crazy. We know that it combines the text that we pass to the action with the current path, <em>what happens if we append some dots and slashes?</em>

Navigate to the following address:

    /Home/DownloadDocument?document=..\..\web.config

<strong>Do you see that this is a security risk now?</strong> Here's what just happened:

<img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/07/MyInvoices3.png" alt="MyInvoices3" width="810" class="alignright size-full wp-image-2019" />

<h3>How do you make it more secure?</h3>
Most important of all: don't use the data that the user requests directly to find the files on disk. Rather have an Id (Guid) passed to a method that looks up the file name in the database and the fetches that from your disk, this way the user never, ever, gets to decide where to download the data from.

<strong>So what did we learn from this?</strong>

Don't trust the data passed to your actions. This might be truly obvious to a lot of you, but I've seen this code in production code so think twice before you introduce insecurity in your applications.

I really want to hear your thoughts on this and maybe if you have any insecurity stories of your own!
