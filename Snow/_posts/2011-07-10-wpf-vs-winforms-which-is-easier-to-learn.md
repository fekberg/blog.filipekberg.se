---
layout: post
title: WPF vs WinForms - Which is easier to learn?
date: 2011-07-10 13:22
author: fekberg
comments: true
metadescription: WPF vs WinForms - Which is easier to learn?
categories: .NET, C#
tags: .NET, .net 4.0, csharp, dotnet, WinForms, WPF
---
<em><a href="http://stackoverflow.com/q/6564795/39106">This question originates from StackOverflow</a>, but as I see there are a lot of beginners that ask this question, I wanted to share the answer on my blog as well.
</em>
So, <strong>WPF vs WinForms - Which is easier to learn?</strong><!--excerpt-->

<strong>Neither</strong> and <strong>Both</strong>, easy is very subjective and depends on your background. First of all, I want to show an example of an application with the following in both WPF and WinForms:
<ul>
	<li>A textbox for input</li>
	<li>A button to do some "Processing" of the input</li>
	<li>A label that will display a result</li>
</ul>
<strong>WinForms</strong>

The window can look something like this:

<img src="http://i.stack.imgur.com/dVg72.png" alt="enter image description here" />

The code for this is quite trivial and easy even for a beginner:

	private Button _myButton;
	private Label _resultLabel;
	private TextBox _inputTextBox;
	public Form1()
	{
	    InitializeComponent();
	    _myButton = new Button
	    {
	        Text = @"Process data",
	        Top = 100
	    };

	    _inputTextBox = new TextBox();

	    _resultLabel = new Label
	    {
	        Text = "",
	        Top = 200
	    };

	    Controls.Add(_myButton);
	    Controls.Add(_inputTextBox);
	    Controls.Add(_resultLabel);

	    _myButton.Click += Process_Click;    
	}

	void Process_Click(object sender, EventArgs e)
	{
	    _resultLabel.Text = string.Format("Your data is: {0}", _inputTextBox.Text);
	}

So far, we haven't touched anything in the designer.

<strong>WPF</strong>

If we copy and paste the exact same code into a new WPF-application, there are just a handfull of things that we have to change some of them being:
<ul>
	<li>How we add the controls to the interface</li>
	<li>How we change text in a label</li>
	<li>How we position it from the top ( margin )</li>
</ul>
However, these are just things that is Different between the two, it's neither more difficult nor more easy in one or the other. So this is what the window looks like in WPF:

<img src="http://i.stack.imgur.com/JcQXK.png" alt="enter image description here" />

And the code is Almost identical:

	private Button _myButton;
	private Label _resultLabel;
	private TextBox _inputTextBox;
	public MainWindow()
	{
	    InitializeComponent();

	    _myButton = new Button
	    {
	        Content = @"Process data",
	        Margin = new Thickness(0, 100, 0, 0)
	    };
	    _myButton.Click += Process_Click;

	    _inputTextBox = new TextBox();
	    _resultLabel = new Label
	    {
	        Content = "",
	        Margin = new Thickness(0, 100, 0, 0)
	    };
	    var panel = new StackPanel();
	    panel.Children.Add(_inputTextBox);
	    panel.Children.Add(_myButton);
	    panel.Children.Add(_resultLabel);   
	    Content = panel;
	}

	void Process_Click(object sender, EventArgs e)
	{
	    _resultLabel.Content = 
	                 string.Format("Your data is: {0}", _inputTextBox.Text);
	}

So far both WPF and WinForms seem to be equivilient hard / easy to learn. But this is just the code-behind approach, when we come to the designer, there's a huge difference.

<strong>WinForms</strong>

When you develop WinForms applications you drag and drop controls onto your surface and use a property window to change the properties of your window. This looks something like this:

<img src="http://i.stack.imgur.com/IdOAn.png" alt="enter image description here" width="600" />

So you can drag-n-drop your controls, you can change the properties of each control and snap them to where you want them, easy enough right?

<strong>WPF</strong>

So what about WPF? Is it much harder to do the same thing there? I think not:

<img src="http://i.stack.imgur.com/Ndsey.png" alt="enter image description here" width="600" />

The main difference here is that you have an extra "window" at the bottom that. This window is an XML ( XAML ) view of your design. This is where WinForms and WPF take apart from each other. But just as you can avoid writing Design Code in WinForms, you can Avoid doing it in WPF as well, as a newbie that is.

<strong>As for newbies</strong>, I don't think it's harder nor easier to learn the one or the other, when we get a bit deeper into the technology that is choosen, sure, it gets more complex. But the way there is just as easy or hard no matter which of the two you choose.

<strong>So when do you choose the one or the other?</strong>

You choose WinForms because:
<ul>
	<li>It's been around for a long time and you have a Large control supply that you can use.</li>
	<li>There are <em>a lot</em> of good resources on WinForms to learn from and to get new controls from.</li>
</ul>
You choose WPF because:
<ul>
	<li>You can make richer UI, nowdays it's all about the user experience.</li>
	<li>You want to have full control of your controls design.</li>
	<li>You want rich, data-driven applications.</li>
	<li>You want hardware accelerated UI.</li>
</ul>
<strong>How about data-binding, Design Patters and all that?</strong>

You don't need to know anything about Design Patterns nor how everything works to make a usabel application, especially not as a newbie. As time goes by, you will have to learn more about the technology that you choose. People tend to say that you need to know MVVM to use WPF, that is not true. As it is not true that you need to know the MVP pattern to create WinForms applications.

Both of the technologies can handle rich-data-driven controls, you have grid views and such in both of them. WinForms has some pretty nice "drag-n-drop"-features for data manipulation and listing and WPF has very nice data-binding.

<strong>What if I don't want to choose one or the other?</strong>

The beauty is that you don't have to! You can host WinForms controls in WPF and you can host WPF controls inside WinForms. This means that if you are developing a WinForms application and you want to take advantages of WPF, that's ok you can!

<strong>So which is easier?</strong>

Neither and Both! As for a newbie, both can look a lot similar on the surface, even though it is so different when you go deeper.

They are similar but so different, the thing is that when you start out, you have other things to think about than how the Routing model works and how to adapt to MVVM.

<strong>Is XAML dead?</strong>

No. XAML isn't dead. WP7 uses Silverlight which is also using XAML. Even though a lot of development in the future can be done with HTML5, I doubt that XAML is about to "die". People asked if WinForms was going to die when WPF was released and it hasn't.