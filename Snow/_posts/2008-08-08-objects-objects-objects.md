---
layout: post
title: Objects, Objects, Objects!
date: 2008-08-08 21:55
author: fekberg
comments: true
metadescription: Everything is Objects, Objects, Objects!
categories: Architecture, Programming
tags: Programming, programming architecture
---
By looking on everything in life as Objects is one of the benefits from doing object oriented programming. It doesn't really matter if you master the technique or if you are in the beginners stage, just starting with object oriented programming will open up your eyes.

Seeing how objects change your perspective on both programming and other stuff in life, i've notied that when i wanted to learn something like animating in Flash, knowing object orientation helps. Not particulary with the animating, but with the thoughts on how i will structure my animations.<!--excerpt-->

I.e. that i have to create a move, where a part in this move occures many times, repeatinly creating this scenes and moving them around is a fairly harsh work. Looking at it from an object oriented perspective you see that you have:
A main film
An object containging the scene

When needed, you just insert a new object of the scene and you never need to repeate the procedure of creating the scene.

Using Objects isn't always good though, when you need to store the memory on other medias than the RAM you need it to be serialized, which is not handled to good by some languages such as PHP.

The basics of object orientation is easy to learn over a few minutes, when you try to look at everthing at a new perspective, the learning period will decrease.

Let's say that you have a Car, this car has 4 wheels, 5 doors, 6 windows and so on. The doors got handles, the wheels got air in them and so on. Seeing all these parts as Objects is a good way to play with the thoughts of object orientation. See how i apply inheritage on a car:

	abstract class BasePart
	{
	    int m_ModelNr;
	    string m_Name;
	    public BasePart(int ModelNumber, string Name)
	    { 
	         m_ModelNr = ModelNumber;
	         m_Name = Name;
	    }
	}

Everytime you create something, the created part / object or wathever got a Model Number and a Name, just look at carparts or a coka cola bottle.

	class Door : BasePart
	{
	    int m_DoorType;
	    int m_Weight;
	    int m_Code;

	    public Door(int DoorType, int Weight, int Code, int ModelNumber, int Name) : base(ModelNumber, Name)
	    {
	     ///.....
	    }
	}

The codesnippet above shows the basics in object orientation, this is a Base Class which is Abstract, which means that you cannot create an object of it.
The Door is derived from a BasePart because its a BasePart.
