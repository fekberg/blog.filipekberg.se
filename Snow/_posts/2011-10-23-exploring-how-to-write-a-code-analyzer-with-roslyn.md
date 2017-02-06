---
layout: post
title: Exploring how to write a code analyzer with Roslyn
date: 2011-10-23 21:47
author: fekberg
comments: true
metadescription: Exploring how to write a code analyzer with Roslyn
categories: .NET, C#, Programming
tags: code analyzing, csharp, dotnet, parsing, roslyn
---
In the previous post we looked at the documentation that came with Roslyn and how to create your first code analyzer. Now let's take this a step further and start refactoring the code and look for more errors. Start off by create a new solution, don't worry we're going to re-use bits of the code from the previous post, but in a refactored manner!<!--excerpt-->

I'll call my project FECodeAnalyzer

<img src="https://cdn.filipekberg.se/fekberg-blog/exploring-how-to-write-a-code-analyzer-with-roslyn/fecodeanalyzer.png" alt="" />

Then I am going to rename the `CodeIssueProvider` to `LocalDeclarationInspection` and remove the body of `GetIssues` and replace it with `return null;`

<img src="https://cdn.filipekberg.se/fekberg-blog/exploring-how-to-write-a-code-analyzer-with-roslyn/fecodeanalyzer_1.png" alt="" />

Now we are ready to start thinking about how the analyzer should work, I want my GetIssues method to ask members if certain critera's are followed or not. In this post I'll look at the two following:

<ul>
	<li>Can the variable be a constant value instead?</li>
	<li>Is the variable used somewhere in the context?</li>
</ul>

The first one is what we looked at in the previous post, but I want to do some changes and break it out from the GetIssues method. First of all, there's one thing that I mentioned in the previous post and this is how we determine that the Node actually is a LocalDeclarationStatementSyntax . I added an if statement to check if the type was what I wanted but it is a much faster way to add it to the class attribute `ExportSyntaxNodeCodeIssueProvider` instead like this:

    [ExportSyntaxNodeCodeIssueProvider("FECodeAnalyzer",
                                    LanguageNames.CSharp,
                                    typeof(LocalDeclarationStatementSyntax))]

Since I want to delegate the work from GetIssues and check if my current node follows up on all the critera's that I require, I want to do some initial initialization of variables that I will pass to the methods. So this is what I want to limit to GetIssues:

<ul>
	<li>Have a `List<CodeIssue>` that we want to fill with errors</li>
	<li>Load the semantic model so we don't need to pass the document around</li>
	<li>Load the containing block and return null if there is none</li>
	<li>Measure the analysis bounds</li>
	<li>Create a data flow analysis, we don't want to do this over and over again.</li>
</ul>

So this will look somewhat like this:

    List<CodeIssue> issues = new List<CodeIssue>();
    var localDeclaration = (LocalDeclarationStatementSyntax)node;
    var semanticModel = document.GetSemanticModel();
    var containingBlock = localDeclaration.FirstAncestorOrSelf<BlockSyntax>();

    if (containingBlock == null) return issues;

    var analysisBounds = TextSpan.FromBounds(
                                start: localDeclaration.Span.End,
                                end: containingBlock.Span.End);
    var dataFlowAnalysis = semanticModel.AnalyzeRegionDataFlow(analysisBounds);

A side note here is that Roslyn don't support yield returns yet, so that is why I declare and initialize a List of issues to return. Now the next thing I want to create here is a method to check if the variable can be made constant or not, this is my method signature for it:

    private bool CanBeConst(LocalDeclarationStatementSyntax localDeclaration,
                            ISemanticModel semanticModel,
                            IRegionDataFlowAnalysis dataFlowAnalysis)

I can almost take the code from the previous sample with a small amount of modifications, instead of returning null, I am returning false and the last return is a true instead of a code issue object. Like this:

    private bool CanBeConst(LocalDeclarationStatementSyntax localDeclaration,
                            ISemanticModel semanticModel,
                            IRegionDataFlowAnalysis dataFlowAnalysis)
    {
        if (localDeclaration.Modifiers.Any(SyntaxKind.ConstKeyword)) return false;

        if (localDeclaration.Declaration.Variables.Any(v => v.InitializerOpt == null)) return false;

        if (localDeclaration.Declaration.Variables
                            .Select(v => semanticModel.GetDeclaredSymbol(v))
                            .Any(s => dataFlowAnalysis.WrittenInside.Contains(s)))
        {
            return false;
        }
        if (localDeclaration.Declaration.Variables
                            .Select(v => v.InitializerOpt.Value)
                            .Select(i => semanticModel.GetSemanticInfo(i))
                            .Any(info => !info.IsCompileTimeConstant))
        {
            return false;
        }

        return true;
    }

This means that I can write something like this is GetIssues:

    if (CanBeConst(localDeclaration, semanticModel, dataFlowAnalysis))
    {
        issues.Add(new CodeIssue(CodeIssue.Severity.Warning,
                                localDeclaration.Span,
                                string.Format("{0} can be made constant", 
                                localDeclaration.Declaration.Variables.First().Identifier)));
    }

This is pretty similar to the previous post, except that we are not clotting GetIssues with a lot of code. Also I can now add more issues to the iterator! So next up I want to check if the variable is used somewhere in the context, the context being the analysis bounds.

Consider this code where x is being unused:

    int x = 10;
    x = 20;

As long as x is not used anywhere(read) it will be considered unused! So we can ask our data flow analysis for all reads that are inside the analysis bounds and we want to search for the local declarations variable, this can be done like this:

    dataFlowAnalysis.ReadInside.Contains(
        semanticModel.GetDeclaredSymbol(localDeclaration.Declaration.Variables.First()))

So the method that I want to have for checking for unused variables can look somewhat like this:

    public bool IsNeverUsed(LocalDeclarationStatementSyntax localDeclaration, 
                            ISemanticModel semanticModel, 
                            IRegionDataFlowAnalysis dataFlowAnalysis)
    {
        if (dataFlowAnalysis.ReadInside.Contains(
                semanticModel.GetDeclaredSymbol(localDeclaration.Declaration.Variables.First()))
            )
            return false;

        return true;
    }

Which means that in my GetIssues method I can add the following to check if the node is unused and then add an error message:

    if (IsNeverUsed(localDeclaration, semanticModel, dataFlowAnalysis))
    {
        issues.Add(new CodeIssue(CodeIssue.Severity.Warning,
                                    localDeclaration.Span,
                                    string.Format("Variable {0} is declared but never used", 
                                    localDeclaration.Declaration.Variables.First().Identifier)));
    }

As you can see this is quite modular at the moment, we can add more of these checks to correspond with our rules! The last thing we do in the GetIssues method is to return the issue list. So all the methods will end up looking like this:

    private bool CanBeConst(LocalDeclarationStatementSyntax localDeclaration,
                            ISemanticModel semanticModel,
                            IRegionDataFlowAnalysis dataFlowAnalysis)
    {
        if (localDeclaration.Modifiers.Any(SyntaxKind.ConstKeyword)) return false;

        if (localDeclaration.Declaration.Variables.Any(v => v.InitializerOpt == null)) return false;

        if (localDeclaration.Declaration.Variables
                            .Select(v => semanticModel.GetDeclaredSymbol(v))
                            .Any(s => dataFlowAnalysis.WrittenInside.Contains(s)))
        {
            return false;
        }
        if (localDeclaration.Declaration.Variables
                            .Select(v => v.InitializerOpt.Value)
                            .Select(i => semanticModel.GetSemanticInfo(i))
                            .Any(info => !info.IsCompileTimeConstant))
        {
            return false;
        }

        return true;
    }
    public bool IsNeverUsed(LocalDeclarationStatementSyntax localDeclaration, 
                            ISemanticModel semanticModel, 
                            IRegionDataFlowAnalysis dataFlowAnalysis)
    {
        if (dataFlowAnalysis.ReadInside.Contains(
                semanticModel.GetDeclaredSymbol(localDeclaration.Declaration.Variables.First()))
            )
            return false;

        return true;
    }
    public IEnumerable<CodeIssue> GetIssues(IDocument document, 
                                            CommonSyntaxNode node, 
                                            CancellationToken cancellationToken)
    {
        List<CodeIssue> issues = new List<CodeIssue>();
        var localDeclaration = (LocalDeclarationStatementSyntax)node;
        var semanticModel = document.GetSemanticModel();
        var containingBlock = localDeclaration.FirstAncestorOrSelf<BlockSyntax>();

        if (containingBlock == null) return issues;

        var analysisBounds = TextSpan.FromBounds(
                                    start: localDeclaration.Span.End,
                                    end: containingBlock.Span.End);
        var dataFlowAnalysis = semanticModel.AnalyzeRegionDataFlow(analysisBounds);

        if (CanBeConst(localDeclaration, semanticModel, dataFlowAnalysis))
        {
            issues.Add(new CodeIssue(CodeIssue.Severity.Warning,
                                    localDeclaration.Span,
                                    string.Format("{0} can be made constant", 
                                    localDeclaration.Declaration.Variables.First().Identifier)));
        }

        if (IsNeverUsed(localDeclaration, semanticModel, dataFlowAnalysis))
        {
            issues.Add(new CodeIssue(CodeIssue.Severity.Warning,
                                        localDeclaration.Span,
                                        string.Format("Variable {0} is declared but never used", 
                                        localDeclaration.Declaration.Variables.First().Identifier)));
        }

        return issues;
    }

And when debugging this ( by pressing F5 ), we can see the errors like this in a console application when the variable is both unused and can be made constant:

<img src="https://cdn.filipekberg.se/fekberg-blog/exploring-how-to-write-a-code-analyzer-with-roslyn/fecodeanalyzer_2.png" style="width: 800px;" alt="" />

And look like this when the variable is not possible to make constant but is unused:

<img src="https://cdn.filipekberg.se/fekberg-blog/exploring-how-to-write-a-code-analyzer-with-roslyn/fecodeanalyzer_3.png" style="width: 800px;" alt="" />

I hope you found this interesting, if you have any thoughts please leave a comment below!


