---
title: Jabba, the Java Version Manager for Everyone
date: 2017-08-16 09:35:00
category:
    - java
tags:
    - java
    - powershell
    - version manager
    - jabba
excerpt: "Here's another dev thing I use: Jabba, a cross-platform Java version manager that works for Windows."
layout: post
authorId: david_wesst
---

[1]: https://davidwesst.blob.core.windows.net/blog/jabba/jabba-example.gif "Jabba in Action in a Powershell terminal"

Here's another dev thing I use: [Jabba](https://github.com/shyiko/jabba), a cross-platform Java version manager that works for Windows.

Over the the past few years, I've been doing JDK-based development in an enterprise Windows environment. In that time, I've continually struggled with being able to easily switch between versions of Java on my machine, depending on the project. We have legacy application that run old Java, and modern applications that run newer versions of Java. Being able to switch versions, without having to manually change my environment variables or handle mula

Now, that is no longer a problem thanks to my good friend, Jabba.

![Jabba in Action][1]

## What does it do?
Exactly what you think: it changes the version of Java you're running on the fly. No need to install anything or worry about conflicting versions, or searching out and installing the specific Java version you need for your project.

## Using Jabba
First thing is installing Jabba, which is a breeze thanks to the following the [instructions provided](https://github.com/shyiko/jabba#windows-10) in the repository README. After that, I included it in my Powershell profile so it initializes it when I start Powershell.

```
# Jabba
if (Test-Path "H:\Users\dw\.jabba\jabba.ps1") 
{ 
   . "${HOME}\.jabba\jabba.ps1" 
}
```

To test it out, I run a `refreshenv` command in the Powershell window, and run `jabba -h` to see if I get the help file.
The commands are pretty straightforward. You can list all the available versions, using `jabba ls-remote`, install the one(s) you need need with `jabba install my-version` and you're good to go to run that version of Java.

```
H:\src
> jabba
Java Version Manager (https://github.com/shyiko/jabba).

Usage:
  jabba [flags]
  jabba [command]

Available Commands:
  install     Download and install JDK
  uninstall   Uninstall JDK
  link        Resolve or update a link
  unlink      Delete a link
  use         Modify PATH & JAVA_HOME to use specific JDK
  current     Display currently 'use'ed version
  ls          List installed versions
  ls-remote   List remote versions available for install
  deactivate  Undo effects of `jabba` on current shell
  alias       Resolve or update an alias
  unalias     Delete an alias
  which       Display path to installed JDK

Flags:
      --version   version of jabba

Use "jabba [command] --help" for more information about a command.
```

And now you're good to go with whatever version of Java your current command line needs.

### Won't this conflict with my installed version of Java?
Nope. The [FAQ](https://github.com/shyiko/jabba#faq) section of the README covers that.

In my case, I uninstalled all the different JDK's I had installed to ensure there were no conflicts, and I like to remove tools I'm no longer needing on my machine.

### But what about my really old legacy JDK on my machine?
If you check the [usage](https://github.com/shyiko/jabba#usage) section of the README, you can use Jabba to install JDKs that are hosted in a custom spot.

In the case of the depracated versions of Java that are difficult to come by, I use the Zulu or OpenJDK versions that are available through Jabba. You can see them when you run `jabba ls-remote`. It's not an exact replica of the Oracle JDK, but I haven't hit any issues in my legacy enterprise applications.

## What makes it cool?
My prefernce for any dev tool is to have it available through the command line.

When it comes to Java and Windows, the command line tools out there for Java are a bit limited. The standard answer seems to be to use Powershell to update your environment variables, but that doesn't solve the need to find and install the version I need.

Jabba solves that for me.

Plus, since it's written in Go, it works on OSX and Linux, so anyone can use the tool.

And just to put some more icing on the cake, the solo developer building Jabba was kind enough to implement [a feature I supported](https://github.com/shyiko/jabba/issues/67#issuecomment-300869749) on over a weekend which made the tool work even better for me at work and at home. So, thank you [Stanley Shyiko](https://github.com/shyiko).

## What are the drawbacks?
I haven't hit any so far, which is pretty impressive considering I use this tools almost every day.

---

If you're an enterprise Java developer that needs to support legacy applications, I would strongly suggest taking a look at Jabba. With [Windows 7 extended support ending](https://support.microsoft.com/en-ca/help/13853/windows-lifecycle-fact-sheet) in the next few years, your enterprise will be looking to move you to a new OS, Windows 10 or otherwise. 

With Jabba, you'll at least have a tool that works regardless of how your development machine changes.

