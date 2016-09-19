---
layout: post
title: How to Compile Typescript into a Single File with AMD Modules with Gulp
date: 2016-09-12 08:25:01
tags:
  - typescript
  - javascript
  - amd
  - requirejs
  - gulp
excerpt: The lessons I learned and the steps I took to compile TypeScript modules into a single file with AMD modules using Gulp, along with how I consumed those compiled modules in my HTML application.  
authorId: david_wesst
originalurl: https://blog.davidwesst.com/2016/09/How-to-Compile-Typescript-into-a-Single-File-with-AMD-Modules/
---
I've been tinkering with TypeScript lately and was trying to setup my project to compile all of my modules into a single file, which would then be used in an HTML page. Maybe this is obvious to the more experienced TypeScript developer, but I had made a number of false assumptions while trying to get this to work.

This post will walk you through what I did to setup my build and get it working in an HTML page.

**You can follow along at home with the source code which I've put up on [GitHub](https://github.com/davidwesst/ts-project-template)**

## Modular TypeScript
My project is starting out simple, with a single module and a couple of different "Apps" that will use the module. Module in TypeScript is extensively documented in the [TypeScript Handbook](), so if you're not familiar with this I would suggest reading up on it as it's pretty awesome once you start using it.

In any case, here's my code:

```typescript
// ModuleOne.ts

export class ModuleOne {
    sayHello() {
        console.log("Hello from Module1!");
    }

    sayHelloTo(who: string) {
        console.log("Hello " + who.trim() + ". This is Module1");
    }
}
```

```typescript
// ModuleTwo.ts

export class ModuleOne {
    sayHello() {
        console.log("Hello from ModuleTwo!");
    }

    sayHelloTo(who: string) {
        console.log("Hello " + who.trim() + ". This is ModuleTwo");
    }
}
```

```typescript
// App.ts

import * as Module1 from "./modules/Module1";
import * as Module2 from "./modules/Module2";

export class App {
    start() {
        let m1 = new Module1.ModuleOne();
        let m2 = new Module2.ModuleTwo();
        
        m1.sayHelloTo("David Wesst");
        m2.sayHelloTo("David Wesst");
    }
}
```

I have a single application that is using two modules. Plain and simple. Next up, I compile my code into a single file, then reference that in my HTML, and done like dinner.

...or so I thought.

 ## The `--outFile` Parameter
 Reading through the doucmentation about TypeScript compilation, I found the `--outFile` or `--out` parameter in the [documentation](https://www.typescriptlang.org/docs/handbook/compiler-options.html). I immediately assumed that I was done, as I would simple choose my ES target, select the type of modules I would like, and presto. 
 
 That wasn't the case.

 Being a person who likes modern JavaScript, I had originally opted to output ES6 compatible code complete with the new modules. 
 
 This is was my first mistake. 
 
 I found was that when I compiled, I would get a single output file but it would be completely blank. No error, but just an empty file. This is expected behaviour, as the `--outFile` option only supports _commonjs_ and _amd_. That meant no ES6 or even ES2015 modules for my project, which is probably for the best considering how few web browsers in the wild actually support ES6 modules as of this writing.

 In the end, I decided to go with AMD modules as I had some experience with [RequireJS](http://requirejs.org/).

 Now, when I try to compile again it works as expected! One big JavaScript file ready to go.
 
 ...sort of.

 ## Using My Compiled TypeScript
  
Somewhere along the line, I assumed that whatever JavaScript file I compiled would only need me to add a `<script>` tag reference to point to it like any other JavaScript file. 

This was my second mistake, albeit a pretty silly one.

AMD modules have always needed RequireJS to load properly. That's the purpose for RequireJS. Maybe I had assumed the TypeScript compiler would embed this library or something, but whatever my reasoning it was wrong. I needed to include a `data-main` file, as you do with every RequireJS example.

I added this to my HTML file, along with the RequireJS library in my project:

```html
<script data-main="main" type="text/javascript" src="lib/require.js"></script>
```

Then, my `data-main` file goes something like this:

```javascript
// main.js
  
requirejs.config({
    baseUrl: 'lib',
    paths: {
        'App':'../app'
    }
});

requirejs(['App'], function(MyApp) {
    console.log('starting application...');

    var app = new MyApp.App();
    app.start();
});
```

I'm not going to go into the details here, but my `paths` object in the `requirejs.config` is pointing `App` to our outputted file. We use this in our main function and point our compiled modules to the `MyApp` object. We then call the `start()` function on our exported class and we are off to the races. 

When we run the application, we see the following in the JavaScript console.

![What the console window should look like](http://i.imgur.com/38ngK52.png)

## Details on Compilation
I skipped that part on purpose, because I don't use the TSC compiler directly. Rather, I use [`gulp-typescript`](https://github.com/ivogabe/gulp-typescript) with a `tsconfig` file to compile my TypeScript and create sourcemaps for them. All of this is detailed on the [package page](https://www.npmjs.com/package/gulp-typescript), but I'll include my gulp task to make sure you have all the details in one place. 

You're welcome. ;)

```javascript
var tsProject = ts.createProject('tsconfig.json');

gulp.task('build-ts', ()=> {
    let tsResult = tsProject.src()
                    .pipe(sourcemaps.init()) // using gulp-sourcemaps as prescribed by gulp-typescript
                    .pipe(ts(tsProject));
    
    return tsResult
            .js
            .pipe(sourcemaps.write('./'))
            .pipe(gulp.dest('./dist'))
            .pipe(connect.reload());  // I use gulp-connect to watch and reload the page as I develop
});
```

Oh, and here's my `tsconfig.json` file too.

```javascript
{
    "compilerOptions": {
        "module": "amd",
        "rootDir": "./src/ts",
        "sourceRoot": "./src/ts",
        "outFile": "app.js",
        "target": "es5"
    },
    "exclude": [
        "node_modules",
        "dist"
    ]
}
```
