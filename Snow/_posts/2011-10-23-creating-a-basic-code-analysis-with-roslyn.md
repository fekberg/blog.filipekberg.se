---
layout: post
title: Creating a basic code analysis with Roslyn
date: 2011-10-23 00:38
author: fekberg
comments: true
metadescription: Analysing Code with Roslyn will allow you to create powerful extensions for visual studio.
categories: .NET, C#, Programming
tags: code analyzing, csharp, dotnet, parsing, roslyn
---
If you've installed the Roslyn CTP, you can go to the installation folder and look inside the Documentation folder, there's a lot of interesting information here that you can make use of. I've got my documentation here: 

    C:\Program Files (x86)\Microsoft Codename Roslyn CTP\Documentation

Now there's one document here that is a bit extra interesting, at least for me, it talks about how we can make basic code analysis with Roslyn ( How to Write a Quick Fix (CSharp).docx ). The basic idea is to identify whenever a variable can be made `const`. So for those of you that haven't had the time to download and install Roslyn yet, I'll show you how to do exactly that with the help of their sample. It's essentially the same outcome and code as they use in their documentation, but I will try explain a little bit more about each piece and add some extra things as well. But be sure to check out the documentation that comes with Roslyn as well!<!--excerpt-->

However, the sample in the document has an error to it so it doesn't run out of the box!

First thing is to open up an instance of Visual Studio and create a new Code Issue project, I'll call it MyFirstCodeIssueFix

<img src="https://cdn.filipekberg.se/fekberg-blog/creating-a-basic-code-analysis-with-roslyn/roslyn_code_fix_1.png" alt="" />

This project comes with some code already so that you can get started, but we're going to start looking at this from the beginning so let's remove everything in

    public IEnumerable<CodeIssue> GetIssues(IDocument document, 
                                            CommonSyntaxNode node, 
                                            CancellationToken cancellationToken)

<strong>Don't confuse it to the other override where the second argument is a `CommonSyntaxToken` and not `CommonSyntaxNode`!</strong>

The first thing that we have to do is that we have to check if the node is what we expect it to be:

    if (node.GetType() != typeof(LocalDeclarationStatementSyntax)) return null;

There is another way to do this though which is what they use in the documentation, in their example they restrict the entire class to only work with `LocalDeclarationStatementSyntax` like this:

    [ExportSyntaxNodeCodeIssueProvider("MyFirstCodeIssueFix", 
                                        LanguageNames.CSharp, 
                                        typeof(LocalDeclarationStatementSyntax))]

Using this will make it a bit faster, but for clearity I will not use it now. However when you have a lot of analyses going on you might want to break it all out and have one statement syntax per file. For instance, don't analyze using blocks and variables in the same file.

The reason we check for `LocalDeclarationStatementSyntax` is because, we want to see if it is a local variable. This method will be invoked for each different node in the source that we are analyzing, so we will se `UsingDirectiveSyntax` among a lot of others.

The next two things that we are going to do is to cast the node parameter to its correct type and then check if it is already a constant type, if it is we don't need to do anything at all with it

    var localDeclaration = (LocalDeclarationStatementSyntax)node;
    if (localDeclaration.Modifiers.Any(SyntaxKind.ConstKeyword)) return null;

Next up we will check if we can actually retrieve the code block surrounding the variable, so that we can actually analyze this block later on. Then we check if the variable actually has an initializer

    var containingBlock = localDeclaration.FirstAncestorOrSelf<BlockSyntax>();
    if (containingBlock == null) return null;

    if (localDeclaration.Declaration.Variables.Any(v => v.InitializerOpt == null)) return null;

Now we want to get the semantic model and this is fetched from the document argument that is passed to the method:

    var semanticModel = document.GetSemanticModel();

When we have the semantic model, we can get a little bit of information from it, in this case we want to see if the variable is initialized with a constant expression. This is done by selecting the actual value of the variable and see if the value is a compile time constant

    if (localDeclaration.Declaration.Variables
                        .Select(v => v.InitializerOpt.Value)
                        .Select(i => semanticModel.GetSemanticInfo(i))
                        .Any(info => !info.IsCompileTimeConstant))
    {
        return null;
    }

The next thing which is almost the last thing, is that we want to check if the variable is set to another value later down in the code, so to do this we need to analyze the code block after the current variable to see if it occurs more than once.

So we define the bounds for where we want to analyze:

    var analysisBounds = TextSpan.FromBounds(
        start: localDeclaration.Span.End,
        end: containingBlock.Span.End);

Note that if you were to set localDeclaration.Span.Start instead, we would include the current variable in the check and thus always have a true statement for our next test! So now we can create a data flow analyzer for this and search through it for any new occurrences of the variable like this:

    var dataFlowAnalysis = semanticModel.AnalyzeRegionDataFlow(analysisBounds);

    if (localDeclaration.Declaration.Variables
                        .Select(v => semanticModel.GetDeclaredSymbol(v))
                        .Any(s => dataFlowAnalysis.WrittenInside.Contains(s)))
    {
        return null;
    }

So by now we've completed the check and if we've come this far, there is an error, the variable can be made constant, so what we do now is we return an error saying what is wrong

    return new[]
    {
        new CodeIssue(CodeIssue.Severity.Warning, localDeclaration.Span,
            string.Format("{0} can be made constant", 
                          localDeclaration.Declaration.Variables.First().Identifier))
    };

<strong>How do we test this bad boy?</strong>, if you press F5 you'll get a new instance of Visual Studio 2010, this is exactly what we want. Now create a console application in this new instance and write the following in the main method:

    int x = 10;

And this is what you should see:

<img src="https://cdn.filipekberg.se/fekberg-blog/creating-a-basic-code-analysis-with-roslyn/roslyn_code_fix_2.png" alt="" />

Here's the entire `GetIssues` method:

    public IEnumerable<CodeIssue> GetIssues(IDocument document, 
                                            CommonSyntaxNode node, 
                                            CancellationToken cancellationToken)
    {
        if (node.GetType() != typeof(LocalDeclarationStatementSyntax)) return null;

        var localDeclaration = (LocalDeclarationStatementSyntax)node;
        if (localDeclaration.Modifiers.Any(SyntaxKind.ConstKeyword)) return null;

        var containingBlock = localDeclaration.FirstAncestorOrSelf<BlockSyntax>();
        if (containingBlock == null) return null;

        if (localDeclaration.Declaration.Variables.Any(v => v.InitializerOpt == null)) return null;

        var semanticModel = document.GetSemanticModel();

        if (localDeclaration.Declaration.Variables
                            .Select(v => v.InitializerOpt.Value)
                            .Select(i => semanticModel.GetSemanticInfo(i))
                            .Any(info => !info.IsCompileTimeConstant))
        {
            return null;
        }

        var analysisBounds = TextSpan.FromBounds(
            start: localDeclaration.Span.End,
            end: containingBlock.Span.End);

        var dataFlowAnalysis = semanticModel.AnalyzeRegionDataFlow(analysisBounds);

        if (localDeclaration.Declaration.Variables
                            .Select(v => semanticModel.GetDeclaredSymbol(v))
                            .Any(s => dataFlowAnalysis.WrittenInside.Contains(s)))
        {
            return null;
        }

        return new[]
        {
            new CodeIssue(CodeIssue.Severity.Warning, localDeclaration.Span,
                string.Format("{0} can be made constant", 
                              localDeclaration.Declaration.Variables.First().Identifier))
        };
    }

I hope you found this interesting, if you have any thoughts please leave a comment below!