---
layout: post
title: Using Java Build Script Tasks in Visual Studio Code
date: 2015-10-21 08:18:19
categories:
comments: true
authorId: david_wesst
originalurl: http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/
---

I [previously shared](http://www.westerndevs.com/custom-tasks-for-java-in-visual-studio-code/) how I setup a custom problem matching in Visual Studio Code for compiling Java  and displaying the errors inline with a custom problem matcher.

<!--more-->
  
The shortcoming with [Tasks](https://code.visualstudio.com/docs/editor/tasks) was that you could only define one, which is (in my humble opinion) by design to help developers by forcing them to create a build script rather than setting up tasks, as a build script is not coupled to the IDE and can be used elsewhere.

Code has support for build systems like Grunt, Gulp, and Jake, but what if we want to handle something totally different, like use Gradle on a Java project.

How do you do that? Good question. Let me show you.

### Define a Build Script
I've setup a standard Gradle project by using the ```gradle init``` and created a class with a main method named ```HelloLink```.

![http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/hellolink-file.png](http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/hellolink-file.png)

Next up, I want to create a custom build task. We'll call our task ```getSword```.

![http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/gradle-project.png](http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/gradle-project.png)

Now, we need to do the fun part: hook it into Code. 

### Add a Task to VS Code
If we take a page out of [my previous post](http://blog.davidwesst.com/2015/10/Custom-Tasks-for-Java-in-Visual-Studio-Code/), we need so to setup our ```tasks.json``` file. Do that by pressing ```Ctrl + Shift + P``` and searching for "task" and select for _Configure Task Runner_.

Let's add gradle as our task, which should leave our tasks file looking like:

![http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/gradle-task.png](http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/gradle-task.png)

When we run it, by pressing ```Ctrl + P``` and entering ```task gradle``` we should get the output window displaying our gradle command.

![http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/gradle-task-output.png](http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/gradle-task-output.png)

And now we're back to where we started, but gradle (like any build system) has way more tasks than just my custom one. How do I gain access to those?

Simple: you add tasks to your gradle task.

### Adding a Task to your Task
If you haven't already seen it, you have intellisense while you're editing your ```tasks.json```. If you browse through the multitude of JSON properties, you'll find one called _tasks_ which is where we can define our gradle specific tasks.

![http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/tasks-intellisense.png](http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/tasks-intellisense.png)

We define, what I call a subtask, just like we do a regular task, except the JSON schema is a little different. After adding a task for ```getSword``` and , my tasks file now looks like:

{% codeblock lang:javascript %}
{
	"version": "0.1.0",
	"command": "gradle",
	"isShellCommand": true,
	"args": [],	// no args, but we could add some
	"tasks": [
		{
			"taskName": "getSword",
			"showOutput": "always",
			"echoCommand": true
		}
	]	
}
{% endcodeblock %}

Great, but so far we haven't done anything actually useful. Let's apply what we've learned here and from [my previous post](http://blog.davidwesst.com/2015/10/Custom-Tasks-for-Java-in-Visual-Studio-Code/) and get a useful command setup in Code.

### Doing Something Real
So, not only do we want a task to call custom tasks, but we'll probably want one to compile and run our Java too. The [gradle application](https://docs.gradle.org/current/userguide/application_plugin.html) provides us with a ```run``` command that we'll call as our default build command, which will give us the _F5_ experience we know from our big, bloated, buddy, Visual Studio proper.

Just like we did with the ```javac``` command, we need to add a problem matcher to our task. 

Our tasks file now looks like:

{% codeblock lang:javascript %}
{
	"version": "0.1.0",
	"command": "gradle",
	"isShellCommand": true,
	"args": [""], 
	"tasks": [
		{
			"taskName": "getSword",
			"showOutput": "always",
			"echoCommand": true
		},
		{
			"taskName": "run",
			"showOutput": "silent",
			"isBuildCommand": true,
			"problemMatcher": {
				"owner": "external",
				"fileLocation": "absolute",
				"pattern": [
					{
						"regexp": "^(.+\\.java):(\\d):(?:\\s+(error)):(?:\\s+(.*))$",
						"file": 1,
						"location": 2,
						"severity": 3,
						"message": 4,
						"loop": true	// add this to loop through multiple lines
					}
				]
			}
		}
	]	
}
{% endcodeblock %}

And if you run it, you should get an error in our source code. Press ```Ctrl + Shift + M``` to see the warning about our static method, and click it to go to the error.

![http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/gradle-error.png](http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/gradle-error.png)

As you probably noticed, we set our ```run``` task, we've set it to be the _Build Command_ so that when we hit ```Ctrl + Shift + B``` it will execute our command. So, once we go and fix our application we can run it with a keyboard shortcut.

You can open up your output window by hitting ```Ctrl + Shift + U``` and see our application in action.

![http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/complete.png](http://blog.davidwesst.com/2015/10/Using-Java-Build-Script-Tasks-in-Visual-Studio-Code/complete.png)

## The Point
This is just one simple example using Gradle, but you could use Maven or Ant, or whatever custom build script tool you want, assuming it has a command line response. 

There are plenty of other things you can configure with tasks, including the OS-specific commands that need to be executed. Take a look at the [JSON Schema](https://code.visualstudio.com/docs/editor/tasks_appendix) for more details.

---
Thanks for playing. ~ DW 