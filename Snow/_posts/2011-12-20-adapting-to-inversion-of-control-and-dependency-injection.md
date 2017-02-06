---
layout: post
title: Adapting to Inversion of Control and Dependency Injection
date: 2011-12-20 00:23
author: fekberg
comments: true
metadescription: So what is this Inversion of Control that everyone is talking about?
categories: .NET, Architecture, C#, Programming
tags: csharp, dotnet, inversion of control, ioc, principles, software engineering
---
You might have come across the phrases IoC, Dependency Injection, Mocking among others, these are commonly used when talking about "Inversion Of Control" which is the full meaning of the abbreviation IoC. So what is this "IoC" that everyone is talking about?

Inversion of control is a principle in Software Engineering, let's just take a look at the Wikipedia definition of this<!--excerpt-->

<blockquote>In practice, Inversion of Control is a style of software construction where reusable generic code controls the execution of problem-specific code. It carries the strong connotation that the reusable code and the problem-specific code are developed independently, which often results in a single integrated application.</blockquote>

Rather than explaining the text below, let me show an example of an application that does not follow this principle, but will when we're done here! I've got a solution prepared that looks like this:

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/12/inversionofcontrol.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/12/inversionofcontrol.png" alt="" title="inversionofcontrol" width="259" height="192" class="size-full wp-image-511" /></a>

This solution simulates an order process, where we've got a window where we can place some kind of order and then we've got some sort of payment provider that executes the order request. This is the only content so far in the `InversionOfControl.Payment` library:

    public enum PaymentResult
    {
        Success,
        Failure
    }
    public class PayPalPaymentProvider
    {
        public PaymentResult Execute(string paymentData)
        {
            if (string.IsNullOrEmpty(paymentData)) return PaymentResult.Failure;
            return PaymentResult.Success;
        }
    }

All we're doing is to check if the data we send into the execute method actually contains any information at all, if it doesn't we return a failure result, otherwise we return a success result. Keep in mind that when you implement communication with real payment providers, there are a lot more code to it. But let's keep the example clean!

The order form is very simple and looks like this:

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/12/inversionofcontrol2.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/12/inversionofcontrol2.png" alt="" title="inversionofcontrol2" width="214" height="119" class="size-full wp-image-512" /></a>

When we press the button this is what's going to happen:

    private void ProcessOrderClick(object sender, EventArgs e)
    {
        ProcessPayment(orderInformation.Text);
    }

    public void ProcessPayment(string orderData)
    {
        var paymentProvider = new PayPalPaymentProvider();
        var result = paymentProvider.Execute(orderData);

        MessageBox.Show(result.ToString());
    }

So far we've got our order form where we can place an order, when we place the order we execute our order placement and directly communicate with our payment provider. Let's call this Step 1, we've set up the project and we can execute a payment, you can download the <a href="https://github.com/downloads/fekberg/Blog-Projects/Adapting%20to%20Inversion%20of%20Control%20and%20Dependency%20Injection.zip">code here</a>, unzip it and look in the folder named Step 1. <a href="https://github.com/fekberg/Blog-Projects/tree/master/Adapting%20to%20Inversion%20of%20Control%20and%20Dependency%20Injection/Step%201">You can also browse the code on github</a>.

Let's bring up another one of those commonly used abbreviations; TDD or Test After Development. Payments are a great example of something that really needs to be tested thoroughly and you can't have any errors here. Because either it will be expensive for you, your customer or the end user, no matter which one, you've got a big problem.

But what happens when we introduce testing at this stage? How do we actually test the entire flow of the application without communicating directly with payment provider? This is where Inversion of Control and Dependency Injection comes into play. Dependency Injection is a design pattern with the following Wikipedia explanation

<blockquote>DI whose purpose is to improve testability of, and simplify deployment of components in large software systems.</blockquote>

The pattern involves some rules that we need to adapt to, which basically means we have to write cleaner and more testable code. In order to make our code cleaner and more testable we need to break some of the static parts out, this being the actual instantiation of a concrete type in the payment processing.

Take a look at this line of code:

    var paymentProvider = new PayPalPaymentProvider();

There's something "wrong" with it; We're instantiation the concrete type here! To make the method testable, we don't want that because this means that it will always use our real payment provider information and execute the order against it, which can make the testing expensive for the tester ( if he has to provide is credit card number all the time that is! ).

The easiest way to break it out is to move this to the method argument list, which means that instead of creating an instance in the method, we want someone else to inject it to us. Let's look at this in a two-step refactoring, first we move the declaration outside of the context and change the method signature:

    public void ProcessPayment(string orderData, PayPalPaymentProvider paymentProvider)
    {
        var result = paymentProvider.Execute(orderData);

        MessageBox.Show(result.ToString());
    }

This will let us create an instance of `PayPalPaymentProvider` before we call the processing method and inject it when we call the method. But we are still working with the concrete type, so let's take a look at the next step in the two-way refactor, let's simply it to an interface!

All the interface need to tell us is that we've got a method called Execute that will return a result to us, so we simply declare it like this:

    public interface IPaymentProvider
    {
        PaymentResult Execute(string paymentData);
    }

And then we need to tell our payment provider to actually implement the interface, all we need to change is the class signature:

    public class PayPalPaymentProvider : IPaymentProvider

<strong>So far so good!</strong>

Now we just need to change the method signature for our payment processing as well and we are all set for some DI!

    public void ProcessPayment(string orderData, IPaymentProvider paymentProvider)

Now when we want to process the payment when we execute the order, the event handler will look like this instead:

    private void ProcessOrderClick(object sender, EventArgs e)
    {
        var paymentProvider = new PayPalPaymentProvider();
        ProcessPayment(orderInformation.Text, paymentProvider);
    }

By the looks of it, we now have a simple and elegant way to process our payments, let's create a test project and reference to `InversionOfControl.Demo`. Now create a test called `PaymentTests`.

<strong>So how do we start testing the payment processing?</strong>

We only have one concrete payment provider at the moment and this one we don't want to use for our unit testing, so what we will do instead is that we will create a fake class that will act as the real payment provider, this is dependency injection! So in our payment project, add a new class called `FakePaymentProvider` and just have it look somewhat like this:

    public class FakePaymentProvider : IPaymentProvider
    {
        public PaymentResult Execute(string paymentData)
        {
            if (paymentData == "OK") return PaymentResult.Success;


            return PaymentResult.Failure;
        }
    }

Now the test itself isn't that hard, we've already covered the hardest part and that was doing the actual refactoring. So, this is what my test ended up looking like:

    using InversionOfControl.Payment;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class PaymentTests
    {
        private IPaymentProvider paymentProvider;

        [TestInitialize]
        public void Initialize()
        {
            paymentProvider = new FakePaymentProvider();
        }
        [TestMethod]
        public void OrderFailsWithEmptyInformation()
        {
            var result = paymentProvider.Execute(null);

            Assert.AreEqual(result, PaymentResult.Failure);
        }
        [TestMethod]
        public void OrderSucceedsWithOKInformation()
        {
            var result = paymentProvider.Execute("OK");

            Assert.AreEqual(result, PaymentResult.Success);
        }
    }

I'm initializing my test by creating a fake payment provider and then I am testing if it fails and succeeds as I expect it to, we've got a nice way to test our code! This brings us to the next problem, where Dependency Injection and Inversion of Control meet each other, what if I want to test the flow of my application, without actually changing the concrete instantiations everywhere to `FakePaymentProvider`?

This is where we're going to bring in a library to help us along the way, but before we do that, let's just talk a little bit about what is going to happen.

So we've got a system that is now refactored so that the important methods that we want to make testable no longer use the concrete types as parameters but rather interfaces that we can implement to create our fake repositories or providers of some sort. The next thing we want to remove completely is the way that we create an instance of our concrete type before we invoke the payment provider.

To do this, we're going to use a library that let's us define what kind of implementation to use in runtime. To do this, I'm going to take some help of NuGet to install a library called <a href="http://ninject.org/">Ninject</a>. Ninject is an open source dependency injector for .NET and it's Very good! 

<strong>Fire up NuGet</strong> and let's start installing those packages!

All you need to write is the following:

    PM> Install-Package Ninject

Be sure that you've got "InversionOfControl.Demo" selected as "Default project" and you should see something like this:

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/12/inversionofcontrol3.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/12/inversionofcontrol3.png" alt="" title="inversionofcontrol3" width="807" height="868" class="alignleft size-full wp-image-521" /></a>

There are a lot of different type of dependency injectors out there and they act a little bit different. Ninject works like this: you tell ninject what types you want bound to what types or interfaces and then you request these types. There are other dependency injectors that will just replace all interfaces with the concrete type of your choice, but I like Ninject because it gives us an extra type of abstractness and there's not that much magic to it.

Basically we need to know two things in order to get started with Ninject ( <a href="https://github.com/ninject/ninject/wiki/_pages">There's a great Wiki if you want to know more</a> ) first of all, you use something called "Modules" to easily define different types of bindings. For instance, we're going to create a module that is called PaymentProviderModule. The second thing is that you use something called a kernel to retrieve the concrete types and you tell the kernel which module it should use.

Let's start off by creating the module:

    using Ninject.Modules;
    using InversionOfControl.Payment;

    public class PaymentProviderModule : NinjectModule
    {
        public override void Load()
        {
            Bind<IPaymentProvider>().To<FakePaymentProvider>();
        }
    }

All we're saying here is that each time we ask for an IPaymentProvider we're going to get a Fake payment provider. Now let's take a look at how this changes the rest of the code! Let's head over to the order button event handler. The only thing that actually changes now is how we retrieve a concrete type of IPaymentProvider and this is how we do that with Ninject:

    private void ProcessOrderClick(object sender, EventArgs e)
    {
        var kernel = new StandardKernel(new PaymentProviderModule());
        ProcessPayment(orderInformation.Text, kernel.Get<IPaymentProvider>());
    }

Notice this part in particular `kernel.Get<IPaymentProvider>()`, we're actually requesting the interface and not a concrete type! Let's run the application and see what happens, if we enter anything else than "OK", we should see a message box that says "Failure":

<a href="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/12/inversionofcontrol4.png"><img src="https://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2011/12/inversionofcontrol4.png" alt="" title="inversionofcontrol4" width="455" height="230" class="size-full wp-image-525" /></a>

And it does!

We've successfully made our application less dependent on the concrete type and we've introduced testability which we had no way of doing before! The example code for the payment provider is as stated before a bit thin, but in a real world scenario the fake payment provider might not be much bigger than the one we've got here, but the real concrete type might.

Now let's take a look at that definition of Inversion of Control again; it basically means that our application should be able to execute anything against any payment provider without ever having to know about its implementation! We've only scratched the surface on how this helps out with testability, there are great frameworks that will help us even more without having to actually create a new concrete type for testing, which in this case was our fake payment provider.

As you might see this is very powerful and gives us a great way to make our applications more testable which will make them more reliable. You can look at the code at<a href="https://github.com/fekberg/Blog-Projects/tree/master/Adapting%20to%20Inversion%20of%20Control%20and%20Dependency%20Injection"> the github repository.</a> You can also <a href="https://github.com/downloads/fekberg/Blog-Projects/Adapting%20to%20Inversion%20of%20Control%20and%20Dependency%20Injection.zip">download the code here</a>.

I hope you found this interesting, if you have any thoughts please leave a comment below!