---
layout: post
title: Getting started with a Mocking Framework
date: 2012-01-30 19:44
author: fekberg
comments: true
metadescription: How you can get started with a Mocking Framework in .NET by using Simple.Mocking
categories: .NET, C#, Programming
tags: csharp, dotnet, mocking, mocking framework, simple.mock, simple.mocking, simple.net, tdd, test driven development, testing
---
In previous articles we've looked at how to increase code quality by either introducing test drive development for new features or using inversion of control. There are of course many other aspects that come into play when you want to reach high-quality code and this article is going to introduce you to mocking that will help you along the way.

You might have come across the word "mock" before, when for instance a UI designer for a Windows Phone application on your team puts together a picture of how the application might look when it is finished: Where do the buttons go? What text might be displayed when the button is pressed?<!--excerpt-->

The word "mock" means to fake something, which is exactly what we want to do here; we want to fake the layout to give the customer an idea of how the application will look or how it will behave. On the rare occasions that I need to do UI mocks I use a tool called <a href="http://www.balsamiq.com/" target="_blank">Balsamiq</a> and the mockups for a phone application can end up looking as simple as this:

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/balsamiq.png"><img style="display: inline;" title="balsamiq" src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/balsamiq_thumb.png" alt="balsamiq" width="314" height="537" /></a>

There are techniques for mocking things in the real world as well, an example of this is when you want to build a house, you might first want to see a small scale model before you decide to go with it; this is mocking!

<strong>How does this apply to programming?</strong>

As we've concluded mocking is about faking either a thing or a behavior and in our code it is of course a behavior that we want to fake/impersonate. In the article about <a href="http://filipekberg.se/2011/12/20/adapting-to-inversion-of-control-and-dependency-injection/" target="_blank">IoC and DI</a> I talked about breaking things apart from each other by using interfaces, this is going to help us out a lot with the mocking as well.

Let us assume that we have a system that handles payments and our different payment providers use a shared interface called `IPaymentProvider`. Then we have something that handles the processing of all the payments through the different payment providers let us assume that this class is called `Payment` and the constructor of `Payment` takes an `IPaymentProvider`.

This class has only one purpose and it is to withdraw money from the customers account. This class resides in a Test project using MS Test. Although that it has one purpose only there are some parameters that will affect the result of the payment execution. In our scenario we the `IPaymentProvider` will look like this:

    public interface IPaymentProvider
    {
        bool Reserve(decimal amount);
        bool Execute(decimal amount);
    }

The `Payment` class takes a payment provider in the constructor and uses Reserve and Execute in a certain way in its own execution method:

    public class Payment
    {
        private IPaymentProvider _provider;
        public Payment(IPaymentProvider provider)
        {
            _provider = provider;
        }

        public bool Execute(decimal amount)
        {
            // Implementation goes here...
        }
    }

The actual execution of a purchase will require us to first Reserve the amount of money we want to withdraw and if that is possible, we can execute the payment and finalize it. This means that our Execute method will end up looking something like this

    public bool Execute(decimal amount)
    {
        if (!_provider.Reserve(amount))
            return false;

        if(!_provider.Execute(amount))
            return false;

        return true;
    }

Even though we have the actual code in front of us, it is not important! What is important is that we just understand that we first need to reserve the amount and then if that succeeds we execute the payment which finalizes the process.

We've looked almost all parts of the system, but where is the implementations of the `IPaymentProvider`? 

<strong>Let's assume we don't have it!</strong> Even though we don't have access to the implementation at this time (maybe we haven't made it quite yet, we might not even know what payment providers we are implementing the system against) we still want to test the process of the Execute method, we want to assure that no exceptions are thrown and that based on a Reservation that did not go through, we don't want it to go any further.

In the article on <a href="http://filipekberg.se/2011/12/20/adapting-to-inversion-of-control-and-dependency-injection/" target="_blank">IoC and DI</a> we talked about introducing fakes by creating "dumb" implementations that only did what we asked of them. This is indeed one way to go but let us take a look at another approach of this. Let's look at a Mocking Framework!

There are a lot of mocking frameworks out there for .NET, here are two that are very good (among many many others):

<ul>
	<li><a href="http://code.google.com/p/moq/">moq</a></li>
	<li><a href="http://code.google.com/p/fakeiteasy/">FakeItEasy</a></li>
</ul>

But I've decided to go with <a href="http://simpledotnet.codeplex.com/releases/view/50837" title="Simple Mocking" target="_blank">Simple.Mocking</a>. We can install this with <a href="http://nuget.codeplex.com/" target="_blank">NuGet</a>, this is how the test-project I've created look like before I use NuGet to install Simple.Mocking:

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/Getting-started-with-a-Mocking-Framework-Microsoft-Visual-Studio-Administrator-22.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/Getting-started-with-a-Mocking-Framework-Microsoft-Visual-Studio-Administrator-22.png" alt="" title="Getting started with a Mocking Framework - Microsoft Visual Studio (Administrator) (2)" width="797" height="796" class="alignnone size-full wp-image-586" /></a>

Now fire up the nuget manager and write:

    PM> Install-Package Simple.Mocking

And you should see something like this:

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/Getting-started-with-a-Mocking-Framework-Microsoft-Visual-Studio-Administrator-3.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/Getting-started-with-a-Mocking-Framework-Microsoft-Visual-Studio-Administrator-3.png" alt="" title="Getting started with a Mocking Framework - Microsoft Visual Studio (Administrator) (3)" width="796" height="796" class="alignnone size-full wp-image-588" /></a>

<strong>Now we're ready to start mocking!</strong>

There are a couple of important parts in Simple.Mocking that we're going to cover now, the first one is: How do we fake an instance of our `IPaymentProvider`?

Start off by adding a reference to the framework by adding this to the top of the file:

    using Simple.Mocking;

Now, there's a class we can access called `Mock` here we've got two different methods that will let us do two things:

<ul>
	<li>`Mock.Interface` will let us fake an implementation of our interface as if we had a real implementation.</li>
	<li>`Mock.Delegate` will let us fake a delegate, we won't be looking in to this anything in this article.</li>
</ul>

Of these two we will only concentrate on `Mock.Interface`. You easily fake/mock an implementation by doing this:

    var provider = Mock.Interface<IPaymentProvider>();

<strong>Is this it?</strong> No, it's not! We've still got a path to wander before we've reached our final destination. If we check what methods we have on the variable `provider` this is what we got:

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/Getting-started-with-a-Mocking-Framework-Microsoft-Visual-Studio-Administrator-4.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/Getting-started-with-a-Mocking-Framework-Microsoft-Visual-Studio-Administrator-4.png" alt="" title="Getting started with a Mocking Framework - Microsoft Visual Studio (Administrator) (4)" width="796" height="796" class="alignnone size-full wp-image-592" /></a>

So what happens if we run the following code:

    var provider = Mock.Interface<IPaymentProvider>();
    provider.Execute(100);

It does look valid, doesn't it? The problem here is that the method Execute has not idea of how it should behave so it will raise an exception. Because it expects us to define a behavior for it before we proceed. This brings us to the next interesting object that we are going to take a look at that comes with Simple.Mocking; `Expect`!

Almost all the methods on the `Expect` type takes an expression of type `Action` or `Func<T>`, at least the ones we are interested in at the moment. These are the most commonly used methods:

<ul>
	<li>`Expect.MethodCall`</li>
	<li>`Expect.PropertyGet`</li>
	<li>`Expect.PropertySet`</li>
	<li>`Expect.AnyInvocationOn`</li>
</ul>

From their names you should be able to figure out what they do, but we're going to look closer at `Expect.MethodCall` now. `Expect.MethodCall` is used to define an expected call to a method on a given type. Take a look at this example:

    var provider = Mock.Interface<IPaymentProvider>();
    Expect.MethodCall(() => provider.Reserve(10));

This fakes an implementation of the interface `IPaymentProvider` and says that it expects us to call `provider.Reserve` with the amount 10. If we were to invoke it with another value, let's say 0 like this:

    var provider = Mock.Interface<IPaymentProvider>();
    Expect.MethodCall(() => provider.Reserve(10));
    provider.Reserve(0);

We would get an exception because it assumes that we are about to call it with the amount 10:

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/Getting-started-with-a-Mocking-Framework-Microsoft-Visual-Studio-Administrator-5.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/Getting-started-with-a-Mocking-Framework-Microsoft-Visual-Studio-Administrator-5.png" alt="" title="Getting started with a Mocking Framework - Microsoft Visual Studio (Administrator) (5)" width="796" height="796" class="alignnone size-full wp-image-594" /></a>

    Unexpected invocation 'paymentProvider.Reserve(0)', expected:

    (invoked: 0 of *) paymentProvider.Reserve(10)

So if we change that to 10, it should be all good, but it's not always that you want to hard-code a constant value like that, so what you can use is a helper class called `Any<T>` which will let us define any type as an in-parameter or as a return value. In order to say that we are expecting a parameter type of decimal we do this:

`Any<decimal>`

But that's not enough, this only defines the type, we need to use the property `Value` in order to use the actual value that we will use later when we call this method:

    Expect.MethodCall(() => provider.Reserve(Any<decimal>.Value));

    provider.Reserve(0);
    provider.Reserve(25);

This means that the first time Reserve is called, the value of the decimal sent to the fake method will be 0 and the second time it will be 25. Let's make it a little interesting, as you might have noticed, you can define a lot of different Expectations for the same method, the parameter values are what defines what mocked invocation to use.

There's a method called Matching on the Value parameter that you can use to distinguish between different values. For instance, you might want to make a very specific test where it fails when the amount is less than 10 and succeeds when the value is above. That could look something like this:

    Expect.MethodCall(() => provider.Reserve Any<decimal>.Value.Matching(amount => amount > 10)));

This mocked method call will be used when we call Reserve with an amount greater than 10. But we're still not returning either true nor false, that's the next part! This is probably the easiest part so far, right before the semi-colon, just add `.Returns(true);` and you're all set!

So this is what the result of this snippet looks like:

    Expect.MethodCall(() => provider.Reserve(Any<decimal>.Value.Matching(amount => amount > 10)))
                                    .Returns(true);

And if we want to add another expectation that returns false if it is less or equal to 10, we can do that as well, the entire code will look something like this:

    var provider = Mock.Interface<IPaymentProvider>();

    Expect.MethodCall(() => provider.Reserve(Any<decimal>.Value.Matching(amount => amount > 10)))
                                    .Returns(true);

    Expect.MethodCall(() => provider.Reserve(Any<decimal>.Value.Matching(amount => amount <= 10)))
                                    .Returns(false);

    provider.Reserve(0);
    provider.Reserve(25);

The first reservation will return false, because amount is less than 10 but the second one will use the first faked method call and return true. Now let's step back a bit and take a look at our original problem, we want to make sure that we can process a payment and it should fail when the reservation fails and succeed when the reservation succeeds. So let's remove all the fuss around that and we should be left with a pretty simple looking snippet like this:

    var provider = Mock.Interface<IPaymentProvider>();
    Expect.MethodCall(() => provider.Reserve(Any<decimal>.Value)).Returns(true);

Now the next steps are pretty straight forward, we need to do the following:

<ul>
	<li>Create an expectation for the method call Execute</li>
	<li>Create an instance of the Payment type and pass it the mocked interface</li>
	<li>Execute a payment process!</li>
	<li>Validate the results by using tests</li>
</ul>

The next expected method call is the Execute method on the payment provider, this will look almost identical to the Reserve method in this case:

    Expect.MethodCall(() => provider.Execute(Any<decimal>.Value)).Returns(true);

The last two things we need to do now is to create an instance of our payment processor and pass it the interface:

    var provider = Mock.Interface<IPaymentProvider>();
    Expect.MethodCall(() => provider.Reserve(Any<decimal>.Value)).Returns(true);
    Expect.MethodCall(() => provider.Execute(Any<decimal>.Value)).Returns(true);

    var payment = new Payment(provider);
    payment.Execute(200);

This should compile fine and when you run the test it shouldn't complain anything at all. Now we've got everything set up, we need to test the behavior of payment processor and the two scenarios are:

<ul>
	<li>If reservation fails, execute should never be invoked</li>
	<li>If reservation succeeds, execute should be invoked and the method should return true</li>
</ul>

There are a couple of more scenarios such as, in the rare occasion if the reservation succeeds but the execution does not, does it throw a proper exception and roll back? But I'll leave these special scenarios for you to play with.

Let's continue looking at the first test, we've already (partially) finished it, but I'd like to remove the expectation for a method call, since I do not actually expect a method call at all, if the method is called, we will get an exception and this is correct.

So the first test where we check if the reservation fails looks like this:

    [TestMethod]
    public void CannotExecutePaymentWhenReservationFails()
    {
        var provider = Mock.Interface<IPaymentProvider>();
        Expect.MethodCall(() => provider.Reserve(Any<decimal>.Value)).Returns(false);

        var payment = new Payment(provider);
        var result = payment.Execute(200);

        Assert.IsFalse(result);
    }

If you run this test (ctrl + r + t) it should process fine and you should see a green icon indicating that the test finished without any errors:

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/Getting-started-with-a-Mocking-Framework-Microsoft-Visual-Studio-Administrator-8.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/Getting-started-with-a-Mocking-Framework-Microsoft-Visual-Studio-Administrator-8.png" alt="" title="Getting started with a Mocking Framework - Microsoft Visual Studio (Administrator) (8)" width="796" height="796" class="alignnone size-full wp-image-599" /></a>

Next up we need to create the test that verifies that everything processes OK, so we need to create a test that checks if Execute returns true if Reserves does too. All we need to do here is add the line of code that we removed before that tells Simple.Mocking that we are expecting a method call. The final test that we are going to make here will look like this if we add that expectation and change the reservation to return true:

    [TestMethod]
    public void CanExecutePaymentWhenReservationIsOk()
    {
        var provider = Mock.Interface<IPaymentProvider>();
        Expect.MethodCall(() =>
            provider.Reserve(Any<decimal>.Value))
                    .Returns(true);

        Expect.MethodCall(() =>
            provider.Execute(Any<decimal>.Value))
                    .Returns(true);

        var payment = new Payment(provider);
        var result = payment.Execute(200);

        Assert.IsTrue(result);
    }

If we run all the tests in the context (ctrl + r + a) it should gives us all green lights:

<a href="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/Getting-started-with-a-Mocking-Framework-Microsoft-Visual-Studio-Administrator-10.png"><img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2012/01/Getting-started-with-a-Mocking-Framework-Microsoft-Visual-Studio-Administrator-10.png" alt="" title="Getting started with a Mocking Framework - Microsoft Visual Studio (Administrator) (10)" width="796" height="796" class="alignnone size-full wp-image-601" /></a>

We could of course test if the Execution fails if both Reserve and Execute returns false, these are just similar test that you can add. As you can see Simple.Mocking is really powerful and of course you will need to test your real implementations, but before you test your real implementations of your payment providers, you will want to know if your internal stuff is working.

There are actually systems that charge you a certain amount of money for each API call, these can get quite expensive if your build server runs through all tests all night. I hope you've seen how powerful Simple.Mocking is and how it can help you test faster and test more.  I read once that everything should be simplified to an interface, this would mean that anything can be mocked and anything can be tested in one way or another.

So in short what we've accomplished is that you now have a fake implementation of your interface that will allow you to test other things in your system that depends on certain values or methods being called on that implementation. Here is the entire code that we've been looking over in this article:

    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Simple.Mocking;

    namespace Tests
    {
        [TestClass]
        public class PaymentProviderTests
        {
            [TestMethod]
            public void CannotExecutePaymentWhenReservationFails()
            {
                var provider = Mock.Interface<IPaymentProvider>();
                Expect.MethodCall(() => provider.Reserve(Any<decimal>.Value)).Returns(false);

                var payment = new Payment(provider);
                var result = payment.Execute(200);

                Assert.IsFalse(result);
            }
            [TestMethod]
            public void CanExecutePaymentWhenReservationIsOk()
            {
                var provider = Mock.Interface<IPaymentProvider>();
                Expect.MethodCall(() => provider.Reserve(Any<decimal>.Value)).Returns(true);
                Expect.MethodCall(() => provider.Execute(Any<decimal>.Value)).Returns(true);

                var payment = new Payment(provider);
                var result = payment.Execute(200);

                Assert.IsTrue(result);
            }
        }
        public class Payment
        {
            private IPaymentProvider _provider;
            public Payment(IPaymentProvider provider)
            {
                _provider = provider;
            }

            public bool Execute(decimal amount)
            {
                if (!_provider.Reserve(amount))
                    return false;

                if(!_provider.Execute(amount))
                    return false;

                return true;
            }
        }

        public interface IPaymentProvider
        {
            bool Reserve(decimal amount);
            bool Execute(decimal amount);
        }
    }

I hope you found this interesting, if you have any thoughts please leave a comment below!