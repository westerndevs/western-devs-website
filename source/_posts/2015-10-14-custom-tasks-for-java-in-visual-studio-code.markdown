---
layout: post
title:  Custom Tasks for Java in Visual Studio Code
date: 2015-10-14 08:25:50
categories:
comments: true
author: david_wesst
originalurl: http://blog.davidwesst.com/2015/10/Custom-Tasks-for-Java-in-Visual-Studio-Code/
---

Now that I'm a Java Developer, I no longer worry about the bloating feeling I get when I need to open up the original Visual Studio. Now I worry about opening another instance of Eclipse. Don't get me wrong, Visual Studio and Eclipse are both great tools, but there are plenty of times where I don't need to bring a forklift just to move a single box.

This is why I love Visual Studio Code.

That being said, we don't have native rich support for Java in Code. We _do_ have syntax and bracket matching for Java, I wanted to see if I could compile and possibly display any errors directly in code.

We do that using [Tasks](https://code.visualstudio.com/docs/editor/tasks), and here's what I did:

### Configure a Task Runner
To start you need a task runner for your project, which is where you will...you guessed it...configure tasks.

1. Hit ``Ctrl + Shift + P`` to bring up the command palette. Search for "task" and you'll get the _Configure Task Runner_ command. 
2. Select it and press ``Enter`` to generate a tasks.json file.

![http://blog.davidwesst.com/2015/10/Custom-Tasks-for-Java-in-Visual-Studio-Code/configure-task-runner.png](http://blog.davidwesst.com/2015/10/Custom-Tasks-for-Java-in-Visual-Studio-Code/configure-task-runner.png)

The default _tasks.json_ file has some samples along with some reference variables at the top of the file.

Next up, we create our task.

### Configure a Task
To see if we have any errors, we want to run our Java compiler on our code to get any error. In the example below, I'm using a simple project with a ```src``` and a ```target``` directory where the ```src``` directory contains all of our Java files.

1. First, clear out the other tasks in the file. We only want the one we're going to use which is our javac command.
2. Add the task to run the Java compiler

{% codeblock lang:javascript %}
{
	"version": "0.1.0",
	"command": "javac",
	"showOutput": "always",
	"isShellCommand": true,
	"args": ["-d","${workspaceRoot}\\build\\classes","${workspaceRoot}\\src\\main\\java\\*.java"]
}
{% endcodeblock %}

3. Now, we can run our command by hitting ```Ctrl + Shift + P``` and typing _Run Task_ should show us our new Java task.

![http://blog.davidwesst.com/2015/10/Custom-Tasks-for-Java-in-Visual-Studio-Code/new-javac-task.png](http://blog.davidwesst.com/2015/10/Custom-Tasks-for-Java-in-Visual-Studio-Code/new-javac-task.png)

4. Select it to run it, and assuming you have an error, it should display something in the output window.

![http://blog.davidwesst.com/2015/10/Custom-Tasks-for-Java-in-Visual-Studio-Code/javac-output.png](http://blog.davidwesst.com/2015/10/Custom-Tasks-for-Java-in-Visual-Studio-Code/javac-output.png)

We're making progress, but it would be nice to see those errors inline in our code files, wouldn't it? That's where Problem Matchers come in.

### Add a Problem Matcher to your Task
Now that we have a task running, we need to tell Code how to process the output. We do that using configuring a problem matcher that uses a regular expression to parse the output.

Here's what my task looks like now:

{% codeblock lang:javascript %}
{
	"version": "0.1.0",
	"command": "javac",
	"showOutput": "silent",	// changed so that the output window doesn't pop up constantly
	"isShellCommand": true,
	"args": ["-d","${workspaceRoot}\\target","${workspaceRoot}\\src\\*.java"],
	"problemMatcher": {
		"owner": "external",
		"fileLocation": ["absolute"],
		"pattern": [
			{
				"regexp": "^(.+\\.java):(\\d):(?:\\s+(error)):(?:\\s+(.*))$",
				"file": 1,
				"location": 2,
				"severity": 3,
				"message": 4
			}
		]
	}
}
{% endcodeblock %}

If you'd like the full scoop on how this works, you can check out the explanation on the Code documentation on [writing problem matchers](https://code.visualstudio.com/Docs/editor/tasks#_defining-a-problem-matcher) but basically each of the variables listed beneath the ```regexp``` represent a part of the VS code message that should display.

Now that I've updated my task. If we run it again by hitting ```Ctrl + P``` and typing _task javac_ we should get the following:

![http://blog.davidwesst.com/2015/10/Custom-Tasks-for-Java-in-Visual-Studio-Code/error-inline.png](http://blog.davidwesst.com/2015/10/Custom-Tasks-for-Java-in-Visual-Studio-Code/error-inline.png)

...and if we bring up our warnings by hitting ```Ctrl + Shift + M``` we should see:

![http://blog.davidwesst.com/2015/10/Custom-Tasks-for-Java-in-Visual-Studio-Code/error-warning.png](http://blog.davidwesst.com/2015/10/Custom-Tasks-for-Java-in-Visual-Studio-Code/error-warning.png)

Click on the warning, should bring you to the file with the error in it.

## Hey, Why Can't I Add More Tasks to tasks.json?
Great question! Although I don't have an official answer, here's my opinion: **It's a bad idea**.

The ```tasks.json``` file is an IDE specific configuration file. All it's really doing to making shortcuts through your IDE to execute different commands from the command line. So rather than setup multiple tasks for each individual command, you should do yourself and your project a favour and setup a build script and use that in your tasks.json file.

A build script will have all the commands and scripts you need to run, build, test, or do whatever to your project. Plus, it's usable _outside_ of Code, so it's much more useful.

Although totally customizable (which I'll cover in [an upcoming post](http://westerndevs.com/using-java-build-script-tasks-in-visual-studio-code/)), you can see this action now if you're using [Gulp, Grunt, or Jake](https://code.visualstudio.com/Docs/editor/tasks#_mapping-gulp-grunt-and-jake-output-to-problem-matchers) in your existing projects.

---
Thanks for playing. ~ DW

##### References
1. [Tasks in Visual Studio Code](https://code.visualstudio.com/Docs/editor/tasks)
2. [tasks.json Schema reference](https://code.visualstudio.com/docs/editor/tasks_appendix)
3. [Mapping Gulp, Grunt and Jake Output to Problem Matchers](https://code.visualstudio.com/Docs/editor/tasks#_mapping-gulp-grunt-and-jake-output-to-problem-matchers)