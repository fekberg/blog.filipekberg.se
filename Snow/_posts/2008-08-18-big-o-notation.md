---
layout: post
title: Big O-notation
date: 2008-08-18 21:55
author: fekberg
comments: true
metadescription: Understanding Big O-notation
categories: Algorithms & Data structures
tags: big o-notation, merge sort
---
So starting school in a couple of weeks and being told that you wont get any "allowance" from the state makes you think twice about your current situtation. Not that this has anything ( directly  ) to do with o-notation. However this is how i forced myself into learning it. I have to re-take an exam in Algorithms and Datastructures this upcoming week and i want to share my experience in big o-notation.<!--excerpt-->

So basicly we have an array, a list of some sort and somehow we need to go through each element in this list. Having 'n' elements we need to create some kind of look like this:

	void walkList(int[] numbers)
	{
		for ( int i = 0 ; i &lt; numbers.lenght(); i ++ )
		{
			print numbers[i];
		}
	}

Now this will print all the elements contained in the list of numbers. Lets look at this from a time complexity way, 4 constant operations these being:
<ul>
	<li>function input</li>
	<li>int i assignment</li>
	<li>i &lt; numbers check</li>
	<li>increment</li>
</ul>
And the loop will run `n` times meaning we have `n + 4` this will give us `O(n + 4)`, but constant access times are irrelevant talking about runtime so all we do is write `O(n)`. O, ordor as it is pronounced, is a way of stating the time complexity.

Now lets say we need to process ths array in another way, play with the thought that we have this list of numbers and for each number we want to go through the list again. This would give us a nested loop and give the time complexity `O(n^2)`. This meaning that we need to process the list twice for each item, hence n ^ 2.

Looking at a sorting algorithm like Merge Sort that first divides the list into 2 peices untill its at the last item, then merges them. We see the typical behavior of a `log()` with the base 2. So, the split / sort part is basicly `log(n)` while the merging part is n and `log (n) * n = nlog(n)` which is slower than `log(n)`. There are however no "standard" sort algorithms that can do better than `nlog(n)`, in a random case that is. Best case for i.e. bubblesort is `log(n)`  and worst case for bubblesort is `log(n^2)` which is slower than mergesort.

<strong>Mergesort</strong>

<strong> </strong>

<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Merge_sort_algorithm_diagram.svg/300px-Merge_sort_algorithm_diagram.svg.png" alt="" />

When is time complexity nessesary? I would say that during all my years of programming, learning speed, size and other performance parts the hard way, i would say that this is a very good complement to fast calculate time complexity of your algorithm. You can be a very good programmer without knowing a lot about this. A lot of this is just something that a programmer knows how to handle without knowing O-notation. But as said, a good complement.
