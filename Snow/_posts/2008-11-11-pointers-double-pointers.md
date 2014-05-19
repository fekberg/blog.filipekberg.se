---
layout: post
title: Pointers & Double Pointers
date: 2008-11-11 21:50
author: fekberg
comments: true
metadescription: Understand Pointers and Double Pointers
categories: C/C++
tags: C/C++, heap, pointers, stack
---
###Definitions
First off, we need to clearify what a some of the expressions i will use mean. These are the following expressions:

##Stack
Assuming that you know about a computer having RAM ( Random Access Memory ) which allows you to store information and have this accessable faster than you would on a secondary memory like a harddrive and/or cd-rom.

When a program is executed there is a part in the memory reserved for this application to use, this "space" is called the Stack; The stack is always the same size and it's not possible to change it's size on any way.

##Heap
The Heap is also a "space" on your memory, actually it's all the memory not allocated as a stack. So when your stack is defined, everything else can be expressed as the Heap.<!--excerpt-->

<strong>Pointers</strong>

What is a pointer really? A pointer is a globally used expression to reference that your somewhat "point" to something. See the following illustration

<img class="image" src="http://frw.blogg.se/images/2008/pointer_1_21071735.png" alt="p1" />
On this image we have something that we point to, let's call A our Object. So having A as the actualy object, play with the thought that B and C isnt there, and there are no pointers to it.

This would infact mean that we had A allocated on the `Stack`. When does this become a problem? So play with the thought you have a really big information base such as a User Layer where you store a lot of data on each user. Then havnig a big register on all the people attending a course would take up somewhat a bigger space than we have free.

When is is an issue, we can use a pointer, to reference to this object. You can of course point to an object that you have on the stack, but that's not. afaik, what it's initially intended for.

So we tell our program that we want to create a Pointer, this pointer will in fact be stored on the stack, but a pointer only takes up 4 bytes so this wont be a problem.

After creating the pointer, we create the object itself and have the pointer B point to this.

<strong>Pointer, Objects &amp; Arrays</strong>
Assuming you know about some object orientation and how an object is constructed i will not go in to this very deeply. I.e. we have a class called Person and we want to create somewhat a register over students attending a course, what we initially want to do is create an object array, where we can store all our persons, using c++, as i will do in the following examples you would write something like this:

	Person *attendingStudents = new Person[size];

Where size is equal to the max amount of students.

Running this code, the constructor of Person will be runned as many times as the size of the array attendingStudents. <span style="text-decoration:underline;">How is this a problem?</span> This becomes a problem when we dont want to run the default constructor and allocate the object size  as many times as the total array size, this has too much overhead.

First of all, how does this look in memory?<span style="text-decoration:underline;"> </span>

<img class="image" src="http://frw.blogg.se/images/2008/pointer_2_21073486.png" alt="p2" />

On adress 0 to adress 3 wnicn means 4 bytes; every memoy block is 4 bytes; the pointer attendingStudents is allocated and on that area a 4 byte long adress is stored which in our case is 84. The size of the given Person object is not given but just play with the thought that its 4 bytes and the size is 10 this would mean the total size of the Person array would be 10 * 4 = 40 Bytes going from the address 84 to 124.

However, let's say that the Person object takes up 4 times as much so it takes up 16 bytes per Person object, this would result in 16 * 10 = 160 bytes, going from address 84 to 244. Now, there is a big overhead if we dont use all the persons and it would be stupid to call the constructors twice.

So, how about, we just point to something that we know is a pointer, and then let this poitner take care of the rest? But we just initialize the first step?

<strong>Double pointers</strong> Thjis is were double pointers comes in handy, look at the following code:

	Person **attedningStudents = new Person*[size];

This code is not as straight forward to look at, as the pervious one, but it basically means, 

`Person **attendingStudents` = Create a reference, to a pointer, what is a pointer? A pointer is something that will in the end point to a data type, so what we do here is saying that Point to a Pointer, this pointer will eventually have the data type Person.

Just to clearify, a pointer to an array, initially points to the first index in that array. So after creating the Pointer to a Pointer we tell it to point to a new list of Pointers, the amount of pointers to create is the same as the digit in size.

This might not make any sense, but take a look at the following

<img class="image" src="http://frw.blogg.se/images/2008/pointer_3_21074362.png" alt="p3" />

Initally these pointers don't point to anything at all so what we can do is: attendingStudents[i] which will take us to the adress 84 and then create an object on this index by doing this: `attendingStudents[i] = new Person();`

Why is this method better than the one before? Well this assures that we Only have the 11 pointers which takes 4 bytes per pointer. 1 pointer on the stack, referencing 10 pointers on the stack. When does this give us overhead? This gives us a 4 byte overhead when we start creating our Persons. But the execution time saved and just given 4 bytes ovearhead per pointer, this is a preffered method by me.
