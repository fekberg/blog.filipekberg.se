---
layout: post
title: I'm using dynamic and unexpectedly lost intellisense!
date: 2013-01-17 13:58
author: fekberg
comments: true
metadescription: Are you confused by how dynamic work and why you just lost intellisense? Then you need to read this!
categories: .NET, C#, Programming
tags: csharp, dynamic
---
I've written and talked quite a bit about dynamic before, both in this blog, on user groups and in my book C# Smorgasbord. I never get tired of talking about it though because there are always interesting new things to be found out. <a href="http://thecodejunkie.com/">TheCodeJunkie</a> (author of <a href="http://nancyfx.org/">Nancy</a>) asked something quite interesting on JabbR today which lead to an interesting discussion about dynamic (among other things).<!--excerpt-->

The question and code sample is pretty easy, let's say that we have a class in which we have a `static` method that returns a new instance of that class. This method takes one parameter which is a dynamic type which means that we can end up with a class looking something like this:

    class Person
    {
        public Person Mother { get; set; }
        public static Person CreateBaby(dynamic mother)
        {
            return new Person { Mother = mother };
        }
    }

So the question that he asked was, what if we create an instance of it like you see in the following code, what type will the variable be? Because if it is `dynamic`, we will have lost intellisense.

    static void Main(string[] args)
    {
        dynamic parent = null;

        var baby = Person.CreateBaby(parent);
    }

Without trying this in Visual Studio, what do you think? Leave a comment below telling me what you expected it to be and what it really was once you (continued reading) tried it for yourself!

At a first glance, it looks like the compiler will know that `Person.CreateBaby` returns a statically typed object of type `Person`. Before we take a look what happens, let's inspect the IL with reflector:

    .method private hidebysig static void Main(string[] args) cil managed
    {
        .entrypoint
        .maxstack 8
        .locals init (
            [0] object parent,
            [1] object baby,
            [2] class [Microsoft.CSharp]Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo[] CS$0$0000)
        L_0000: nop 
        L_0001: ldnull 
        L_0002: stloc.0 
        L_0003: ldsfld class [System.Core]System.Runtime.CompilerServices.CallSite`1<class [mscorlib]System.Func`4<class [System.Core]System.Runtime.CompilerServices.CallSite, class [mscorlib]System.Type, object, object>> DynamicDemo.Program/<Main>o__SiteContainer0::<>p__Site1
        L_0008: brtrue.s L_0049
        L_000a: ldc.i4.0 
        L_000b: ldstr "CreateBaby"
        L_0010: ldnull 
        L_0011: ldtoken DynamicDemo.Program
        L_0016: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
        L_001b: ldc.i4.2 
        L_001c: newarr [Microsoft.CSharp]Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo
        L_0021: stloc.2 
        L_0022: ldloc.2 
        L_0023: ldc.i4.0 
        L_0024: ldc.i4.s 0x21
        L_0026: ldnull 
        L_0027: call class [Microsoft.CSharp]Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo [Microsoft.CSharp]Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo::Create(valuetype [Microsoft.CSharp]Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfoFlags, string)
        L_002c: stelem.ref 
        L_002d: ldloc.2 
        L_002e: ldc.i4.1 
        L_002f: ldc.i4.0 
        L_0030: ldnull 
        L_0031: call class [Microsoft.CSharp]Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo [Microsoft.CSharp]Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo::Create(valuetype [Microsoft.CSharp]Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfoFlags, string)
        L_0036: stelem.ref 
        L_0037: ldloc.2 
        L_0038: call class [System.Core]System.Runtime.CompilerServices.CallSiteBinder [Microsoft.CSharp]Microsoft.CSharp.RuntimeBinder.Binder::InvokeMember(valuetype [Microsoft.CSharp]Microsoft.CSharp.RuntimeBinder.CSharpBinderFlags, string, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [mscorlib]System.Type>, class [mscorlib]System.Type, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [Microsoft.CSharp]Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo>)
        L_003d: call class [System.Core]System.Runtime.CompilerServices.CallSite`1<!0> [System.Core]System.Runtime.CompilerServices.CallSite`1<class [mscorlib]System.Func`4<class [System.Core]System.Runtime.CompilerServices.CallSite, class [mscorlib]System.Type, object, object>>::Create(class [System.Core]System.Runtime.CompilerServices.CallSiteBinder)
        L_0042: stsfld class [System.Core]System.Runtime.CompilerServices.CallSite`1<class [mscorlib]System.Func`4<class [System.Core]System.Runtime.CompilerServices.CallSite, class [mscorlib]System.Type, object, object>> DynamicDemo.Program/<Main>o__SiteContainer0::<>p__Site1
        L_0047: br.s L_0049
        L_0049: ldsfld class [System.Core]System.Runtime.CompilerServices.CallSite`1<class [mscorlib]System.Func`4<class [System.Core]System.Runtime.CompilerServices.CallSite, class [mscorlib]System.Type, object, object>> DynamicDemo.Program/<Main>o__SiteContainer0::<>p__Site1
        L_004e: ldfld !0 [System.Core]System.Runtime.CompilerServices.CallSite`1<class [mscorlib]System.Func`4<class [System.Core]System.Runtime.CompilerServices.CallSite, class [mscorlib]System.Type, object, object>>::Target
        L_0053: ldsfld class [System.Core]System.Runtime.CompilerServices.CallSite`1<class [mscorlib]System.Func`4<class [System.Core]System.Runtime.CompilerServices.CallSite, class [mscorlib]System.Type, object, object>> DynamicDemo.Program/<Main>o__SiteContainer0::<>p__Site1
        L_0058: ldtoken DynamicDemo.Person
        L_005d: call class [mscorlib]System.Type [mscorlib]System.Type::GetTypeFromHandle(valuetype [mscorlib]System.RuntimeTypeHandle)
        L_0062: ldloc.0 
        L_0063: callvirt instance !3 [mscorlib]System.Func`4<class [System.Core]System.Runtime.CompilerServices.CallSite, class [mscorlib]System.Type, object, object>::Invoke(!0, !1, !2)
        L_0068: stloc.1 
        L_0069: ret 
    }

That does look like a lot of code for just two lines, right? So most likely it wasn't as simple as the variable being a static type. By looking over the IL above, you'll see that a lot of runtime stuff is going on and that we in fact see a lot of `dynamic` here. Let's compare the IL to what it will look like, if we make a simple modification to the code by just changing the variable `parent` to a static type instead:

    static void Main(string[] args)
    {
        Person parent = null;

        var baby = Person.CreateBaby(parent);
    }

The IL produced from this is <strong>much</strong> easier on the eyes:

    .method private hidebysig static void Main(string[] args) cil managed
    {
        .entrypoint
        .maxstack 1
        .locals init (
            [0] object parent,
            [1] class DynamicDemo.Person baby)
        L_0000: nop 
        L_0001: ldnull 
        L_0002: stloc.0 
        L_0003: ldloc.0 
        L_0004: call class DynamicDemo.Person DynamicDemo.Person::CreateBaby(object)
        L_0009: stloc.1 
        L_000a: ret 
    }

We still have a dynamic parameter on the method that we are calling so we would have an equal amount of IL as we saw before on that type!

<strong>So what did we actually answer here? </strong>Simply put what happens when the use of `dynamic` is in place, the line of code will be evaluated at runtime. If you try casting the statically typed local variable when we pass it to the method, it will be the same behavior as if it was `dynamic` all along, as you can see in the below screenshot.

<img src="http://cdn.filipekberg.se/fekberg-blog/wp-content/uploads/2013/01/Dynamic.png" alt="A dynamic variable" width="810" class="alignright size-full wp-image-1633" />

<strong>Did it work as you expected? Leave a comment and let me know!</strong>
