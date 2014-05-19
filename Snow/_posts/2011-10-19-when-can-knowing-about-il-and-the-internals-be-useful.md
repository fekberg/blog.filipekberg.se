---
layout: post
title: When can knowing about IL and the internals be useful?
date: 2011-10-19 20:31
author: fekberg
comments: true
metadescription: How does knowing about MS IL improve your c# programming skills?
categories: .NET, Programming
tags: assmebler, compiler technology, dotnet, reflection
---
Lately we've been looking a lot on how you can use IL to create types at runtime, the same IL that we have emitted at runtime is what the C# compiler compiles the C# code to. So the first thing that comes to mind when someone asks me when knowing about IL and the internals of C# can be useful is when you want to write a compiler. Let's say that you for educational purposes want to create a very simple language and you want to be statically typed and usable by other .NET languages, then compiling the code to MSIL will allow you to do just that.<!--excerpt-->

Back when I studied for my bachelor in Software Engineering I attended a course the last year that was called "Advance UNIX Programming" one of the laboratory practicals that we did in this course was to complete a compiler, and when I say to complete it I do not mean write it from scratch in this case. We had other courses that covered the depth of compiler technology, however in this particular programming course we were given an application that parsed a programming language and our assignment was to make it generate the correct assembler.

The assembler that we generated was in this case <a href="http://en.wikipedia.org/wiki/GNU_Assembler">GAS</a> and the custom programming language they called "Calc" looked like this:

	a=732;
	b=2684;
	while(a != b) {
	  if(a > b) {
	    a=a-b;
	  } else {
	    b=b-a;
	  }
	}
	print a;

	print a gcd b;

As you can see on the bottom we also had to create some library functions such as "<a href="http://en.wikipedia.org/wiki/Greatest_common_divisor">gcd</a>". Basically we only had one file that we had to edit in, or to be even more specific we did everything inside one big method that had a switch case that told us what kind of operation that we were currently working with. So we had a lot of parsing done already, there are a lot of tools out there if you want to parse a programming language, there's something called lexical analyzing that you can look into.

In this laboratory practical the purpose was to spit out correct assembler and show that we had somewhat a knowledge of how the stack worked and how to use certain operations, here are two examples take from that laboratory practical, the actual programming language used in the generator is C:

	case '+':   printf("\tpopl\t%%eax\n\tpopl\t%%ebx\n\tadd\t%%ebx, %%eax \n\tpushl\t%%eax\n"); break;
	case '-':   printf("\tpopl\t%%ebx\n\tpopl\t%%eax\n\tsub\t%%ebx, %%eax \n\tpushl\t%%eax\n"); break;

So in this big switch when it has found a + and a - this is what is done. It might be a bit hard to see in that printf-statement, but here's the generated assembler:

	popl   %eax
	popl   %ebx
	add    %ebx, %eax 
	pushl  %eax

As you can see here, it's pretty similar to MSIL. Now this might not normally be how generate the assembler, you might have it a little bit nicer in the actual compiler than just one-liners, but I just wanted to show you some really old stuff.

I won't go through how you write a compiler here, it's a very broad topic and take a very long time to master, if you like to read about deep level stuff like how the people behind the compilers think, <a href="http://blogs.msdn.com/b/ericlippert/">read Eric Lipperts blog.</a>.

Essentially a compiler is just a program that translates your text into some other format that is either readable by another compiler or directly by a machine. In the laboratory practical that I shared with you above, we actually generated GAS and compiled it with GCC to make it executable.

So everything we've been looking at lately is directly applicable if you want to start off by writing a compiler for a new language. I really hope you've enjoyed the reflection series that has been focusing on IL generations and dynamic methods, there will most certainly be more of them around in the future.

I hope you found this interesting because I had a lot of fun writing it and if you have any thoughts please leave a comment below!
