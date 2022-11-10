---

title: "How much is enough documentation?"
date: "2022-11-10T12:00:00-05:00"
tags:
- madr
- c4-model
- decision
- diagram
- documentation
- README.md
- CONTRIBUTING.md 
excerpt: "Documentation is important, but it takes a lot of time and if you are a solo developer, what documentation to you really need? Still, good docs can provide the context I forget after putting a project on the shelf, or explains how to fix something in older code I use, but haven't touched in a long time. So how much is 'enough' documentation and what types of documentation do I need to invest in give my future self the the best value for the effort I put in?"
thumbnail: "repo-with-docs.png"
thumnbail_alt: "File tree of a source code repository with a 'docs' folder containing a sub-folder entitled 'decisions' with a series of markdown files documenting technical decisions for the project."
originalUrl: "https://www.davidwesst.com/blog/how-much-is-enough-documentation/"
authorId: david_wesst

---

[1]: https://github.com/davidwesst/website/blob/main/CHANGELOG.md
[2]: https://www.freecodecamp.org/news/how-to-write-a-good-readme-file/
[3]: https://github.com/davidwesst/website/tree/main/docs/decisions
[4]: https://adr.github.io
[5]: https://github.com/davidwesst/website/blob/main/docs/decisions/0001-decisions-with-madr.md
[6]: https://c4model.com
[7]: https://github.com/davidwesst/website/blob/main/CHANGELOG.md
[8]: https://keepachangelog.com/en/1.0.0/

Documentation takes a lot of different forms. Decision requests, diagrams, and just plain ol' word filled documents. Historically speaking, I have been guilty of being that developer that loathed documentation, waited until the last minute, and usually produced something that won't provide much help when it is actually needed.

Being a solution architect during the day, I wanted to apply some of my new found skills (and appreciation) for documentation while [working on v10 of my website][1]. Ultimately, documentation is _necessary_, even on personal projects. If I think back to my own experience with my own projects, they can end up sitting on the shelve for a long time. When go back to revisit it, other than analyzing my own code (on prototype stuff) can be a serious time sink to even get things in a running state without any decent documentation.

## What do you _need_?

And I do mean _needed_ not _wanted_. Everyone _wants_ documentation of all kinds, but what does an audience of one (i.e., your future self) _need_ to get the project back off the shelve and into working order?

Like any good solution architect, I started to read, learn, and figure out what others consider "enough documentation" or "good documentation". I also spent time defining the problem I needed the documentation to solve, and landed on the following docs being "enough".

### The README

It might seem obvious but, I have read enough of my own empty or default `README.md` files to know that this is easily the most important piece of documentation you write. Without it, the project will require code analysis to figure out what it _actually_ is, and that is never good.

There are a lot of great examples `README.md` files on GitHub to look at, but I would suggest you start simple if you're just getting off the ground. My take was to include system requirements and the steps to setup, build, and start the project for the developer.

When searching for info on this, I really like [this article from Hillary Nyakundi][2] provided a great "how-to" on making a good `README.md`.

### Decisions (also known as ADs or Architecture Decisions)

This is one I picked up from my day job being a Solution Architect in a large enterprise. Decisions you make along the way need to be documented, even if it is only for yourself.

The idea is to document decisions that will have a long term impact on your project. Decided to document decisions? That can be documented. Decided that you only want your project to run on Azure? That can be documented. Decided to design your solution around a specific pattern? That can be documented.

You can document as many or as few decisions as you want. In the case of my website project, [I documented a few core decisions early on][3] because I wanted to remember _why I built it this way_. Even though I am adding content regularly and tweaking features frequently enough, I could shelve the development at any point.

In terms of format, there are plenty of ways to document decisions and why it is important, but I am not going to spend time explaining that. Instead I would recommend reading [how GitHub documents decisions][4]. That is where I started, and they have a great breakdown of the different format and tools that can support you, if you're inclined to get into the tooling.

For the website, I [decided to use MADR as my decision document template][5] and documented "why" I chose it as the first decision for the project and [documented it][5].

### Diagrams

The last bit of documentation I feel I _need_ (although it is not as important as the previous two) are solution diagrams.

Just like decision documentation, this is something that can take a lot of different forms. Personally, I am not a huge fan of diving into UML or any of the traditional diagram styles. I like diagrams that present well to multiple audiences and explain _one thing_ well. 

![A solution diagram example from the website project](/images/2022-11-10-how-much-is-enough-documentation/website-solution-overview.png)

The above diagram is one I created to explain how I setup all the pieces inside of Microsoft Azure to host my website. The diagram answers the question "What is necessary to host your application?" which goes beyond the code in my case.

There is no real format that I applied here, but I scoped it to focus on the Azure Infrastructure and service I needed to rebuild the solution in Azure from scratch. Almost like a high-level guide to explain all the different pieces that need to be setup and handled.

In regards to diagram formatting, although I did not use it in this example, the [C4 model][6] is something I have been messing around with to describe systems and projects in my day job. If you need a little direction, or are struggling to figure out "how to diagram" your project, it might be worth a look.

### Notable Mention: `CHANGELOG.md`

I wanted to highlight this, but also point out that it is definitely not required. A `CHANGELOG.md` allows you to document your progress.

I based [my CHANGELOG file][7] off of the format described at [keepachangelog.com][8]. It forced me to take a bit of time (really, like 15 minutes or so) to reflect on my effort and appreciate the effort I have put into the project. Plus, it tells the story of how the project has evolved over time; which, just like the decisions, provides context on how things got to where they are.

## Conclusion / TL;DR;

In short, the documentation I _need_ (not _want_) consists of the following, with the following priority:

1. `README.md` (that at least says how to setup, build, and run the project)
2. Decisions (using [MADR][4] or some other format of your choosing)
3. Solution Diagrams (that answer _one specific question_)
4. `CHANGELOG.md` (not required, but provides more context and forces you to appreciate the effort you have put into your project)

Thanks for playing.

~ DW

