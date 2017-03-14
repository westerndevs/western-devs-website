---
layout: post
title: How to Compile TypeScript into a Single File with SystemJS Modules with Gulp
categories:
  - javascript
date: 2017-03-14 09:47:22
tags:
  - javascript
  - typescript
  - systemjs
  - modules
  - gulpjs
excerpt: I decided to move a TypeScript project from AMD modules (i.e. RequireJS) to SystemJS, still using Gulp. In this post, I walk you through the sample project I've created and share the lessons I learned along the way.
authorId: david_wesst
originalurl: https://blog.davidwesst.com/2017/03/How-to-Compile-TypeScript-into-a-Single-File-with-SystemJS-Modules-with-Gulp/
---

I've been messing around with TypeScript again for my [game project](https://blog.davidwesst.com/2017/03/Intital-Thoughts-on-Using-Phaser/) and wanted a module loader to consume the single file produced by the TypeScript compiler. This time around I decided to use SystemJS and figured I'd share the lessons I learned along the way.

##### Sample Project
If you're interested in playing with the code, you can checkout [this GitHub project](https://github.com/davidwesst/ts-systemjs) I setup just for that reason.

##### Previous Post
I also posted about doing the same sort of thing [with AMD and RequireJS](https://blog.davidwesst.com/2016/09/How-to-Compile-Typescript-into-a-Single-File-with-AMD-Modules/) complete with [a GitHub sample project](https://github.com/davidwesst/ts-project-template)

## Project Breakdown
Here's the gist of it. My project has the following requirements:

1. Source code in TypeScript, organized in to multiple modules
2. Load external modules into application as dependencies
3. Transpile down to a single bundle file
4. Load the bundle in the browser

It seems pretty straight forward, right? Plus, because I'm using TypeScript I figured this would be easy peezy lemon-squeezy with the [TypeScript compiler](https://www.typescriptlang.org/docs/handbook/compiler-options.html) and rich documentation.

As it turns out, it wasn't that simple.

### Wait. Where's GulpJS?
It's in the sample project handling the transpiling the TypeScript through a task. 

It's actually not required, but rather a convienience for keeping all my build tasks together. I just put it in the title, because it matches the previous post.

## Problem 1: Using an External Module
I wanted to use [Moment.js](https://momentjs.com/) to help handle date objects with my code.

There were two parts to this: 

* Getting it working in the development environment
* Getting it bundled up with SystemJS.

### Using it in Development
I use [Visual Studio Code](https://code.visualstudio.com/), which is a great TypeScript development environment. 

Normally, you would use the [`@types`](https://www.npmjs.com/search?q=%40types) collection of defintion files from the NPM which is wired up by default. For Moment, we need to break that.

The definition file for Moment is found in the library itself. Since I use NPM to handle all my dependencies, you just set this up in your `tsconfig.json` file.

![](http://i.imgur.com/TyAgU0N.png)

Then, in code, we import it.

```javascript
import moment from "moment";
```

Remember: if your project is already using `@types` definition files, you'll need to add that folder to the `typeRoots` collection yourself.

### Bundling it Up
Because we're using SystemJS, we need to do is configure it as a path to understand where to find the library when it gets referenced.

In the [sample project](https://github.com/davidwesst/ts-systemjs), we do it in `script` tag on the HTML page, but you can do this in wherever you end up doing your SystemJS configuration.

```javascript
SystemJS.config({
    "paths": {
        "moment": "https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.17.1/moment.min.js"
    }
});
```

## Problem 2: Loading the Bundle
Making a bundle is easy. Consuming the bundle is something different.

### Making a Bundle
If you're interested in bundling your code into a single file with the compiler, you're limited to AMD or SystemJS modules. This is configured in the `tsconfig.json` file included in [the sample project](https://github.com/davidwesst/ts-systemjs) with the module property. You can read more about it [here in the TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/modules.html).

![](http://i.imgur.com/gUGeHfI.png)

### Consuming the Bundle
This is where I got stuck.

Now I have this fancy bundle, but I need to figure out how to consume it in my HTML page. The solution is pretty simple, but it took some research and some tinkering, but I got there.

Take a look at the `<body>` take of the HTML file:

```html
&lt;body&gt;
    &lt;div id="display"&gt;
        &lt;!-- script will display content here --&gt;
    &lt;/div&gt;

    &lt;script src="https://cdnjs.cloudflare.com/ajax/libs/systemjs/0.20.9/system.js"&gt;&lt;/script&gt;
    &lt;script src="bundle.js"&gt;&lt;/script&gt;
    &lt;script&gt;
        SystemJS.config({
            "paths": {
                "moment": "https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.17.1/moment.min.js"
            }
        });

        SystemJS.import("game")
            .then((module)=&gt; {
                let g = new module.Game("display");
                g.start();
            })
            .catch((error)=&gt; {
                console.error(error);
            });
    &lt;/script&gt;
&lt;/body&gt;
```

I blame myself for getting stuck considering this sort all documented well in the [SystemJS documentation on GitHub](https://github.com/systemjs/systemjs). Either way, I had issues finding solid resources about using bundles. Hopefull this can help someone else in the future.

## Conclusion
My problems can be traced back to my lack of experience with JavaScript module loaders. And yes, I know that [ES6 Modules are coming](http://caniuse.com/#feat=es6-module), but the browsers are a ways away from having a full implementation (except for Safari). 

Until then, we'll be using TypeScript and [Babel](http://babeljs.io/) to help us get our modular JavaScript working in the browser.

