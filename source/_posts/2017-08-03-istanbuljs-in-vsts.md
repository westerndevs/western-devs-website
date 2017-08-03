---
title: IstanbulJS Code Coverage Reports in VSTS
category:
    - development
tags:
    - javascript
    - visual studio team services
    - istanbuljs
    - nyc
    - testing
excerpt: "Here's another dev thing I use: IstanbulJS in Visual Studio Team Services (VSTS) builds and display the test reports as part of the build reports."
layout: post
date: 2017-08-03 12:10:00
authorId: david_wesst
---

[1]: https://istanbul.js.org/
[2]: https://www.visualstudio.com/team-services/continuous-integration/
[3]: https://davidwesst.blob.core.windows.net/blog/istanbuljs-in-vsts/vsts-code-coverage-report.gif "VSTS Build Report with an IstanbulJS code coverage report"
[4]: https://github.com/istanbuljs/nyc
[5]: https://mochajs.org/
[6]: http://www.westerndevs.com/development/mocha-in-vsts/
[7]: https://docs.npmjs.com/misc/scripts
[8]: https://github.com/istanbuljs/nyc#configuring-nyc
[9]: http://anthonychu.ca/post/css-styles-vsts-code-coverage/
[10]: https://www.npmjs.com/package/inline-css

Here's another dev thing I use: [IstanbulJS][1] in [Visual Studio Team Services][2] (VSTS) builds and display the test reports as part of the build reports. When a build completes, I get a report like this one.

![VSTS Build Report with an IstanbulJS code coverage report][3]

I can browse the report right in the build report, and drill into the results for each file.

This is how I did it.

## Step 0: Assumptions
I'm not going to go into the details on how to setup IstanbulJS or a test suite, but you'll need a project with tests and uses the IstanbulJS command line tool, [NYC][4], to run them. My suggestion is to use [Mocha][5] as [the test report can be integreated into VSTS as well][6].

You'll also need a VSTS account, which is free and worth the effort.

## Step 1: Script Your Command
The goal here is to be able to run a script command that will execute the appropriate code coverage command, complete with parameters, easily. I use [npm scripts][7] for this tutorial, but you can use whatever scripting tool you'd like.

In my case, I like to run the code coverage report everytime I run my Mocha tests. So, I've updated my `npm test` command in _package.json_ to use NYC. It looks like:

```
  "scripts": {
    "test": "./node_modules/.bin/nyc ./node_modules/.bin/mocha --recursive --reporter=mocha-multi-reporters "
  }
```

Note, that I don't use globally installed packages. I only use the local ones installed in my _node\_modules_ folder.

## Step 2: Configuring NYC
I've configured it in the _package.json_ file with an `"nyc"` configuration object. Mine looks like this:

```
  "nyc": {
    "check-coverage": true,
    "per-file": true,
    "lines": 99,
    "statements": 99,
    "functions": 99,
    "branches": 99,
    "include": [
      "src/**/*.js"
    ],
    "reporter": [
      "text",
      "cobertura",
      "html"
    ],
    "report-dir": "./.test_output/coverage"
  }
  ```

The part of the configuration we care about for this tutorial are the `"reporter"` and `"report-dir"` properties. The rest of the configuration is out of scope for this post, but you can learn more in the [nyc README configuration section][8].

For `"reporters"`, you can see that we are using three different reporters. The _text_ reporter is the one that displays in the terminal, the _cobertura_ reporter generates an XML file with all of the results which we'll need, and the _html_ reporter generates the HTML files you saw me browsing at the beginning of this post.

At this point, when we run `npm test` we get run our tests and generate the code coverage assets we want.

## Step 3: Post-Processing the HTML Report
This one isn't obvious, but I'm going to save you the trouble of discovering it for yourself.

That being said, if you don't mind the plain text reports sans-CSS, you can skip this step altogether.

Our HTML report is going to get displayed in VSTS. Remember, the HTML report isn't just a single file, it's a bunch of HTML files complete with CSS for styling. VSTS doesn't natively load up the extra CSS files, which means we'll need to embed the CSS right into the files themselves to create a copy of the report that'll look good in VSTS.

Thanks to [this post from Anthony Chu][9], I had a headstart on figuring out how to solve this issue. The plan is to run a post-processing script on the _posttest_ script command in npm. I called my script file _process-coverage-report.js_ and updated the scripts section of my _package.json_ to look like this:

```
"scripts": {
  "test": "./node_modules/.bin/nyc ./node_modules/.bin/mocha --recursive --reporter=mocha-multi-reporters ",
  "posttest": "node ./tools/process-coverage-report.js"
},
```

The _posttest_ script will everytime we run `npm test`. You can also call it directly by running `npm run posttest` but be sure to have test results for it to process.

I'll cut to the case, and just show you my post-processing code.

```
let fs = require("fs"),
    path = require("path"),
    inline = require("inline-css");

const TEST_RESULTS_DIRECTORY = "./.test_output";
const CODE_COVERAGE_DIRECTORY = "./.test_output/coverage";

fs.readdir(CODE_COVERAGE_DIRECTORY, (err, files)=> {
    if(err) { throw new Error(err); }

    let reports = files.filter((report)=> {
        return report.endsWith(".html");
    });

    reports.forEach((report)=> {
        let filePath = path.join(CODE_COVERAGE_DIRECTORY, report);
        let options = { 
            url: "file://" + path.resolve(filePath),
            extraCss: ".pad1 { padding: 0; }"
        };

        fs.readFile(path.resolve(filePath), (err, data)=> {
            inline(data, options)
                .then((html)=> {
                    let outputFile = path.join(TEST_RESULTS_DIRECTORY, report);
                    fs.writeFile(outputFile, html, (err)=> {
                        if(err) { throw err; }
                    });
                })
                .catch((err)=> {
                    console.log(err);
                });
        });
    });
});
```

My build doesn't use a task runner like Gulp I settled on [inline-css][10] because I liked the API and it returned promises. If you're using Gulp or Grunt, there are some good options ([as suggested by Anthony][10]) for you to create a task to do this for you.

Now, when you run `npm test` you'll end up with an extra copy of the HTML report, where you have nothing but HTML files with CSS embedded in the files themselves.

## Step 4: Adding this to VSTS
All you need to do here, is configure your build to use the new code coverage setup. We do that by adding the _Publish Code Coverage Results_ task as a build step and configuring properly. Here's what my configuration looks like:

* Version:  1.*
* Display Name: Publish Code Coverage Results \| NYC
* Code Coverage Tool: Cobertura
* Summary File: $(System.DefaultWorkingDirectory)/.test_output/coverage/cobertura-coverage.xml
* Report Directory: $(System.DefaultWorkingDirectory)/.test_output     |

Your properties may vary, depending on how to configured NYC.

## Step 5: Done
And now we code coverage reporting showing up in VSTS. Huzzah!

Happy code covering!