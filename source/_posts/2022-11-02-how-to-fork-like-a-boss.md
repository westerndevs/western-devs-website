---

title: "How to fork (a repo) like a boss!"
date: 2022-11-02T12:00-05:00
tags:
- github
- pull requests
- contribution
- open source
excerpt: "Everyone thinks about forking. It is a natural thing, yet how do get the job done and fork? I used to ask myself the same thing, until I learned these pro-tips and forked like a boss."
authorId: david_wesst
originalUrl: https://www.davidwesst.com/blog/how-to-fork-like-a-boss/

---

[1]:https://github.com/solution-loisir/markdown-it-eleventy-img
[2]:https://github.com/solution-loisir/markdown-it-eleventy-img/pull/9
[3]:https://github.com/solution-loisir/markdown-it-eleventy-img/issues/8
[4]:https://github.blog/2012-09-17-contributing-guidelines/

My name is David Wesst and today I am going to teach you to fork like a boss! No special tools. No special creams. Just your clicking finger and a bit of confidence to use your coding skills.

Before I forked, I thought I forking wasn't for me. I thought, I am too old to fork, but man oh man was I wrong. But then came the day where a library I was using was missing a critical feature, and a quick search through the repository issues found [that others were looking for that feature too][3].

![Screenshot of GitHub issue with title "Question about whether the relative path is base on current working dir or current md file?" with the first entry in the issue describing how their blog posts have images in the same directory as the post](/images/2022-11-02-how-to-fork-like-a-boss/gh-issue.jpg)

## Choosing to Fork

This is the moment where I got to choose. I had a options for my next move:

1. Add to the thread and hope for the best 
2. Built my own solution from scratch 
3. Take a look through the code and see if its forkable

The first choice makes sense if you don't have the knowledge or skills.

The second choice feels easier, but that is only your fear of contributing getting the best of you. When you add to your codebase, you are adding more code to support in the long run and all comes with that.

The last choice might make you nervous of you haven't forked in a long time, but I assure you, if you can code, you can fork. So browse through the code and see if you can find the spot your forking can help.

## Defining Forkability

This is very subjective, but when it comes to forkable projects for me, I look for the following things, in this order:

1. `CONTRIBUTING.md`, to give me a breakdown on how the community wants people to contribute
2. Tests, so I know I can mess around with the code without breaking existing functionality
3. Existing Issues and Pull Requests (PRs) to see what users, developers, and project owners are currently working on and their focus.

In my recent contribution to [markdown-it-eleventy-img][1], I went through the repo trying to figure out whether or not it was forkable. Although I didn't find a `CONTRIBUTING.md` ([but that could be a future PR][4]) but I found a set of tests, and even though I forgot in the moment, there was an existing issue from someone else about the same issue I was hoping to contribute!

And with that, I knew this project was forkable. So I pulled out my finger and clicked "FORK" like boss and coded up my solution, and [submitted a PR][2].

## Fork with Confidence and Respect

If you look through the [thread of the PR][2] you'll see that my solution went through a few iterations and changes after receiving feedback from the project owner.

This was a great conversation and it lead to a better solution implementation than my original submission, which made me exceptionally happy (and proud) of my contribution.

Even though it is volunteer labour, remember that both you AND the project owner/admins are choosing to spend their time reviewing and analyzing your work. Everyone is involved in the fork is investing time, and everyone should be treated with respect and as a professional.

Plus—this is a great opportunity to level-up your development soft skills. Enjoy yourself, but be timely and respect the investment everyone is making.

## Conclusion / TL;DR;

To fork like a boss, all you need is a project ready for contributions, some confidence, and respect for others on the project:

1. A `CONTRIBUTING.md`
2. Tests
3. Existing Issues and Pull Requests (PRs)

Thanks for playing.

~ DW

