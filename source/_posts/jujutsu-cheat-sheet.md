---
title:  Jujutsu Cheat Sheet
authorId: simon_timms
date: 2025-11-05
originalurl: https://blog.simontimms.com/2025/11/05/jujutsu-cheat-sheet
mode: public
---



I've started playing around a bit with the source control tool [Jujutsu](https://github.com/jj-vcs/jj) which is commonly referred to as `jj`. Git has been my go to tool for what seems like decades now but in the before times I worked as a release engineer and made use of a huge stable of source control tools as our code base was spread over many versions and had been created from purchasing lots of other companies. For a while there I was working on a daily basis with
* ClearCase
* Perforce
* Subversion
* CVS
* Visual Source Safe
* Mercurial
* Git
* CCC/Harvest

I'm using Jujutsu at my day job now because it just layers transparently on top of git so I don't need to go seeking permission. I'm only a few days into using it and I'm not thoroughly convinced yet that it is better than git but I'm willing to keep trying.

Here are some of the commands I'm using so far:

Get the latest version of the code from a central repository locally

```
jj git fetch
```

Start new work from the latest mainline

```
jj new main@origin -m "Whatever I'm going to work on"
```

Bookmark the work with a name I'm going to use as a branch in git

```
jj bookmark my-feature-branch
```

Push my work up to Github
```
jj git push --allow-new
```

Create a new commit before my current one that I can squash into
```
jj new -B @ -m "Some description of the work"
```

Push individual files into the parent change 
```
jj squash path/to/file1 path/to/file2
```

I'll keep expanding this document with new commands as I uncover them.