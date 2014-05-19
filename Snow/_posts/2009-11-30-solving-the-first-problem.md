---
layout: post
title: Solving the first euler problem
date: 2009-11-30 11:06
author: fekberg
comments: true
metadescription: Solving the first euler problem
categories: Python
tags: euler, Python
---
So I've decided to start a new project, to solve as many euler problems as possible from http://projecteuler.net/, in Python! The task in hand is not only to solve them but to think outside the box and add new features to the code which might become suitable in the future, who knows.<!--excerpt-->

<strong>Let's start off by solving the first problem!</strong>

<blockquote>If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
Find the sum of all the multiples of 3 or 5 below 1000</blockquote>

Now you might think it's useless if you Only can solve this for 3 and 5, so why don't we just make a tuple with the appropriet set of numbers?

My function declaration ended up looking like this `def sum_naturals(max, dividers=[3,5]`

Where the variable max is, in this case, 1000. to test it out, I want the following to be true

	# Prints 23
	print sum_naturals(10)

This problem is not really rocket science so I'll just let you guys look at the code and try to figure out what I was thinking, and please leave comments if you like or disslike it.


	def sum_naturals(max, dividers=[3,5]):
	result = 0

	# Iterate through the numbers from 0 to max
	for i in range(max):
	    # Iterate the dividers and divide i with each Divider
	    possibleDivision = 0
	    for divizor in dividers:
	        if (i % divizor) == 0 and possibleDivision == 0:
	            possibleDivision = 1
	            result += i
	return result

This is actually a perfectly good example on "How to start python programming". If requested or if i just feel like it, I might create a serie where I break these or similar problems into smaller pieces and explain them. Maybe I'll throw in a couple of C#, C and PHP examples aswell. <em>You decide</em>.
