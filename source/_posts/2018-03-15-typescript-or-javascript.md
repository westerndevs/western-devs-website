---
layout: post
title: "Picking between TypeScript and JavaScript"
tags:
  - JavaScript
  - TypeScript
categories:
  - Development
authorId: david_wesst
date: 2018-03-15 11:40:00
---

Which one should you pick: TypeScript or JavaScript? They are both great languages, but there is constantly a questions about when you should use each of these languages. This post puts that to rest.

<!-- more -->

[1]: https://i.imgur.com/Wxx5fMI.png
[2]: https://i.imgur.com/IAPRGfv.png
[3]: https://i.imgur.com/yCn8NUQ.png
[4]: https://code.visualstudio.com
[5]: https://github.com/tc39/ecma262
[6]: https://code.visualstudio.com/docs/languages/javascript#_type-checking-and-quick-fixes-for-javascript-files

Whether it's a work project or a personal one, the question "TypeScript or JavaScript" always seems to come up in my mind. Utlimately, they provide a very similiar function considering that TypeScript is a superset of JavaScript, and compiles down to JavaScript itself. 

I'm not the only person that has this question either. Over the past year, I've asked a number of JavaScript/TypeScript developers about how they pick between the two and I wanted to sum up my thoughts here after being influenced by my private panel of experts.

## It Depends on the Project
Of course it does. 

There is never one answer for everything, and this is no different. That being said, there are a few criteria or "flags" that help me select when I want to use one over the other.

### JavaScript Knowledge is Assumed
Before we get into it, let me clarify that I'm assuming that the developer(s) working on the project already know JavaScript. They don't need to be experts, but they are familiar with writing vanilla JavaScript for applications, whether that be client or server side code.

That being said, I'm also assuming that a TypeScript-focued developer can get their way around JavaScript code.

## When to TypeScript

![][2]

I fall to TypeScript when I am writing more than one or two code files or if I'm writing code that I expect someone else to have to run. Although I use TypeScript, the it's not necessarily the language itself that I want, but the TypeScript compiler as it helps the other developers running my code, and removes the ambiguity of types between functions or classes that need to work togther.

It does a lot of stuff for me:

  + Catches errors, especially typing ones, at compile time rather than run time
  + Sets standards around what JS-like conventions I want to use
  + Better legacy browser support
  + Supports multiple module practices

Ultimately, that compiler is powerful and I put a lot of trust into it considering I expect that the compiled code to be optimal.

### But doesn't the compiler work on JavaScript too?
Yes. Yes it does.

The catch is that the compiler is not as thurough as it is with TypeScript. When you add the `//@ts-check` [reference][6] at the top of your JavaScript file in Visual Studio Code, that really helps with the development story of any JavaScript code, but it's still not as deep as using TypeScript itself.

Using TypeScript with the TypeScript compiler gives you that little bit of extra help in development, and that is really where the value comes in for me.

## When to JavaScript

![][3]

I tend to use JavaScript when I'm only writing a little bit of code and don't want to deal with the overhead of setting up the compiler for the project. For examples, when I'm writing a little Node script, or experimenting with REST API and want a simple GUI, I'll quickly put together some vanilla JS code and get something working quickly.

That being said, I write the majority of my JavaScript in [Visual Studio Code][4] which provides a lot of JavaScript tooling support using the TypeScript compiler underneath the hood.

## Conclusion
In conclusion, when I have to pick between JavaScript or TypeScript I lean towards TypeScript. It provides the better development story between the two, and that's a really important factor when I'm writing and sharing code.

When I'm lazy and don't want to setup a TypeScript project, I fall back on JavaScript but still rely on the built-in TypeScript tooling in Visual Studio Code.

TypeScript provides the tooling and needed bit of abstraction from the implementation with its compiler. Even though JavaScript has come a long way with [ECMA-262][5] getting plenty of updates, there is still the challenge of browser vendors supporting the spec and so on. In the end, the overhead of setting up your project to using the TypeScript compiler outweighs the complexity that large JavaScript projects bring to the table.

Even when JavaScript is "feature complete", I'm guessing that TypeScript will still provide a stronger developer story for larger software projects, while JavaScript will continue to provide the foundation for the web platform, and TypeScript itself.