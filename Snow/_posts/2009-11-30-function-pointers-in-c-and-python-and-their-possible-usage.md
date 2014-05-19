---
layout: post
title: Function pointers in C and Python and their possible usage
date: 2009-11-30 16:07
author: fekberg
comments: true
metadescription: Understanding function pointers in C and Python and their possible usage
categories: Architecture, c-programming, Programming, Python
tags: function pointers, Python
---
Function pointers? you might ask yourself, well this little trick gets handy sometimes, I will provide an example of a practical use in a later post on the next euler solution. Might actually do it in C too just to prove that C is still neat.<!--excerpt-->

So to kick this off, what are function pointers? Well for those deep down the rabbit hole ( .NET guys that is ), might not really have a clue on the matter, and others might dissaggree and now exactly what it is. So just to keep the air clear here, function pointers are "pointers" that direct you to a function, easy huh?

Well, you probably got as much from just reading the phrase but, it's not really rocket science. If you are familiar with references or reference types, such as Strings and Objects, you know that there are different types of memory in which your program operates. When you create an Object you store your data on a shared memory place. There are shared memory and program reserved memory ( the stack! ). So you might want to look at this as a "reference" to a function.

So when would this be nessecary? Imagine the scenario where you might want to performe some calculation but you don't know what type of API the end user which will end up using your API have. Let's say that the method "square" ( x^x ) would not be defined. So you might end up having to use function pointers, where you ask the user to suppy the function for calculating square of x.

In Python the Square function for `x^x` will look like this

    def square(i):
            result = i;
            for x in range(i-1):
                    result *= i

            return result

In C it will look like this

    int square(int i)
    {
            int result = i;
            int x = 1;

            for ( x = 1; x < i; x++ )
            {
                    result *= i;
            }

            return result;
    }

Now these two look fairly similar don't they? Well sure, the only real difference is the dialekt right? It's just programming. So let's get to the cool parts. In python, we would solve this problem easy, since it's not a strongly typed language everything could be a function, right. So let's check the decleration for calculate.

But before we check that out, let's just make it clear that our Usage will be somewhat like, give me a function that calculates square of `a+b`, this means, the result should be `(a+b)^(a+b)`.

So this is the function decleration in Python

    def calculate(func, a, b)

Not that hard, right? Well, keep in mind that Python is a "modern" language, it's more of a scripting language.

Check this out and notice the fairly big difference

    int calculate(int (*func)(int c), int a, int b)

If you are not familiar with pointers I would suggest you dig down the archive on my blog and check out the chapters about that. So what this really does in C is that you tell the compiler that, okay this function takes a pointer to something that will look like this, and you write the declaration of the function again. So, in this case you really need to know what it looks like. With standard parameter values in Python you could acheive some really cool things without knowing the decleration of the function.

Now we've seen how to Create the methods, taking arguments that are functions, how about using them inside your code?

Check this C example of the whole Calculate function

    int calculate(int (*func)(int c), int a, int b)
    {
            return (*func)(a+b);
    }

And in Python the following will look like this

    def calculate(func, a, b):
            return func(a+b);

There is a notable difference here, but I can honestly say that I like the C-style.

Try out the python version!

    #!/usr/bin/python

    def square(i):
            result = i;
            for x in range(i-1):
                    result *= i

            return result

    def calculate(func, a, b):
            return func(a+b);

    def main():
            print calculate(square, 1, 1)

    if __name__ == "__main__":
        main()

Happy Coding!