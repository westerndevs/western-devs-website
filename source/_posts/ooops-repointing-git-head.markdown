---
layout: post
title:  "Ooops, Repointing Git Head"
date: 2015-08-31T09:01:05-04:00
categories:
comments: true
authorId: simon_timms
originalurl: http://blog.simontimms.com/2015/08/28/ooops-repointing-git-head/
alias: /ooops-repointing-git-head/
---

I screwed up. I force pushed a branch but I forgot to tell git which branch to push so it clobbered another branch.

    C:\code\project [feature/feature27]> git push -f
    Password for 'http://simon@remote.server.com:7990':
    Counting objects: 63, done.
    Delta compression using up to 8 threads.
    Compressing objects: 100% (61/61), done.
    Writing objects: 100% (63/63), 9.25 KiB | 0 bytes/s, done.
    Total 63 (delta 50), reused 0 (delta 0)
    To http://simon@remote.server.com:7990/scm/ev/everest.git
     + 0baa5b8...e9a1c19 develop -> develop (forced update)  <--oops!
     + dbe6fce...5557ae7 feature/feature27 -> feature/feature27 (forced update)

Drat, since I hadn't updated develop in a few hours there were a bunch of changes in it that I just killed. Fortunately I know that git is really just a glorified linked list and that nothing is ever deleted. I just needed to update where the head pointer was pointing. I grabbed the SHA of the latest develop commit from the build server knowing that it was late at night and nobody else was likely to have snuck a commit into develop that the server missed.

Then I just force updated my local develop and pushed it back up

    git branch -f develop bbff5b810a19383fb11950a5d1e36676dd3ca85d  <-- sha from build server
    git push

All was good again.  