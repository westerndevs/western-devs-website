---
layout: post
title: How to Use Highlight.Js with Bower and Gulp
date: 2016-08-29 10:07:11
tags:
  - gulp
  - bower
  - highlight.js
  - javascript
excerpt: One of the best libraries I've seen for syntax highlighting on the web is highlight.js, IMHO. The catch to using the library is that it takes a bit more effort to setup than just adding a script tag and being done with it. In this post, I'll walk you through the steps I took to get this up and running with Bower and Gulp.
authorId: david_wesst
originalurl: https://blog.davidwesst.com/2016/08/How-to-Use-HighlightJs-with-Bower-and-Gulp/ 
---

One of the challenges I faced when getting my new blog theme up and running was getting [highlight.js](https://highlightjs.org) working as I wanted it to. The library has support for a riduculous number of languages, and provides theming capabilities, so it was the clear choice when it came to syntax highlighting for the web. The challenge is that tt's not just adding simple script tag and you're done with it. They seem to expect you to know what you're doing when consuming the library. 

Remember: this is a _good thing_. 

If you're only include code snippets for HTML and JavaScript, why would you want to bring down the stylesheets for D, Erlang, and ActionScript too? Same goes for the themes too. You're likely going to pick a single theme and go with it, and not need all 77 they include. Because of the size of highlight.js, bringing it all down to the client would have a significant impact on your site's performance.

Lucky for us, the folks in charge of highlight.js have given us all the tools we need to make using the library in our application nice and performant. In my case, I use [Bower](https://bower.io) as my package manager and [Gulp](http://gulpjs.com) as my build system, which worked well once I figured out what I was doing. Let me walk you though it.

## Installing Highlight.js with Bower
To start, you'll need to add highlight.js to your project using Bower.

```bash
bower install --save highligh.js.origin
```

Generally speaking, after you install a package from Bower you have a ready-to-use JavaScript library. With highlight.js, this is not the case. Rather, you are left with source code ready to be built as you need it. To do that, we are going to use Gulp.

## Building Highlight.js with Gulp
The hard work has already been done by the highlight.js team, as they have already included a lovely build tool for us to use. You can read about the details [here in the building and testing documentation](http://highlightjs.readthedocs.io/en/latest/building-testing.html). 

There are two parts to "building" highlight.js: the JavaScript and the stylesheets. We'll be creating a task for each of them.

### Building highlight.js JavaScript
Let's start with the JavaScript component.

If you read the [docs](http://highlightjs.readthedocs.io/en/latest/building-testing.html) earlier, you know that there is a NodeJS script in the `tools` directory that will do all the heavy lifting. All we need to do in our Gulp task is use that script.

Here's my Gulp task:

```javascript
gulp.task('process-highlightjs-script', function(callback) {
    let command = 'cd bower_components/highlight.js.origin'
                    + ' && npm install' 
                    + ' && node tools/build :common';
    exec(command, (err, stdout, stderr)=> {
        console.log(stderr);
        console.log(stdout);

        callback(err);
    });

    return;
});
```

It looks a little strange for a gulp task, but all I'm doing is executing a shell command using the [`exec`](https://nodejs.org/api/child_process.html#child_process_child_process_exec_command_options_callback) in NodeJS to spawn a child process. The important part is in the `command` variable. Let's walk through it.


```bash
cd bower_components/highlight.js.origin
```

First, I'm moving into the root directory of the highligh.js.origin package we previously installed using Bower.

```bash
npm install
```

Then, I'm installing the dependencies that are needed by the provided build tool.

```bash
node tools/build :common
```

Finally, I'm running the build command as specified in the documentation. This part should be changed to make sure it includes the languages you want to display in your application. Details are in their [documentation](http://highlightjs.readthedocs.io/en/latest/building-testing.html).

The rest is just outputting the standard out and standard error streams to the console, and calling the Gulp callback to make sure we come back to our original process, as per the [Gulp documentation](https://github.com/gulpjs/gulp/blob/master/docs/API.md#async-task-support). 

If everything is done correctly, you should have a new `build` folder in the `highlight.js.origin` folder that contains your newly build library.

## Building Highlight.js Themes for SASS
I suppose this part is optional, but it shouldn't be.

To make optimize your site, you should be minimizing the number of requests that the client browser needs to make to get all the required resources for your application. For styling, that involves concatenanting all of your styles and style libraries into a single file.

To do this, I use [SASS](http://sass-lang.com) or, more specifically, [gulp-sass](https://www.npmjs.com/package/gulp-sass) to build all of my stylesheets and combine them into a single CSS file as described by the [SASS documentation](http://sass-lang.com/guide#topic-5). I'm going to assume that you're doing the same, or at least something similar in your application that will be using highlight.js.

Because SASS only handles combining other `scss` files, I copy the theme stylesheet into a newly named `scss` file. Here's my gulp task for that:

```javascript
gulp.task('process-highlightjs-style', function() {
    let stylesheets = [
        './bower_components/highlight.js.origin/src/styles/atom-one-dark.css'
    ];

    return gulp.src(stylesheets)
            .pipe(rename('highlight.js.scss'))
            .pipe(gulp.dest('./bower_components/highlight.js.origin/scss'));
});
```

Then in my main stylesheet, I include:

```scss
@import '../../bower_components/highlight.js.origin/scss/highlight.js';
```

This will bring in the `highlight.js.scss` file when I build my styles using `gulp-sass` in my application stylesheet build task.

And now highlight.js ready to Use in our application.

<figure class="image">
    ![Highlight.js in Action](http://i.imgur.com/1cUniu9.png)
    <figcaption>Highlight.js in Action</figcaption>
</figure>

#### Caveat About Using Highlight.js with Markdown
My post assumes that for any blocks of text where you want syntax highlighting you're comfortable using the default [highlight.js usage](https://highlightjs.org/usage/) behaviour of wrapping the code with `<pre><code>` elements.

Although I blog using Markdown, at the time of this writing I still wrap my text with these elements, unlike [GitHub flavoured markdown](https://help.github.com/articles/creating-and-highlighting-code-blocks/) that lets define the language using regular Markdown syntax.

The reason for this, is that my blog engine renders the Markdown syntax with a bunch of extra HTML woven throughout the code to display it without the need for a library like highlight.js. 

It might not be a big deal for you or your project, but I thought it was something you should be aware of when if you're planning on using highlight.js in your application.

