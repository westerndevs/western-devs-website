---
layout: post
title: Why ChakraCore OSS is Important
categories:
  - javascript
  - nodejs
  - chakra
date: 2016-01-14 14:43:33
excerpt: It's pretty cool that Microsoft has released the source code of their JavaScript engine Chakra. But, why it is important and how do developers actually benefit from this? 
authorId: david_wesst
originalurl: http://blog.davidwesst.com/2016/01/Why-ChakraCore-OSS-is-Important/
---

Chakra is the new JavaScript engine developed by Microsoft, which was first released as part of the, [no longer supported](https://www.microsoft.com/en-ca/WindowsForBusiness/End-of-IE-support) Internet Explorer 9. This isn't a post about why Microsoft having more open source software (OSS) process is important, or how it "amazing" that they are turning a new leaf.

This post answers the question that I don't see people asking.: *why is having a OSS JavaScript engine important to anyone*?

Maybe you already know the answer to this, or maybe you're just too shy to ask, but I'm going to take a moment and try and give you some idea about why ChakraCore being open source is really cool.

![](http://blog.davidwesst.com/2016/01/Why-ChakraCore-OSS-is-Important/github-page.png)

### 1. Alternative JavaScript Engine for NodeJS

![](http://blog.davidwesst.com/2016/01/Why-ChakraCore-OSS-is-Important/nodejs-logo.png)

This might be the most important option for me, as NodeJS is my development platform of choice. But, for the first time in the history of NodeJS, there is any alternative to the V8 JavaScript engine that has been built into NodeJS rom the beginning.

I have no problems with V8. It's done well by me considering without it we likely wouldn't have NodeJS at all. But having an option provides more flexibilty to the developer. Maybe Chakra can is faster at certain things than V8, or provides more JavaScript features that you want to use for your project. Now you _can_ change it, which means all kinds of opportunity for NodeJS developers.

Plus, if you can change NodeJS to use ChakraCore, then why couldn't you sub in another engine like [SpiderMonkey](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey) or something else. It leads to more options, which leads to competition, and that is always healthy in my opinion.

### 2. Community Support and Pull Requests

![](http://blog.davidwesst.com/2016/01/Why-ChakraCore-OSS-is-Important/pull-request.png)

Oh no! Not another security gap in all the browsers! What ever will we do?

Until now, the only solution would have been to wait for an official release from the Microsoft team, hoping that they had all the details they needed. Now, the team can work _with_ the community directly and publically so that we know where things are at. If there is a security gap reported, people can find it, report it, *and fix it* by submitting a pull request directly to the team. 

Now, my browser can sleep comfortably at night.

### 3. Knowing How the Sausage is Made
As mentioned in the in YouTube announcement, Microsoft has decided to bet big on JavaScript as a whole which is why building a brand new JavaScript engine made sense for the business. Although it was a huge improvement over Trident, we still didn't know what was going into the engine and what made it work.

Now we can see how the engine actually works. No secret sauce, no magic, just code. This is great for people looking to use a JavaScript on sensitive projects, or in highly secure environments that require knowing all the insides and outs to a system before it can be considered. In those cases you can fork the project, make some changes for your environment, and continue to get support from the original team by merging their changes as they publish them.

## Bottom Line
JavaScript engines are a very specific tool, but if your application needs a scripting component or you need to interpret JavaScript directly, you're in luck because ChakraCore is out in the wild now. Fully supported by Microsoft, and is meant to be integrated with other software, it's a really great option for those that can use it.

Plus, if you don't like how IE or Edge is running your JavaScript, you can get to the bottom of the problem yourself and submit a pull request. No more hiding behind the curtain. Developers have information they need to provide direct feedback on how Edge can run better. 

In time, I think we'll see more than just NodeJS, but rather Chakra become the heart of a lot of cool projects. 

### What's Next?
Personally, I'm thinking of using it as an on-the-fly scripting engine where a game object has a script that needs to be interpreted during game play, like AI or some sort of behaviour. 

For now I'll probably start with getting it working on my Raspberry Pi. I have one sitting on my desk and I'm itching to get something cool working on it. Either way, I'll probably start with the [Windows 10 IoT](https://dev.windows.com/en-us/iot) page for some ideas, or take a stab at [embedding it into a project](https://github.com/Microsoft/ChakraCore/wiki/Embedding-ChakraCore).
