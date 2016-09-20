---
layout: post
title: How to Build ReactJS with Gulp
categories:
  - JavaScript 
date: 2016-09-19 19:55:48
tags:
  - ReactJS
  - Gulp
  - JavaScript
  - Babel
excerpt: I started to tinker with React last week and needed to do some digging on how to transpile the React JSX files using Gulp. In this post, we walkthrough my newly updated Gulp task that transpiles JSX and JavaScript files.
authorId: david_wesst
originalurl: https://blog.davidwesst.com/2016/09/How-to-Build-ReactJS-with-Gulp/
---

I wanted to play with ReactJS last week and figured I would just add another gulp talk to my build process, being that it's all the rage right now.

It turns out that it wasn't that simple, as it turns out that the [`gulp-react`](https://www.npmjs.com/package/gulp-react) has been "deprecated in favor of gulp-babel". I hadn't planned on learning [Babel](http://babeljs.io/), but it turns out it wasn't very difficult once I was able to put all the pieces together.

Here's what I did.

You can find an extended version of the code in this post in my web project's [`gulpfile.js`](https://github.com/davidwesst/dw-www/blob/master/gulpfile.js). As of this writing, it can be found in the `feat/talks` branch but should be merged into the [`master`](https://github.com/davidwesst/dw-blog) branch  soon enough.

## The Gulp Task
Let's start with the gulp task and I'll walk you though it step by step.

```javascript
// packages 
var gulp        = require('gulp'),
	babel		= require('gulp-babel'),
	sourcemaps	= require('gulp-sourcemaps');
    
// build all the JavaScript things
gulp.task('build-script', function() {
	var src = [
		'./src/script/*.js',
		'./src/components/*.jsx'
		];

	return gulp.src(src)
				.pipe(sourcemaps.init())
				.pipe(babel({
					presets: [
						'es2015',
						'react'
						]
					}))
				.pipe(concat('dw.js'))
				.pipe(gulp.dest('./dist/script'));
});
```

It's not overly complex, but there is a lot going on. Let me walk you though it.

### Dependencies

```javascript
// packages
var gulp        = require('gulp'),
	babel		= require('gulp-babel'),
	sourcemaps	= require('gulp-sourcemaps');
```

These are the packages I used in this solution. Here's the breakdown in case you don't feel like searching out each one:

+ [gulp](https://www.npmjs.com/package/gulp) is the build tool itself
+ [gulp-babel](https://www.npmjs.com/package/gulp-babel) is the babel plugin that builds react for us
+ [gulp-sourcemaps](https://www.npmjs.com/package/gulp-sourcemaps) is a pluging that generates sourcemaps for us

There are a couple of unlisted packages that you'll need as well. More specifically, the Babel preset packages. I use two:

+ [babel-preset-es2015](https://www.npmjs.com/package/babel-preset-es2015) because writing modern JavaScript is awesome and helps with writing ReactJS code.
+ [babel-preset-react](https://www.npmjs.com/package/babel-preset-react) which does the ReactJS stuff we need

**NOTE: You don't need the es2015 preset package, but you should use because you don't hate yourself enough to write old JavaScript**

### Pipeline

Things start simple with the declaration of my source files and kicking off the gulp pipe:

```javascript
var src = [
		'./src/script/*.js',
		'./src/components/*.jsx'
		];

	return gulp.src(src)
```

Next up, I intialize the sourcemaps plugin

```javascript
.pipe(sourcemaps.init())
```

If you're not sure what sourcemaps are, [look them up](http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/) as all the browser development tools support them and they made debugging transpiled code much easier.

Now, we leverage all the Babel things and do the actual transpilation.

```javascript
.pipe(babel({
presets: [
    'es2015',
	'react'
]
```

At this point were piping our source code into Babel, and it applies the preset [babel plugins](https://babeljs.io/docs/plugins/) for ES2015 and React. If you didn't include the presets earlier, you would get an error at this point so make sure they're installed.

Now we just write out our sourcemaps and our newly compiled JavaScript and JSX files to our output directory.

```javascript
.pipe(sourcemaps.write('.'))
.pipe(gulp.dest('./dist/script'));
```

Et voila! Your gulp task transpiles your JSX and JS files. You can even use some [ES2015](https://babeljs.io/docs/learn-es2015/) to boot.

