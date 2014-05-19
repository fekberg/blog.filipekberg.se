---
layout: post
title: Use Test Driven Development to verify that the code will Always work!
date: 2010-04-23 13:51
author: fekberg
comments: true
metadescription: Use Test Driven Development to verify that the code will Always work!
categories: .NET, C#, Programming
tags: .NET, .net 4.0, csharp, LINQ
---
After attending Scandinavian Developer Conference in Sweden 2010 and attending the talk from Roy Osherove ( <a href="http://osherove.com/">http://osherove.com/</a> ) Test Driven Development ( TDD ) has been something that I have tried to focus a bit more on.<!--excerpt-->

Roy talks about some really important aspects of programming that should be printed into the programmers brain. I for instance is one of these people that like to verify everything that I do; Did I <strong>Really </strong>lock the door? So when I've turned the keys in the lock, I verify that the locking mechanizm worked and that the door is no indeed locked.

<strong>So what does my weird habbit have to do with TDD?</strong>

Driving the development with tests is not the only part of TDD; as with anything else there are a lot of people that like to think a lot of different things about this method. I like to think of tests as a way to Verify that my code runs as expected.

<strong>This is not a case of miss-trust!</strong>

Don't missunderstand the above as see me as someone that does't trust anyone or anything created by others than myself, that's not the case. But by verifying that things runs properly, the door is properly locked I know that everything is OK from my part in the scenario.

What if I didn't run the tests on the code and handed it over to the next developer that Did not in fact know that the method he works in affects everything else? And what if I didn't verify the lock; I was in a big hurry and someone just went into the appartment and stole my TV?

In my opinion, test driven development is way to:
<ul>
	<li>Verify that Code runs as it should</li>
	<li>Decrease mistakes in the future</li>
	<li>Help others gain knowledge of parts in the code faster</li>
</ul>
To take the locking mechanizm-checking even further and really turn it into something that is Driven you can follow these three very simple steps that Roy also talks about in his speeches:
<ul>
	<li>Make it fail</li>
	<li>Make it work</li>
	<li>Make it better</li>
</ul>
How do you make the lock fail to lock? Well you simply <strong>Don't lock it!</strong>

So let's head over to the development aspect of this, you want to make your code fail? No code means it will fail right? When I do this step 1 and 2 always go together, especially when I demo TDD for co-workers or others. I will use the same good example as Roy used in his demo on SDC 2010, let's try to put our heads around a simple Calculator project.

<strong>Defining the requirements</strong>

For this "project" we only have fourrequirements:
<ul>
	<li>A method called Sum</li>
	<li>This method parses a String</li>
	<li>This method should return String.Empty when you pass Invalid or Empty data</li>
	<li>Adds two integers in the String together "1 1" would be 2</li>
</ul>
So if we follow the above we would end up with a test that looks like the following:

	[TestMethod]
	public void Sum_EmtpyString_ReturnsZero()
	{
		var calculator = Calculator.GetInstance();
		var actual = calculator.Sum("");
		var expected = string.Empty();

		Assert.AreEqual(expected, actual);
	}

Since we haven't really implemented Calculator, GetInstance or Sum yet, we made it fail, there is no Code. Visual Studio helps us out a bit and makes the process a bit faster, by simply pressing alt + enter when selecting Calculator or Sum we can select to create the Class and create the Method Stub.

So we actually finished both Step 1 and Step 2 at the same time, even though Step 2 isn't complete yet, we are nearly there!

Now we need to make it work, what is the simpliest way possible to make it work for the above test-case?

	public string Sum(string input)
	{
		return string.Emtpy();
	}

This will actually work and it will indeed check this test as Passed. But it's not really what we want. So how do we proceed?

Another Great point Roy pointed out is that, if there isn't a test, there's no code and if there's code there's gotta be a test! And if one test passes and you want to Change the code to behave different with other input; You need to prove it with a test!

So we can test if `Sum("1")` will return 1, which we from looking at the code will see that it wont!

	public void Sum_ValueContainsADigit_ReturnTheDigitThatIsPassed()
	{
		var calculator = Calculator.GetInstance();
		var actual = calculator.Sum("1");
		var expected = "1";

		Assert.AreEqaul(expected, actual);
	}

This test will most defently fail because of our implementation! So we need to go back to Sum and change this method.

Once all tests passes and the test case is approved, we head on to the next step, which is <strong>make it better</strong>! In other wors we need to refactor some code! Try to follow these steps to refactor ( i use ReSharper, which is a Great tool! ).
<ul>
	<li>Move the Library to an appropriet Class Library / Project</li>
	<li>Optimize the code</li>
	<li>Refactor your test to look better</li>
	<li>Comment the code</li>
</ul>
So you got a little peek at what TDD is and how it can be used, if everyone would use TDD, it would be so much easier to take on new projects that have already been started. You never know what your changes will impact on.
